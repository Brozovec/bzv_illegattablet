
CREATE TABLE IF NOT EXISTS `blackmarket_warehouses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) NOT NULL,
  `warehouse_id` varchar(20) NOT NULL,
  `purchased_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `identifier_warehouse` (`identifier`, `warehouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
