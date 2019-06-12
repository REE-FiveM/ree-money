local Locations = REE.Data.Locations
local Icons     = REE.Data.BlipIcons
local Colors    = REE.Data.BlipColors
local ATMs      = Locations.ATMs
local Banks     = Locations.Banks

TriggerEvent("ree-map:registerNearbyBlipList", "ree-money:atms", ATMs, nil, Icons["ATM"], Colors["WHITE"], "ATM")
TriggerEvent("ree-map:registerBlipList", "ree-money:banks", Banks, Icons["BANK"], Colors["WHITE"], "Bank")
