RegisterNetEvent("ree-money:getBalance")
RegisterNetEvent("ree-money:setBalance")
RegisterNetEvent("ree-money:transfer")
RegisterNetEvent("ree-money:transferSuccess")

AddEventHandler("ree-money:getBalance", function()
    local playerID = source
    local balance  = Money.GetBalance(playerID)
    TriggerClientEvent("ree-money:setBalance", playerID, balance)
end)

AddEventHandler("ree-money:purchaseItem", function(playerID, amount, description, callbackEvent)
    if amount <= 0 then
        error("Invalid amount received for deposit request (player " .. playerID .. ")")
    end

    local playerData         = GetPlayerIdentifiers(playerID)
    local reePlayer          = REE.Lib.Users.GetPlayerByPlayerData(playerData)
    local account            = GetPlayerAccount(reePlayer.id)
    local balances           = Money.GetBalance(playerID)
    local fromAccountBalPrev = balances[MoneyAccountTypes.ON_HAND]
    local fromAccountBalNew  = balances[MoneyAccountTypes.ON_HAND] - amount

    if fromAccountBalPrev < amount then
        REE.Log("Refusing to spend more than player has on them has (On Hand: $" .. fromAccountBalPrev .. ") (Amount: $" .. amount .. ")")
        callbackEvent(false)
        return
    end

    balances[MoneyAccountTypes.ON_HAND] = fromAccountBalNew

    UpdateAccountBalances(account.id, balances)
    RecordTransaction(account.id, MoneyAccountTypes.ON_HAND, 0, amount, description)
    Money.Data[playerID] = balances

    REE.Log("Player " .. playerID .. " purchased an item for $" .. amount .. " (Acct. From: $" ..
                    fromAccountBalPrev .. " -> $" .. fromAccountBalNew .. ")")

    TriggerClientEvent("ree-money:setBalance", playerID, balances)
    callbackEvent(true)
end)

AddEventHandler("ree-money:transfer", function(fromAccount, toAccount, amount, reason)
    local playerID = source

    if amount <= 0 then
        error("Invalid amount received for deposit request (player " .. playerID .. ")")
    end

    -- accounts can't be the same, make sure account is valid
    if (fromAccount == toAccount) or ((fromAccount > 3 or fromAccount < 1) and
            (toAccount > 3 or toAccount < 1)) then
        error("Invalid request -- refusing (player " .. playerID .. ")")
    end

    -- can't use debt here
    if fromAccount == MoneyAccountTypes.DEBT or toAccount == MoneyAccountTypes.DEBT then
        error("Refusing to use 'debt' account for debit playerID (player " .. playerID .. ")")
    end

    local playerData         = GetPlayerIdentifiers(playerID)
    local reePlayer          = REE.Lib.Users.GetPlayerByPlayerData(playerData)
    local account            = GetPlayerAccount(reePlayer.id)
    local balances           = Money.GetBalance(playerID)
    local fromAccountBalPrev = balances[fromAccount]
    local fromAccountBalNew  = balances[fromAccount] - amount
    local toAccountBalPrev   = balances[toAccount]
    local toAccountBalNew    = balances[toAccount] + amount

    if fromAccountBalPrev < amount then
        REE.Log("Refusing to spend more than account has (Acct: $" .. fromAccountBalPrev .. ") (Amount: $" .. amount .. ")")
        TriggerClientEvent("ree-money:transferSuccess", playerID,
                           "Failed to transfer ~y~$" .. amount .. "~s~ (~r~Insufficient funds~s~)")
        return
    end

    balances[fromAccount] = fromAccountBalNew
    balances[toAccount]   = toAccountBalNew

    Money.Data[playerID]  = balances
    UpdateAccountBalances(account.id, balances)
    RecordTransaction(account.id, fromAccount, toAccount, amount, reason)

    REE.Log("Player " .. playerID .. " deposited $" .. amount .. " (Acct. From: $" .. fromAccountBalPrev
                    .. " -> $" .. fromAccountBalNew .. ") (Acct. To: $" ..
                    toAccountBalPrev .. " -> $" .. toAccountBalNew .. ")")

    TriggerClientEvent("ree-money:setBalance", playerID, balances)
    TriggerClientEvent("ree-money:transferSuccess", playerID, "You successfully transferred ~g~$" ..
            REE.Lib.Format.FormatNumberWithCommas(amount) .. "~s~ (New Balance: ~y~$" ..
            REE.Lib.Format.FormatNumberWithCommas(fromAccountBalNew) .. "~s~)")
end)

