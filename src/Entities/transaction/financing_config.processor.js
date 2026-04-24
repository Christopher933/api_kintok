const { pool } = require("../../_shared/bd");

const mapDbError = (error) => {
    if (error && error.sqlState === "45000") {
        return { status: 400, message: error.sqlMessage || error.message };
    }
    return error;
};

const round2 = (value) => Math.round((Number(value) + Number.EPSILON) * 100) / 100;
const round4 = (value) => Math.round((Number(value) + Number.EPSILON) * 10000) / 10000;

const parseISODate = (value) => {
    if (!value) return null;
    const raw = String(value).trim();
    if (!/^\d{4}-\d{2}-\d{2}$/.test(raw)) return null;
    const date = new Date(`${raw}T00:00:00.000Z`);
    if (Number.isNaN(date.getTime())) return null;
    return date;
};

const formatISODate = (date) => {
    const y = date.getUTCFullYear();
    const m = String(date.getUTCMonth() + 1).padStart(2, "0");
    const d = String(date.getUTCDate()).padStart(2, "0");
    return `${y}-${m}-${d}`;
};

const buildDueDate = (baseDate, paymentDay) => {
    const year = baseDate.getUTCFullYear();
    const month = baseDate.getUTCMonth();
    const lastDay = new Date(Date.UTC(year, month + 1, 0)).getUTCDate();
    const dueDay = paymentDay > lastDay ? lastDay : paymentDay;
    return new Date(Date.UTC(year, month, dueDay));
};

const addUtcMonths = (date, months) => {
    return new Date(Date.UTC(date.getUTCFullYear(), date.getUTCMonth() + months, 1));
};

const firstBillingMonth = (startDate, paymentDay) => {
    const monthBase = new Date(Date.UTC(startDate.getUTCFullYear(), startDate.getUTCMonth(), 1));
    const firstDue = buildDueDate(monthBase, paymentDay);
    if (firstDue.getTime() < startDate.getTime()) {
        return addUtcMonths(monthBase, 1);
    }
    return monthBase;
};

exports.getConfig = async () => {
    const [result] = await pool.query("CALL financing_config_get()");
    return result[0][0];
};

exports.updateConfig = async (body, actorUserId = null) => {
    if (!body?.tasa_interes_anual || !body?.plazo_meses_default || !body?.plazo_meses_min || !body?.plazo_meses_max) {
        throw { status: 400, message: "tasa_interes_anual, plazo_meses_default, plazo_meses_min y plazo_meses_max son requeridos" };
    }
    try {
        const [result] = await pool.query("CALL financing_config_update(?, ?, ?, ?, ?)", [
            body.tasa_interes_anual,
            body.plazo_meses_default,
            body.plazo_meses_min,
            body.plazo_meses_max,
            actorUserId,
        ]);
        return result[0][0];
    } catch (error) {
        throw mapDbError(error);
    }
};

exports.simulatePlan = async (body = {}) => {
    const [result] = await pool.query("CALL financing_config_get()");
    const cfg = result[0][0] || {};

    const tasaDefault = Number(cfg.tasa_interes_anual || 0);
    const plazoDefault = Number(cfg.plazo_meses_default || 1);
    const plazoMin = Number(cfg.plazo_meses_min || 1);
    const plazoMax = Number(cfg.plazo_meses_max || plazoDefault || 1);

    const tipoRaw = String(body.tipo || body.transaction_type || "credito").trim().toLowerCase();
    const tipoNorm = tipoRaw.replace(/[\s-]+/g, "_");
    const isContadoUnico = ["contado_unico", "contadounico"].includes(tipoNorm);
    const isContado = isContadoUnico || tipoNorm.startsWith("contado");

    let tasaAnual = body.tasa_interes_anual != null ? Number(body.tasa_interes_anual) : tasaDefault;
    let plazoMeses = body.plazo_meses != null ? Number(body.plazo_meses) : plazoDefault;
    if (isContadoUnico) {
        plazoMeses = 1;
    }
    if (isContado) {
        tasaAnual = 0;
    }
    const enganche = body.enganche != null ? Number(body.enganche) : 0;
    const precioTotal = body.precio_total != null ? Number(body.precio_total) : null;

    let saldoFinanciar = body.saldo_financiar != null ? Number(body.saldo_financiar) : null;
    if (saldoFinanciar == null && precioTotal != null) {
        saldoFinanciar = round2(precioTotal - enganche);
    }

    if (!Number.isFinite(saldoFinanciar) || saldoFinanciar <= 0) {
        throw { status: 400, message: "saldo_financiar (o precio_total con enganche) debe ser mayor a 0" };
    }
    if (!Number.isFinite(tasaAnual) || tasaAnual < 0) {
        throw { status: 400, message: "tasa_interes_anual debe ser mayor o igual a 0" };
    }
    if (!Number.isInteger(plazoMeses) || plazoMeses < 1) {
        throw { status: 400, message: "plazo_meses debe ser un entero mayor a 0" };
    }
    if (!isContado && (plazoMeses < plazoMin || plazoMeses > plazoMax)) {
        throw { status: 400, message: `plazo_meses fuera de rango. Usa valores entre ${plazoMin} y ${plazoMax}` };
    }

    const paymentDay = body.payment_day != null ? Number(body.payment_day) : 1;
    if (!Number.isInteger(paymentDay) || paymentDay < 1 || paymentDay > 31) {
        throw { status: 400, message: "payment_day debe estar entre 1 y 31" };
    }

    const startDate = parseISODate(body.start_date) || parseISODate(new Date().toISOString().slice(0, 10));
    if (!startDate) {
        throw { status: 400, message: "start_date inválida. Usa formato YYYY-MM-DD" };
    }

    const tasaMensual = tasaAnual / 100 / 12;
    const factorMensual = round4(1 + tasaMensual);
    let mensualidadBase = 0;
    if (tasaMensual === 0) {
        mensualidadBase = round2(saldoFinanciar / plazoMeses);
    } else {
        // Replica la corrida de Excel: saldo_k = (saldo_{k-1} - pago) * factorMensual
        mensualidadBase = round2(
            saldoFinanciar * Math.pow(factorMensual, plazoMeses - 1) * (factorMensual - 1) /
            (Math.pow(factorMensual, plazoMeses) - 1)
        );
    }

    const schedule = [];
    let saldo = round2(saldoFinanciar);
    let current = firstBillingMonth(startDate, paymentDay);
    let totalInterest = 0;
    let totalCapital = 0;
    let totalPayment = 0;

    for (let i = 1; i <= plazoMeses; i += 1) {
        const balanceBefore = saldo;
        const mensualidad = mensualidadBase;
        let interest = 0;
        let capital = mensualidad;
        let balanceAfter = 0;

        if (tasaMensual === 0) {
            balanceAfter = round2(balanceBefore - mensualidad);
        } else {
            balanceAfter = round2((balanceBefore - mensualidad) * factorMensual);
            interest = round2((balanceBefore - mensualidad) * (factorMensual - 1));
            capital = round2(mensualidad - interest);
        }
        if (Math.abs(balanceAfter) < 0.01) balanceAfter = 0;
        const dueDate = buildDueDate(current, paymentDay);

        schedule.push({
            payment_number: i,
            due_date: formatISODate(dueDate),
            amount_due: mensualidad,
            capital,
            interest,
            balance_before: balanceBefore,
            balance_after: balanceAfter,
        });

        saldo = balanceAfter;
        totalInterest = round2(totalInterest + interest);
        totalCapital = round2(totalCapital + capital);
        totalPayment = round2(totalPayment + mensualidad);
        current = addUtcMonths(current, 1);
    }

    return {
        input: {
            tipo: isContadoUnico ? "contado_unico" : (isContado ? "contado" : "credito"),
            saldo_financiar: round2(saldoFinanciar),
            tasa_interes_anual: round2(tasaAnual),
            plazo_meses: plazoMeses,
            enganche: round2(enganche),
            precio_total: precioTotal != null ? round2(precioTotal) : null,
            start_date: formatISODate(startDate),
            payment_day: paymentDay,
            currency: body.currency || "MXN",
        },
        config: {
            tasa_interes_anual_default: tasaDefault,
            plazo_meses_default: plazoDefault,
            plazo_meses_min: plazoMin,
            plazo_meses_max: plazoMax,
        },
        summary: {
            monthly_payment_base: mensualidadBase,
            total_capital: totalCapital,
            total_interest: totalInterest,
            total_payment: totalPayment,
        },
        schedule,
    };
};
