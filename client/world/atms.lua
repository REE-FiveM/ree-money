ATMMenuPool = NativeUI.CreatePool()
ATMMenu     = NativeUI.CreateMenu("ATM", "~g~Deposit and Withdraw Money")
ATMMenuPool:Add(ATMMenu)

local quickAmounts  = { 20, 40, 60, 80, 100, 200, 400, 600, 800, 1000 }
local activateRange = 0.75
local activeBlip

function prefixAmounts(prefix)
    local quickAmountStrings = {}
    for _, v in pairs(quickAmounts) do
        table.insert(quickAmountStrings, prefix .. "$" .. REE.Lib.Format.FormatNumberWithCommas(v))
    end
    return quickAmountStrings
end

local itemQuickWithdraw     = NativeUI.CreateListItem("Quick Withdraw Amount", prefixAmounts("~r~"), 1,
                                                      "Choose one of the common amounts of money to withdraw from the ATM")
local itemCheckBalance      = NativeUI.CreateItem("Check Bank Balance", "Check your total available balance")
local itemDepositAmount     = NativeUI.CreateItem("~g~Deposit Money",
                                                  "Deposit up to $500 into your account automatically")
local itemCancelTransaction = NativeUI.CreateItem("~r~Cancel ATM Transaction",
                                                  "This will cancel your transaction without charging you anything")
ATMMenu:AddItem(itemQuickWithdraw)
ATMMenu:AddItem(itemCheckBalance)
ATMMenu:AddItem(itemDepositAmount)
ATMMenu:AddItem(itemCancelTransaction)

ATMMenu.OnMenuClosed     = function() activeBlip = nil end
ATMMenu.OnListSelect     = function(_, item, index)
    if item == itemQuickWithdraw then
        local quickAmount = quickAmounts[index]
        Money.Transfer(MoneyAccountTypes.BANK, MoneyAccountTypes.ON_HAND, quickAmount, "ATM Withdraw")
    end
end
ATMMenu.OnItemSelect     = function(_, item)
    if item == itemCheckBalance then
        TriggerEvent("ree-money:displayOverlay")
    elseif item == itemCancelTransaction then
        ATMMenu:Visible(false)
    elseif item == itemDepositAmount then
        AttemptPlayerDeposit()
    end
end

local GetPedBlipDistance = REE.Lib.Coords.GetDistanceBetweenPedAndBlip
local ATMs               = REE.Data.Locations.ATMs
local nearbyATMs         = {}

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)

        for i, _ in pairs(ATMs) do
            nearbyATMs[i] = nil
        end

        for _, blip in pairs(ATMs) do
            local dist = GetPedBlipDistance(ped, blip, true)
            if dist < 100.0 then
                blip.D = dist
                table.insert(nearbyATMs, blip)
            end
        end

        Citizen.Wait(250)
    end
end)

Citizen.CreateThread(function()
    while true do
        ATMMenuPool:ProcessMenus()

        for _, blip in pairs(nearbyATMs) do
            if blip.D <= activateRange then
                -- 'E' is pressed
                if IsControlJustPressed(1, 46) then
                    ATMMenu:Visible(not ATMMenu:Visible())
                    activeBlip = blip
                end

                local message = "Press ~g~E~s~ - Use the ATM (~g~$" .. (blip.limit or 1000) .. "~s~ limit)"
                SetTextFont(1)
                SetTextProportional(1)
                SetTextScale(0.0, 0.8)
                SetTextColour(255, 255, 255, 255)
                SetTextDropShadow(0, 0, 0, 150)
                SetTextEdge(1, 0, 0, 0, 255)
                SetTextDropShadow()
                SetTextOutline()
                SetTextCentre(true)
                SetTextEntry("STRING")
                AddTextComponentString(message)
                DrawText(0.475, 0.9)
            elseif activeBlip == blip and blip.D > 7.5 then
                ATMMenu:Visible(false)
                activeBlip = nil
            end
        end

        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do
        REE.Lib.World._RenderMarkerList(nearbyATMs, 6, 1.0)
        Citizen.Wait(1)
    end
end)
