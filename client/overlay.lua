local OVERLAY_X      = 0.925
local OVERLAY_Y      = 0.13
local OVERLAY_TEXT_X = 0.885
local OVERLAY_TEXT_Y = 0.0725
local OVERLAY_WIDTH  = 0.1
local OVERLAY_HEIGHT = 0.150
local r, g, b        = 0, 0, 0
Overlay              = { Visible = false, Waiting = false, Alpha = 0 }

function Overlay:Trigger()
    if not Overlay.Visible then
        self.Waiting = true
    end
end

local MAX_OPACITY = 255

Citizen.CreateThread(function()
    while true do
        if not Overlay.Waiting and not Overlay.Visible then
            Citizen.Wait(250)
        elseif Overlay.Waiting then
            Overlay.Waiting = false
            Overlay.Visible = true

            for i = 0, MAX_OPACITY, 5 do
                Overlay.Alpha = i
                Citizen.Wait(0)
            end

            -- display for 5 seconds
            Citizen.Wait(5 * 1000)

            for i = 0, MAX_OPACITY, 5 do
                Overlay.Alpha = (MAX_OPACITY - i)
                Citizen.Wait(0)
            end

            Overlay.Visible = false
        else
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local A = Overlay.Alpha

        if Overlay.Visible then
            DrawRect(OVERLAY_X, OVERLAY_Y, OVERLAY_WIDTH, OVERLAY_HEIGHT, r, g, b, A)
            local onHand, _, bank = table.unpack(Money.Balance)

            -- render on hand money amount
            SetTextFont(1)
            SetTextProportional(1)
            SetTextScale(0.0, 0.35)
            SetTextColour(255, 255, 255, A)
            SetTextJustification(1)
            SetTextDropShadow()
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString("ON HAND")
            DrawText(OVERLAY_TEXT_X, OVERLAY_TEXT_Y)

            SetTextFont(0)
            SetTextProportional(1)
            SetTextScale(0.0, 0.5)
            SetTextColour(255, 255, 255, A)
            SetTextJustification(1)
            SetTextDropShadow()
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString("$" .. REE.Lib.Format.FormatNumberWithCommas(onHand))
            DrawText(OVERLAY_TEXT_X, OVERLAY_TEXT_Y + 0.0175)

            -- render bank balance amount
            local DIVIDE_HEIGHT = 0.065
            SetTextFont(1)
            SetTextProportional(1)
            SetTextScale(0.0, 0.35)
            SetTextColour(255, 255, 255, A)
            SetTextJustification(1)
            SetTextDropShadow()
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString("BALANCE")
            DrawText(OVERLAY_TEXT_X, OVERLAY_TEXT_Y + DIVIDE_HEIGHT)

            SetTextFont(0)
            SetTextProportional(1)
            SetTextScale(0.0, 0.5)
            SetTextColour(255, 255, 255, A)
            SetTextJustification(1)
            SetTextDropShadow()
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString("~g~$" .. REE.Lib.Format.FormatNumberWithCommas(bank))
            DrawText(OVERLAY_TEXT_X, OVERLAY_TEXT_Y + DIVIDE_HEIGHT + 0.0175)

            Citizen.Wait(1)
        else
            Citizen.Wait(100)
        end
    end
end)