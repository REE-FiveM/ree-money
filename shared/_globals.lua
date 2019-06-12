-- :: REE Money - Globals
--  : This constructs globals necessary for creating the money integration
--

REE = nil

-- load REE instance data
TriggerEvent("ree:getInstance", function(_REE) REE = _REE end)
while REE == nil do Citizen.Wait(5) end

MoneyAccountTypes = { ON_HAND = 1, DEBT = 2, BANK = 3 }

