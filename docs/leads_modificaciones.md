# Modificaciones del Módulo Leads

Fecha: 2026-04-08

## 1) Estatus de leads en español

Estatus válidos:

- `nuevo`
- `contactado`
- `calificado`
- `cerrado`

Se actualizaron:

- Validaciones en backend (`lead.processor.js`)
- Constraint en BD (`chk_lead_contact_status`)
- Stored procedures de leads

## 2) Seguridad de endpoints

Se mantuvo público el endpoint del formulario:

- `POST /lead/register`

Se protegieron con `verifyAccess` + roles (`super_admin`, `admin`, `sales_agent`):

- `GET /lead/list`
- `GET /lead/status/catalog`
- `PUT /lead/status`
- `GET /lead/notes`
- `POST /lead/notes`
- `PUT /lead/notes` (compatibilidad, mismo comportamiento que POST)
- `POST /lead/convert`

## 3) Validaciones de negocio implementadas

### Registro de lead (`/lead/register`)

- Requiere: `property_id`, `name`, `email`
- Valida formato de email
- Valida formato de teléfono (si viene)
- Valida que la propiedad exista
- Evita duplicados por `email + property_id` en ventana de 24 horas

### Cambio de estatus (`/lead/status`)

- Requiere: `lead_contact_id`, `status`
- Valida estatus permitido
- Valida que el lead exista
- Guarda auditoría en `changed_by`

### Notas del lead (`/lead/notes`)

- Requiere: `lead_contact_id`
- Requiere `note` (o `notes` por compatibilidad) con texto no vacío
- Valida que el lead exista
- Cada llamada crea una **nueva nota** (historial)
- Guarda `created_by` y `created_at` por cada nota

### Conversión a cliente (`/lead/convert`)

- Requiere: `lead_contact_id`
- Valida que el lead exista
- Impide reconvertir si ya está `cerrado`
- Crea o actualiza cliente por email
- Marca el lead como `cerrado`
- Guarda auditoría: `converted_by`, `converted_at`, `conversion_notes`

## 4) Auditoría agregada en tabla `lead_contact`

Nuevas columnas:

- `changed_by`
- `converted_by`
- `converted_at`
- `conversion_notes`
- `lead_notes`

Nueva tabla:

- `lead_contact_note` (historial de notas por lead)

## 5) Manejo de errores HTTP

- `400`: validaciones/negocio (status inválido, formato inválido, duplicado, etc.)
- `404`: lead o propiedad no encontrada
- `401`: token faltante/inválido
- `403`: usuario inactivo o sin rol permitido
- `500`: error interno no controlado

## 6) Regla importante de listado por status (lo que pediste)

En `GET /lead/list`:

- Si `status = null` (o no se envía), regresa leads de **todos** los estatus.
- Si `status = ''`, también regresa **todos**.
- Si `status = 'undefined'` o `status = 'null'` (string), también regresa **todos**.
- Si envías un estatus válido (`nuevo`, `contactado`, `calificado`, `cerrado`), filtra por ese estatus.

Implementado en:

- Backend: `src/Entities/lead/lead.processor.js`
- SP: `lead_contact_list_with_customer`

## 7) Endpoint de catálogo para front

- `GET /lead/status/catalog`

Respuesta:

```json
{
  "statuses": [
    { "value": "nuevo", "label": "nuevo" },
    { "value": "contactado", "label": "contactado" },
    { "value": "calificado", "label": "calificado" },
    { "value": "cerrado", "label": "cerrado" }
  ]
}
```

## 8) Scripts SQL aplicados

- `scripts/mysql_apply_lead_fixes.sql`
- `scripts/mysql_apply_lead_status_spanish.sql`
- `scripts/mysql_apply_lead_notes.sql`

Resultado de aplicación:

- `lead_fixes_applied`
- `lead_status_spanish_applied`
- `lead_notes_applied`

## 9) Contrato de notas para front

### Agregar nota

- `POST /lead/notes` (o `PUT /lead/notes` por compatibilidad)

Body:

```json
{
  "lead_contact_id": 12,
  "note": "Se llamó al cliente, pidió seguimiento el viernes."
}
```

Respuesta 201:

```json
{
  "note_id": 5,
  "lead_contact_id": 12,
  "note": "Se llamó al cliente, pidió seguimiento el viernes.",
  "created_by": 3,
  "created_by_name": "Administrador Demo",
  "created_at": "2026-04-08 16:20:00"
}
```

### Listar notas de un lead

- `GET /lead/notes?lead_contact_id=12`

Respuesta 200:

```json
{
  "lead_contact_id": 12,
  "data": [
    {
      "note_id": 5,
      "lead_contact_id": 12,
      "note": "Se llamó al cliente, pidió seguimiento el viernes.",
      "created_by": 3,
      "created_by_name": "Administrador Demo",
      "created_at": "2026-04-08 16:20:00"
    }
  ]
}
```
