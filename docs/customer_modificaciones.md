# Modificaciones del Módulo Customer (Admin)

Fecha: 2026-04-08

## 1) Endpoints disponibles

Base: `/api/customer`

- `POST /upsert`
- `GET /list`
- `GET /detail/:customer_id`
- `GET /notes?customer_id=...`
- `POST /notes`
- `PUT /notes` (compatibilidad; mismo comportamiento que POST)

Todos requieren `Bearer token` y rol: `super_admin`, `admin`, `sales_agent`.

## 2) Nuevos campos de customer

Tabla `customer`:

- `status` (`activo|inactivo|bloqueado`)
- `source`
- `assigned_agent_id`
- `last_contact_at`
- `next_follow_up_at`
- `rfc`
- `business_name`
- `billing_email`
- `address_line`
- `created_by`
- `updated_by`

## 3) Listado enriquecido (`GET /customer/list`)

Filtros soportados:

- `search` / `search_text`
- `status`
- `customer_type`
- `assigned_agent_id`
- `page` / `page_number`
- `limit` / `page_size`

Regla:

- Si `status` viene `null`, vacío, `"undefined"` o `"null"`, no filtra por status.

Campos nuevos de respuesta en `data[]`:

- `status`, `source`, `assigned_agent_id`, `assigned_agent_name`
- `last_contact_at`, `next_follow_up_at`
- `notes_count`, `last_note`, `last_note_at`
- `open_leads_count`
- `active_transactions_count`
- `total_transactions_count`
- `total_spent_or_rented_mxn`
- `overdue_payments_count`
- `next_due_date`

## 4) Detalle (`GET /customer/detail/:customer_id`)

Respuesta:

- `customer`: perfil + métricas + auditoría
- `leads`: leads vinculados al cliente
- `transactions`: historial de transacciones
- `payments`: pagos de renta ligados a transacciones del cliente
- `notes`: historial de notas del cliente

Métricas incluidas en `customer`:

- `open_leads_count`
- `active_transactions_count`
- `total_transactions_count`
- `total_spent_or_rented_mxn`
- `overdue_payments_count`
- `outstanding_balance_mxn`

## 5) Upsert (`POST /customer/upsert`)

Body soportado:

```json
{
  "id": null,
  "full_name": "Carlos Mendoza",
  "email": "carlos@mail.com",
  "phone": "6641234567",
  "customer_type": "comprador",
  "notes": "Cliente prioritario",
  "status": "activo",
  "source": "lead_web",
  "assigned_agent_id": 2,
  "last_contact_at": "2026-04-08 10:00:00",
  "next_follow_up_at": "2026-04-12 10:00:00",
  "rfc": "MEMC900101ABC",
  "business_name": null,
  "billing_email": "carlos@mail.com",
  "address_line": "Tijuana, Baja California"
}
```

Respuesta:

```json
{ "customer_id": 1 }
```

## 6) Script de migración aplicado

- `scripts/mysql_apply_customer_admin_context.sql`
- Resultado esperado: `customer_admin_context_applied`

## 7) Historial de notas por cliente

Tabla nueva:

- `customer_note`:
  - `id`
  - `customer_id`
  - `note`
  - `created_by`
  - `created_at`

Endpoints:

- `POST /customer/notes`
- `PUT /customer/notes` (compatibilidad)
- `GET /customer/notes?customer_id=2`

Ejemplo agregar nota:

```json
{
  "customer_id": 2,
  "note": "Llamada de seguimiento, confirmar visita el viernes."
}
```

Respuesta:

```json
{
  "note_id": 3,
  "customer_id": 2,
  "note": "Llamada de seguimiento, confirmar visita el viernes.",
  "created_by": 2,
  "created_by_name": "Christopher Sandoval",
  "created_at": "2026-04-08 16:45:00"
}
```

Script:

- `scripts/mysql_apply_customer_notes_history.sql`
- Resultado esperado: `customer_notes_history_applied`
