# Módulo Usuarios y Permisos por Rol/Modulo

Fecha: 2026-04-09

## 1) Objetivo

Se implementó administración de usuarios para admin y un sistema de permisos por rol dividido por módulos con acciones:

- `view`
- `create`
- `update`
- `delete`

## 2) Tablas nuevas

- `permission_module`
  - Catálogo de módulos del sistema (`auth`, `user`, `role_permission`, `property`, `lead`, `customer`, `transaction`, `catalog`, `cms`)
- `role_module_permission`
  - Mapea `role_id + module_id` con permisos por acción

Script aplicado:

- `scripts/mysql_apply_role_module_permissions.sql`
- Resultado: `role_module_permissions_applied`

## 3) Middleware de permisos

Archivo: `src/_shared/token.js`

Nuevo middleware:

- `authorizeModuleAction(moduleKey, action)`

Comportamiento:

- `verifyAccess` ahora adjunta `req.user.permissions`.
- Si existen tablas de permisos, usa esos permisos.
- Si no existen, usa fallback por rol para no romper compatibilidad.

## 4) Endpoints nuevos de usuario (admin)

Base: `/api/user`

- `GET /list` (user:view)
- `GET /detail/:user_id` (user:view)
- `POST /upsert` (user:create o user:update según `id`)
- `POST /change-password` (user:update)
- `GET /roles` (role_permission:view)
- `POST /role/upsert` (role_permission:update)
- `DELETE /role/:role_id` (role_permission:delete)
- `GET /permission/modules` (role_permission:view)
- `GET /role/:role_id/permissions` (role_permission:view)
- `PUT /role/:role_id/permissions` (role_permission:update)

## 5) Contrato para front

### 5.1 Listar usuarios

`GET /api/user/list?search=&role_id=&is_active=&page_number=1&page_size=10`

Respuesta:

```json
{
  "meta": {
    "total_records": 1,
    "page_number": 1,
    "page_size": 10,
    "total_pages": 1
  },
  "data": [
    {
      "id": 2,
      "username": "christopher",
      "full_name": "Christopher Sandoval",
      "email": "christopher.sandoval93@gmail.com",
      "role_id": 1,
      "role_name": "super_admin",
      "is_active": 1,
      "last_login_at": "2026-04-09 10:00:00",
      "failed_login_attempts": 0,
      "locked_until": null,
      "created_at": "2026-04-01 16:40:31",
      "updated_at": "2026-04-09 10:00:00"
    }
  ]
}
```

### 5.2 Detalle usuario

`GET /api/user/detail/:user_id`

### 5.3 Crear/actualizar usuario

`POST /api/user/upsert`

Crear:

```json
{
  "username": "nuevo.usuario",
  "full_name": "Nuevo Usuario",
  "email": "nuevo@kintok.com",
  "role_id": 3,
  "is_active": 1,
  "password": "Password123"
}
```

Actualizar:

```json
{
  "id": 5,
  "username": "nuevo.usuario",
  "full_name": "Nuevo Usuario Editado",
  "email": "nuevo@kintok.com",
  "role_id": 2,
  "is_active": 1
}
```

Respuesta:

```json
{ "user_id": 5, "action": "created" }
```

o

```json
{ "user_id": 5, "action": "updated" }
```

### 5.4 Cambiar contraseña

`POST /api/user/change-password`

Caso propio usuario:

```json
{
  "current_password": "Actual123",
  "new_password": "Nueva1234"
}
```

Caso admin a otro usuario:

```json
{
  "user_id": 5,
  "new_password": "Temp12345"
}
```

Respuesta:

```json
{ "affected_rows": 1, "user_id": 5 }
```

### 5.5 Catálogo de roles

`GET /api/user/roles`

### 5.6 Catálogo de módulos

`GET /api/user/permission/modules`

### 5.7 Crear/actualizar rol

`POST /api/user/role/upsert`

Crear:

```json
{ "name": "coordinador" }
```

Crear con permisos en una sola llamada:

```json
{
  "name": "coordinador",
  "permissions": [
    { "module_id": 4, "can_view": 1, "can_create": 1, "can_update": 1, "can_delete": 0 },
    { "module_id": 6, "can_view": 1, "can_create": 1, "can_update": 1, "can_delete": 0 },
    { "module_id": 7, "can_view": 1, "can_create": 1, "can_update": 1, "can_delete": 0 }
  ]
}
```

Actualizar:

```json
{ "id": 6, "name": "coordinador_comercial" }
```

Respuesta:

```json
{ "role_id": 6, "action": "created" }
```

Nota:

- Si envías `permissions`, el backend los guarda dentro de la misma transacción del `role/upsert`.

### 5.8 Eliminar rol

`DELETE /api/user/role/:role_id`

Reglas:

- No permite borrar roles base (`super_admin`, `admin`, `sales_agent`).
- No permite borrar si el rol está asignado a usuarios.

### 5.9 Ver permisos de un rol

`GET /api/user/role/:role_id/permissions`

Respuesta:

```json
{
  "role": { "id": 2, "name": "admin" },
  "permissions": [
    {
      "module_id": 4,
      "module_key": "property",
      "display_name": "Propiedades",
      "can_view": 1,
      "can_create": 1,
      "can_update": 1,
      "can_delete": 1
    }
  ]
}
```

### 5.10 Actualizar permisos de rol

`PUT /api/user/role/:role_id/permissions`

```json
{
  "permissions": [
    { "module_id": 4, "can_view": 1, "can_create": 1, "can_update": 1, "can_delete": 0 },
    { "module_id": 6, "can_view": 1, "can_create": 1, "can_update": 1, "can_delete": 0 }
  ]
}
```

Respuesta:

```json
{ "role_id": 2, "affected_rows": 2 }
```

## 6) Ajustes en módulos existentes

Se migró protección de rutas administrativas a permisos por módulo:

- `property` (acciones create/update/delete en endpoints administrativos)
- `lead` (view/create/update según endpoint)
- `customer` (view/create/update según endpoint)
- `transaction` (view/create/update/delete según endpoint)
- `catalog` (`upsert` protegido por `catalog:update`; listados públicos)

## 7) Login y sesión

`POST /api/auth/login` ahora devuelve también:

- `permissions` (mapa por módulo con `view/create/update/delete`)

Y el JWT incluye ese contexto para facilitar front guard/menu.

## 8) Reglas especiales de `super_admin`

- Solo un `super_admin` puede asignar el rol `super_admin` a un usuario.
- Solo un `super_admin` puede crear/editar el rol `super_admin`.
- Solo un `super_admin` puede ver permisos del rol `super_admin`.
- Usuarios no `super_admin` no verán el rol `super_admin` en `GET /api/user/roles`.
- Usuarios no `super_admin` no verán usuarios con rol `super_admin` en `GET /api/user/list`.
- Usuarios no `super_admin` no pueden consultar `GET /api/user/detail/:id` de un super admin.
