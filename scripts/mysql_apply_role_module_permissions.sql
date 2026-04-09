USE kintok;

CREATE TABLE IF NOT EXISTS permission_module (
  id INT NOT NULL AUTO_INCREMENT,
  module_key VARCHAR(50) NOT NULL,
  display_name VARCHAR(100) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_permission_module_key (module_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS role_module_permission (
  role_id INT NOT NULL,
  module_id INT NOT NULL,
  can_view TINYINT(1) NOT NULL DEFAULT 0,
  can_create TINYINT(1) NOT NULL DEFAULT 0,
  can_update TINYINT(1) NOT NULL DEFAULT 0,
  can_delete TINYINT(1) NOT NULL DEFAULT 0,
  updated_by INT NULL,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (role_id, module_id),
  KEY fk_role_module_permission_module (module_id),
  KEY fk_role_module_permission_updated_by (updated_by),
  CONSTRAINT fk_role_module_permission_role FOREIGN KEY (role_id) REFERENCES role(id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_role_module_permission_module FOREIGN KEY (module_id) REFERENCES permission_module(id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_role_module_permission_updated_by FOREIGN KEY (updated_by) REFERENCES `user`(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO permission_module (module_key, display_name) VALUES
('auth', 'Autenticación'),
('user', 'Usuarios'),
('role_permission', 'Roles y Permisos'),
('property', 'Propiedades'),
('lead', 'Leads'),
('customer', 'Clientes'),
('transaction', 'Transacciones'),
('catalog', 'Catálogos'),
('cms', 'Contenido CMS')
ON DUPLICATE KEY UPDATE
  display_name = VALUES(display_name),
  updated_at = NOW();

-- Super Admin: todo
INSERT INTO role_module_permission (role_id, module_id, can_view, can_create, can_update, can_delete, updated_by)
SELECT r.id, pm.id, 1, 1, 1, 1, 1
FROM role r
CROSS JOIN permission_module pm
WHERE r.name = 'super_admin'
ON DUPLICATE KEY UPDATE
  can_view = VALUES(can_view),
  can_create = VALUES(can_create),
  can_update = VALUES(can_update),
  can_delete = VALUES(can_delete),
  updated_by = VALUES(updated_by),
  updated_at = NOW();

-- Admin
INSERT INTO role_module_permission (role_id, module_id, can_view, can_create, can_update, can_delete, updated_by)
SELECT
  r.id,
  pm.id,
  CASE pm.module_key
    WHEN 'auth' THEN 1
    WHEN 'user' THEN 1
    WHEN 'role_permission' THEN 1
    WHEN 'property' THEN 1
    WHEN 'lead' THEN 1
    WHEN 'customer' THEN 1
    WHEN 'transaction' THEN 1
    WHEN 'catalog' THEN 1
    WHEN 'cms' THEN 1
    ELSE 0 END AS can_view,
  CASE pm.module_key
    WHEN 'auth' THEN 1
    WHEN 'user' THEN 1
    WHEN 'property' THEN 1
    WHEN 'lead' THEN 1
    WHEN 'customer' THEN 1
    WHEN 'transaction' THEN 1
    WHEN 'catalog' THEN 1
    WHEN 'cms' THEN 1
    ELSE 0 END AS can_create,
  CASE pm.module_key
    WHEN 'auth' THEN 1
    WHEN 'user' THEN 1
    WHEN 'role_permission' THEN 1
    WHEN 'property' THEN 1
    WHEN 'lead' THEN 1
    WHEN 'customer' THEN 1
    WHEN 'transaction' THEN 1
    WHEN 'catalog' THEN 1
    WHEN 'cms' THEN 1
    ELSE 0 END AS can_update,
  CASE pm.module_key
    WHEN 'property' THEN 1
    WHEN 'lead' THEN 1
    WHEN 'customer' THEN 1
    WHEN 'transaction' THEN 1
    ELSE 0 END AS can_delete,
  1
FROM role r
JOIN permission_module pm
WHERE r.name = 'admin'
ON DUPLICATE KEY UPDATE
  can_view = VALUES(can_view),
  can_create = VALUES(can_create),
  can_update = VALUES(can_update),
  can_delete = VALUES(can_delete),
  updated_by = VALUES(updated_by),
  updated_at = NOW();

-- Sales Agent
INSERT INTO role_module_permission (role_id, module_id, can_view, can_create, can_update, can_delete, updated_by)
SELECT
  r.id,
  pm.id,
  CASE pm.module_key
    WHEN 'auth' THEN 1
    WHEN 'property' THEN 1
    WHEN 'lead' THEN 1
    WHEN 'customer' THEN 1
    WHEN 'transaction' THEN 1
    WHEN 'catalog' THEN 1
    WHEN 'cms' THEN 1
    ELSE 0 END AS can_view,
  CASE pm.module_key
    WHEN 'property' THEN 1
    WHEN 'lead' THEN 1
    WHEN 'customer' THEN 1
    WHEN 'transaction' THEN 1
    ELSE 0 END AS can_create,
  CASE pm.module_key
    WHEN 'auth' THEN 1
    WHEN 'property' THEN 1
    WHEN 'lead' THEN 1
    WHEN 'customer' THEN 1
    WHEN 'transaction' THEN 1
    ELSE 0 END AS can_update,
  0,
  1
FROM role r
JOIN permission_module pm
WHERE r.name = 'sales_agent'
ON DUPLICATE KEY UPDATE
  can_view = VALUES(can_view),
  can_create = VALUES(can_create),
  can_update = VALUES(can_update),
  can_delete = VALUES(can_delete),
  updated_by = VALUES(updated_by),
  updated_at = NOW();

SELECT 'role_module_permissions_applied' AS result;
