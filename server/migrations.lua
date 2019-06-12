local DB_PLUGIN_NAME   = "ree-money"
local MigrationSchemas = {
    -- 1
    "CREATE TABLE `ree_money_accounts` (`id` int NOT NULL AUTO_INCREMENT," ..
            "`player_id` int NOT NULL, `on_hand_balance` bigint NOT NULL DEFAULT '0'," ..
            "`account_balance` bigint NOT NULL DEFAULT '0'," ..
            "`debt_balance` bigint NOT NULL DEFAULT '0'," ..
            "PRIMARY KEY (`id`) );" ..

            "CREATE TABLE `ree_money_transactions` (" ..
            "`id` int NOT NULL AUTO_INCREMENT," ..
            "`account_id` int NOT NULL," ..
            "`from_account` int NOT NULL," ..
            "`to_account` int NOT NULL," ..
            "`amount` bigint NOT NULL," ..
            "`reason` varchar(255) NOT NULL," ..
            "`transaction_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP," ..
            "PRIMARY KEY (`id`) );" ..

            "ALTER TABLE `ree_money_accounts` ADD CONSTRAINT `ree_money_accounts_fk0` FOREIGN KEY (`player_id`)" ..
            "REFERENCES `ree_players`(`id`);" ..

            "ALTER TABLE `ree_money_transactions` ADD CONSTRAINT `ree_money_transactions_fk0` FOREIGN KEY (`account_id`)" ..
            "REFERENCES `ree_money_accounts`(`id`); "
}

AddEventHandler("ree:databaseAvailable", function()
    for i, sql in pairs(MigrationSchemas) do
        TriggerEvent("ree:registerPluginMigration", DB_PLUGIN_NAME, i, sql)
    end

    TriggerEvent("ree:migratePlugin", DB_PLUGIN_NAME)
end)