Money             = { Data = {} }
local _TableNames = { Accounts     = "ree_money_accounts",
                      Transactions = "ree_money_transactions" }

function GetPlayerAccount(reePlayerID)
    local account
    local rows = MySQL.Sync.fetchAll(
            "SELECT * FROM " .. _TableNames.Accounts .. " WHERE player_id = @playerID LIMIT 1",
            { ["@playerID"] = reePlayerID })

    for _, row in pairs(rows) do
        account = row
        break
    end

    return account
end

function CreatePlayerAccount(reePlayerID)
    local changed = MySQL.Sync.execute(
            "INSERT INTO " .. _TableNames.Accounts .. " (player_id, on_hand_balance) " ..
                    "VALUES (@player_id, 1000);", { ["@player_id"] = reePlayerID })

    if changed ~= 1 then
        error("Failed to create money account for player " .. source)
    end

    return GetPlayerAccount(reePlayerID)
end

function GetOrCreatePlayerAccount(reePlayerID)
    local account = GetPlayerAccount(reePlayerID)

    if account == nil then
        account = CreatePlayerAccount(reePlayerID)
    end

    return account
end

function GetMoneyForPlayer(reePlayer)
    return GetOrCreatePlayerAccount(reePlayer.id)
end

function RecordTransaction(accountID, from, to, amount, reason)
    -- this is async, let it happen in the background
    MySQL.Async.execute("INSERT INTO " .. _TableNames.Transactions .. " (account_id, from_account, " ..
                                "to_account, amount, reason) VALUES (@accountID, @from, @to, @amount, @reason)",
                        { ["@accountID"] = accountID, ["@from"] = from, ["@to"] = to,
                          ["@amount"]    = amount, ["@reason"] = reason })
end

function UpdateAccountBalances(accountID, balance)
    MySQL.Sync.execute("UPDATE " .. _TableNames.Accounts .. " SET on_hand_balance = @onHand, debt_balance = @debt," ..
                               " account_balance = @accounts WHERE id = @id",
                       { ["@id"]   = accountID, ["@onHand"] = balance[1],
                         ["@debt"] = balance[2], ["@accounts"] = balance[3] })
end

function Money.GetBalance(server_id)
    local balance = Money.Data[tostring(server_id)]

    if balance == nil then
        return { 0, 0, 0 }
    end

    return balance
end

function Money.PollUsers()
    local players        = GetPlayers()
    local currentPlayers = {}

    function PlayerIdExists(id)
        for _, _id in pairs(currentPlayers) do
            if id == _id then
                return true
            end
        end

        return false
    end

    for id, _ in pairs(Money.Data) do
        table.insert(currentPlayers, id)
    end

    for i, id in pairs(players) do
        local playerData = GetPlayerIdentifiers(id)
        local player     = REE.Lib.Users.GetPlayerByPlayerData(playerData)

        if player == nil then
            error("Failed to resolve REE player " .. id)
        end

        local account = GetOrCreatePlayerAccount(player.id)
        players[i]    = nil

        if not PlayerIdExists(id) then
            Money.Data[id] = { account.on_hand_balance, account.debt_balance, account.account_balance }
            TriggerClientEvent("ree-money:setBalance", id, Money.Data[id])
        else
            -- remove them, so we can find users needing deletion

            -- update their balances
            local savedBalance = Money.GetBalance(id)
            local balance      = Money.Data[id]

            if balance[1] ~= savedBalance[1] or balance[2] ~= savedBalance[2] or balance[3] ~= savedBalance[3] then
                UpdateAccountBalances(account.id, balance)
            end
        end
    end

    -- remove old users
    for _, id in pairs(players) do
        local player  = REE.Lib.Users.GetPlayerByServerId(id)
        local balance = Money.GetBalance(id)
        UpdateAccountBalances(player.id, balance)
        Money.Data[id] = nil
    end
end

-- continually poll users to update and save bank account data
Citizen.CreateThread(function()
    while true do
        Money.PollUsers()
        Citizen.Wait(30 * 1000)
    end
end)
