Citizen.CreateThread(function()
    while true do
        TriggerServerEvent("ree-money:getBalance")
        Citizen.Wait(5000)
    end
end)

