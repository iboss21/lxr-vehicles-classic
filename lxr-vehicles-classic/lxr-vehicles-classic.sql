-- ╔═══════════════════════════════════════════════════════════════════════════╗
-- ║  🐺 LXR VEHICLES CLASSIC — DATABASE SCHEMA                              ║
-- ║  wolves.land | The Land of Wolves | © 2026 iBoss21 / The Lux Empire      ║
-- ║  Resource: lxr-vehicles-classic v2.0.0                                   ║
-- ╚═══════════════════════════════════════════════════════════════════════════╝
--
-- Run this SQL in your database (MariaDB / MySQL) before starting the resource.
-- Existing `ironhorses` tables from the original resource are NOT affected.
-- ─────────────────────────────────────────────────────────────────────────────

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- ─────────────────────────────────────────────────────────────────────────────
-- TABLE: lxr_vehicles
--   Stores player-owned vehicles purchased through the LXR dealership.
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `lxr_vehicles` (
  `id`              INT(11)       NOT NULL AUTO_INCREMENT,
  `identifier`      VARCHAR(60)   DEFAULT NULL     COMMENT 'Steam / License identifier',
  `charidentifier`  INT(11)       NOT NULL          COMMENT 'Character ID from framework',
  `name`            VARCHAR(60)   NOT NULL          COMMENT 'Vehicle config key (e.g. truck, hellcat)',
  `modelname`       VARCHAR(90)   NOT NULL          COMMENT 'Object model name (e.g. ironroadster)',
  `type`            VARCHAR(20)   NOT NULL          COMMENT 'car | bike | boat | heli | plane | jet | tank | osprey | cargobob',
  `status`          LONGTEXT      DEFAULT NULL      COMMENT 'JSON: transfer offers, pending states',
  `isDefault`       INT(1)        NOT NULL DEFAULT 0,
  `inventory`       LONGTEXT      DEFAULT NULL,
  `created_at`      TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_charidentifier` (`charidentifier`),
  INDEX `idx_modelname`      (`modelname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ─────────────────────────────────────────────────────────────────────────────
-- Restore settings
-- ─────────────────────────────────────────────────────────────────────────────
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
