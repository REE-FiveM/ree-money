-- handle balance updates
RegisterNetEvent("ree-money:getBalance")
RegisterNetEvent("ree-money:setBalance")
AddEventHandler("ree-money:setBalance", function(balances)
    Money.Balance = { balances[1], balances[2], balances[3] }
end)

RegisterNetEvent("ree-money:transferSuccess")
AddEventHandler("ree-money:transferSuccess", function(msg)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(msg)
    DrawNotification(true, true)
end)

AddEventHandler("ree-money:getBalance", function(cb) cb(Money.Balance) end)
AddEventHandler("ree-money:displayOverlay", function() Overlay:Trigger() end)
