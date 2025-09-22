-- Create "users" table
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `account_id` bigint NOT NULL,
  `first_name` varchar(255) NULL,
  `created_at` timestamp NULL,
  `last_seen` timestamp NULL,
  `currency` varchar(255) NULL,
  `locale` varchar(255) NULL,
  `timezone` varchar(255) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `account_id` (`account_id`)
) CHARSET utf8mb4 COLLATE utf8mb4_bin;
-- Create "categories" table
CREATE TABLE `categories` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `type` enum('expense','income') NOT NULL,
  `user_id` bigint NULL,
  PRIMARY KEY (`id`),
  INDEX `categories_users_categories` (`user_id`),
  CONSTRAINT `categories_users_categories` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE NO ACTION ON DELETE SET NULL
) CHARSET utf8mb4 COLLATE utf8mb4_bin;
-- Create "transactions" table
CREATE TABLE `transactions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `type` enum('gasto','ingreso') NOT NULL,
  `amount` double NOT NULL,
  `currency` varchar(255) NOT NULL,
  `conversion_rate` double NOT NULL,
  `description` varchar(255) NULL,
  `tx_date` timestamp NOT NULL,
  `created_at` timestamp NULL,
  `updated_at` timestamp NULL,
  `category_id` bigint NULL,
  `user_id` bigint NULL,
  PRIMARY KEY (`id`),
  INDEX `transactions_categories_transactions` (`category_id`),
  INDEX `transactions_users_transactions` (`user_id`),
  CONSTRAINT `transactions_categories_transactions` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT `transactions_users_transactions` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE NO ACTION ON DELETE SET NULL
) CHARSET utf8mb4 COLLATE utf8mb4_bin;
