resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
description 'REE Money'
version '1.0.0'

client_scripts {
    -- load NativeUILua-Reloaded
    "@NativeUILua-Reloaded/Wrapper/Utility.lua",
    "@NativeUILua-Reloaded/UIElements/UIVisual.lua",
    "@NativeUILua-Reloaded/UIElements/UIResRectangle.lua",
    "@NativeUILua-Reloaded/UIElements/UIResText.lua",
    "@NativeUILua-Reloaded/UIElements/Sprite.lua",
    "@NativeUILua-Reloaded/UIMenu/elements/Badge.lua",
    "@NativeUILua-Reloaded/UIMenu/elements/Colours.lua",
    "@NativeUILua-Reloaded/UIMenu/elements/ColoursPanel.lua",
    "@NativeUILua-Reloaded/UIMenu/elements/StringMeasurer.lua",

    "@NativeUILua-Reloaded/UIProgressBar/UIProgressBarPool.lua",
    "@NativeUILua-Reloaded/UIProgressBar/items/UIProgressBarItem.lua",

    "@NativeUILua-Reloaded/UIMenu/items/UIMenuItem.lua",
    "@NativeUILua-Reloaded/UIMenu/items/UIMenuCheckboxItem.lua",
    "@NativeUILua-Reloaded/UIMenu/items/UIMenuListItem.lua",
    "@NativeUILua-Reloaded/UIMenu/items/UIMenuSliderItem.lua",
    "@NativeUILua-Reloaded/UIMenu/items/UIMenuSliderHeritageItem.lua",
    "@NativeUILua-Reloaded/UIMenu/items/UIMenuColouredItem.lua",

    "@NativeUILua-Reloaded/UIMenu/items/UIMenuProgressItem.lua",
    "@NativeUILua-Reloaded/UIMenu/items/UIMenuSliderProgressItem.lua",

    "@NativeUILua-Reloaded/UIMenu/windows/UIMenuHeritageWindow.lua",

    "@NativeUILua-Reloaded/UIMenu/panels/UIMenuGridPanel.lua",
    "@NativeUILua-Reloaded/UIMenu/panels/UIMenuHorizontalOneLineGridPanel.lua",
    "@NativeUILua-Reloaded/UIMenu/panels/UIMenuVerticalOneLineGridPanel.lua",
    "@NativeUILua-Reloaded/UIMenu/panels/UIMenuColourPanel.lua",
    "@NativeUILua-Reloaded/UIMenu/panels/UIMenuPercentagePanel.lua",
    "@NativeUILua-Reloaded/UIMenu/panels/UIMenuStatisticsPanel.lua",

    "@NativeUILua-Reloaded/UIMenu/UIMenu.lua",
    "@NativeUILua-Reloaded/UIMenu/MenuPool.lua",
    "@NativeUILua-Reloaded/NativeUI.lua",

    'shared/_globals.lua',
    'client/_globals.lua',
    'client/bank_world.lua',
    'client/events.lua',
    'client/functions.lua',
    'client/money.lua',
    'client/overlay.lua',
    'client/thread.lua',
    'client/world/atms.lua',
    'client/world/banks.lua',
}

server_scripts {
    -- load dependencies
    '@async/async.lua',
    '@mysql-async/lib/MySQL.lua',

    'shared/_globals.lua',

    'server/_globals.lua',
    'server/events.lua',
    'server/migrations.lua',
    'server/money.lua',
}

dependencies {
    'async',
    'mysql-async',
    'NativeUILua-Reloaded',
    'ree-core',
    'ree-map',
}

