local BankMenuPool = NativeUI.CreatePool()
local bankMenu     = NativeUI.CreateMenu("Bank Teller", "~g~Deposit and Withdraw Money")
BankMenuPool:Add(bankMenu)

local quickAmounts  = { 100, 200, 500, 1000, 2000, 4000, 5000, 7500, 10000 }
local activateRange = 0.75
local isOpen        = false

function prefixAmounts(prefix)
    local quickAmountStrings = {}
    for _, v in pairs(quickAmounts) do
        table.insert(quickAmountStrings, prefix .. "$" .. v)
    end
    return quickAmountStrings
end

local itemQuickWithdraw  = NativeUI.CreateListItem(
        "Quick Withdraw Amount", prefixAmounts("~r~"), 1,
        "Choose one of the common amounts of money to withdraw")
local itemQuickDeposit   = NativeUI.CreateListItem(
        "Quick Deposit Amount", prefixAmounts("~g~"), 1,
        "Choose one of the common amounts of money to deposit")
local itemCheckBalance   = NativeUI.CreateItem("Check Bank Balance", "Check your total available balance")
local itemDepositAmount  = NativeUI.CreateItem("~g~Deposit Money", "Give money to the bank teller")
local itemWithdrawAmount = NativeUI.CreateItem("~g~Withdraw Money", "Withdraw money from your bank account")
local itemCancel         = NativeUI.CreateItem("~r~Cancel ATM Transaction",
                                               "This will cancel your transaction without charging you anything")
bankMenu:AddItem(itemQuickWithdraw)
bankMenu:AddItem(itemQuickDeposit)
bankMenu:AddItem(itemCheckBalance)
bankMenu:AddItem(itemDepositAmount)
bankMenu:AddItem(itemWithdrawAmount)
bankMenu:AddItem(itemCancel)

bankMenu.OnListSelect    = function(_, item, index)
    local quickAmount = quickAmounts[index]

    if item == itemQuickWithdraw then
        AttemptPlayerWithdraw(quickAmount)
    elseif item == itemQuickDeposit then
        AttemptPlayerDeposit(quickAmount)
    end
end

bankMenu.OnItemSelect    = function(_, item)
    if item == itemCheckBalance then
        TriggerEvent("ree-money:displayOverlay")
    elseif item == itemCancel then
        bankMenu:Visible(false)
    elseif item == itemWithdrawAmount then
        AttemptPlayerWithdraw()
    elseif item == itemDepositAmount then
        AttemptPlayerDeposit()
    end
end

bankMenu.OnMenuClose     = function()
    isOpen = false
end

local GetPedBlipDistance = REE.Lib.Coords.GetDistanceBetweenPedAndBlip
local Banks              = REE.Data.Locations.Banks
local nearbyBanks        = {}

-- Thread :: Update the list of nearby bank blips occasionally
Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)

        for i, _ in pairs(Banks) do
            nearbyBanks[i] = nil
        end

        for _, blip in pairs(Banks) do
            local dist = GetPedBlipDistance(ped, blip, true)
            if dist < 100.0 then
                blip.D = dist
                table.insert(nearbyBanks, blip)
            end
        end

        Citizen.Wait(500)
    end
end)

-- Thread ::
Citizen.CreateThread(function()
    while true do
        for _, blip in pairs(nearbyBanks) do
            if blip.D <= activateRange then
                -- 'E' is pressed
                if IsControlJustPressed(1, 46) then
                    bankMenu:Visible(not bankMenu:Visible())
                    isOpen = true
                end

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
                AddTextComponentString("Press ~g~E~s~ - Talk To Bank Teller")
                DrawText(0.475, 0.9)
            end
        end

        Citizen.Wait(10)
    end
end)

Citizen.CreateThread(function()
    while true do
        REE.Lib.World._RenderMarkerList(nearbyBanks, 6, 1.0)
        BankMenuPool:ProcessMenus()
        Citizen.Wait(1)
    end
end)
