local menuItems = {

    { label = 'TRUNK', icon = 'fa-regular fa-face-laugh-squint', event = '', shouldclose = true},
    { label = 'ESCORT', icon = 'fa-solid fa-users', event = 'police:client:KidnapPlayer', shouldclose = true},
    { label = 'SHARE CONTACT', icon = 'fa-solid fa-phone', event = 'qb-phone:client:GiveContactDetails', shouldclose = true},
    {
        label = 'CLOTHING',
        icon = 'fa-solid fa-shirt',
        items = {
            { label = 'HAT', icon = 'fa-solid fa-hat-cowboy', event = ''},
            { label = 'GLASSES', icon = 'fa-solid fa-glasses', event = ''},
            { label = 'MASK', icon = 'fa-solid fa-mask', event = ''},
            { label = 'SHIRT', icon = 'fa-solid fa-shirt', event = ''},
            { label = 'PANTS', icon = 'fa-solid fa-person-walking', event = ''},
            { label = 'SHOES', icon = 'fa-solid fa-shoe-prints', event = ''},
        },
        shouldclose = false
    },
    { label = '', icon = 'fa-regular fa-star', event = 'emotes:OpenMenu', shouldclose = true},
    { label = 'KEYS', icon = 'fa-solid fa-key', event = 'emotes:OpenMenu', shouldclose = true},
    { label = 'VEHICLE ACTIONS', icon = 'fa-solid fa-car', event = 'ac-carcontrol:openMenu', shouldclose = true},
    { label = 'WALK STYLES', icon = 'fa-solid fa-person-walking', event = 'emotes:OpenMenu', shouldclose = true},
    { label = 'EMOTE MENU', icon = 'fa-solid fa-masks-theater', event = 'emotes:OpenMenu', shouldclose = true},
    { label = 'BANK', icon = 'fa-solid fa-dollar-sign', event = 'emotes:OpenMenu', shouldclose = true},
    { label = 'TRUNK', icon = 'fa-regular fa-lightbulb', event = 'qb-trunk:client:GetIn', shouldclose = true},
}
local isMenuVisible = false
local toggleCooldown = false

local function toggleMenu()
    if toggleCooldown then return end
    toggleCooldown = true

    if not isMenuVisible then
        PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
        isMenuVisible = true
        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(true)
        SendNUIMessage({
            action = 'updateMenuItems',
            items = menuItems
        })
    else
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
        isMenuVisible = false
        SendNUIMessage({
            action = 'closeMenu'
        })
    end

    SetTimeout(1000, function()
        toggleCooldown = false
    end)
end

RegisterCommand('togglemenu', function()
    toggleMenu()
end, false)

RegisterKeyMapping('togglemenu', 'Toggle Radial Menu', 'keyboard', 'F1')

RegisterNUICallback('menuItemClicked', function(data, cb)
    local label = data.label
    local selectedItem = nil

    -- Find the clicked item
    for _, item in ipairs(menuItems) do
        if item.label == label then
            selectedItem = item
            break
        end
    end

    if selectedItem then
        if selectedItem.items and #selectedItem.items > 0 then
            SendNUIMessage({
                action = 'updateMenuItems',
                items = selectedItem.items
            })
        else
            if selectedItem.event and selectedItem.event ~= '' then
                TriggerEvent(selectedItem.event)
            end

            if selectedItem.shouldclose then
                SetNuiFocus(false, false)
                SetNuiFocusKeepInput(false)
                isMenuVisible = false
                
                SendNUIMessage({
                    action = 'closeMenu'
                })
            end
        end
        cb('ok')
    else
        cb('error')
    end
end)

RegisterNUICallback('closemenu', function(data, cb)
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    isMenuVisible = false
    SendNUIMessage({ action = 'closeMenu' })
    cb('ok')
end)


CreateThread(function ()
    while true do
        if isMenuVisible then
            DisablePlayerFiring(PlayerPedId(), true)
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(2, 199, true)
            DisableControlAction(2, 200, true)
        end
		Wait(5)
	end
end)