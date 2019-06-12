function PromptUserAmount(balance, action)
    local depositAmountStr = REE.Lib.Native.PromptUserTextInput()
    local amount = math.round(tonumber(depositAmountStr))

    if amount <= 0 or amount == "" or amount == nil then
        SetNotificationTextEntry('STRING')
        AddTextComponentString("~r~Please enter a valid amount")
        DrawNotification(true, true)
        return nil
    end

    if amount > balance then
        SetNotificationTextEntry('STRING')
        AddTextComponentString("~r~You don't have enough on hand to " .. action .. " that amount")
        DrawNotification(true, true)
        return nil
    end

    return amount
end

function AttemptPlayerWithdraw(amount)
    if amount == nil then
        amount = PromptUserAmount(Money.Balance[MoneyAccountTypes.BANK], "withdraw")
    end

    Money.Transfer(MoneyAccountTypes.BANK, MoneyAccountTypes.ON_HAND, amount, "ATM Deposit")
end

function AttemptPlayerDeposit(amount)
    if amount == nil then
        amount = PromptUserAmount(Money.Balance[MoneyAccountTypes.ON_HAND], "deposit")
    end

    Money.Transfer(MoneyAccountTypes.ON_HAND, MoneyAccountTypes.BANK, amount, "ATM Deposit")
end

