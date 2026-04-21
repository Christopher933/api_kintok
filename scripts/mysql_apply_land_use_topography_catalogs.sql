-- Catalogs for land_use and topography
-- 1. Create tables + seed
-- 2. Add FK columns to property_land
-- 3. Migrate existing text values to IDs
-- 4. Drop old text columns
-- 5. Recreate affected SPs

-- ── 1. Tables + seed ────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS `land_use` (
    `id`   INT          NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(150) COLLATE utf8mb4_unicode_ci NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_land_use_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `topography` (
    `id`   INT          NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) COLLATE utf8mb4_unicode_ci NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_topography_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO `land_use` (`name`) VALUES
    ('Habitacional'), ('Comercial'), ('Industrial'),
    ('Mixto'), ('Agrícola'), ('Servicios'), ('Equipamiento urbano');

INSERT IGNORE INTO `topography` (`name`) VALUES
    ('Plano'), ('Pendiente'), ('Irregular'), ('Escalonado');

-- ── 2. Add FK columns to property_land ──────────────────────────────────────

ALTER TABLE `property_land`
    ADD COLUMN `land_use_id`   INT DEFAULT NULL AFTER `land_use`,
    ADD COLUMN `topography_id` INT DEFAULT NULL AFTER `topography`,
    ADD CONSTRAINT `fk_pl_land_use`   FOREIGN KEY (`land_use_id`)   REFERENCES `land_use`   (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
    ADD CONSTRAINT `fk_pl_topography` FOREIGN KEY (`topography_id`) REFERENCES `topography` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- ── 3. Migrate text → IDs ───────────────────────────────────────────────────

UPDATE `property_land` pl
INNER JOIN `land_use` lu ON lu.name = pl.land_use
SET pl.land_use_id = lu.id
WHERE pl.land_use IS NOT NULL;

UPDATE `property_land` pl
INNER JOIN `topography` tp ON tp.name = pl.topography
SET pl.topography_id = tp.id
WHERE pl.topography IS NOT NULL;

-- ── 4. Drop old text columns ─────────────────────────────────────────────────

ALTER TABLE `property_land`
    DROP COLUMN `land_use`,
    DROP COLUMN `topography`;
