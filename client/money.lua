Money         = { }
Money.Balance = { 0, 0, 0 }

function Money.Spend(account, amount, productName)
    TriggerServerEvent("ree-money:purchaseItem", account, amount, productName)
end

function Money.Deposit(account, amount, reason)
    TriggerServerEvent("ree-money:transfer", account, amount, reason)
end

function Money.Transfer(from, to, amount, reason)
    TriggerServerEvent("ree-money:transfer", from, to, amount, reason)
end

function Money.Update()
    TriggerServerEvent("ree-money:getBalance")
end

function Money:OnHandBalance()
    return self.Balance[1]
end

function Money:DebtBalance()
    return self.Balance[2]
end

function Money:AccountBalance()
    return self.Balance[3]
end
