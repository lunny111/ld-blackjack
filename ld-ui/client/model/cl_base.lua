-- RegisterNetEvent("ld-ui:client:InitUI")
-- AddEventHandler("ld-ui:client:InitUI", function()
--     print("[ld-ui] Initalize Hud")
--     local toggleData = {
--         health = GetResourceKvpString('healthshow'),
--         armor = GetResourceKvpString('armorshow'),
--         hunger = GetResourceKvpString('hungershow'),
--         thirst = GetResourceKvpString('thirstshow'),
--         stamina = GetResourceKvpString('staminashow'),
--         oxygen = GetResourceKvpString('oxyshow'),
--         stress = GetResourceKvpString('stressshow'),
--         voice = GetResourceKvpString('voiceshow'),
--     }

--     local colorData = {
--         health = GetResourceKvpString('#health'),
--         armor = GetResourceKvpString('#armor'),
--         hunger = GetResourceKvpString('#hunger'),
--         thirst = GetResourceKvpString('#thirst'),
--         stamina = GetResourceKvpString('#stamina'),
--         oxygen = GetResourceKvpString('#oxygen'),
--         stress = GetResourceKvpString('#stress'),
--         voice = GetResourceKvpString('#voice'),
--     }

--     Citizen.Wait(500)
--     SendNUIMessage({
--         action = "initialize",
--         toggledata = toggleData,
--         colordata = colorData,
--     })
    
-- end)

function SetUIFocus(hasKeyboard, hasMouse)
    SetNuiFocus(hasKeyboard, hasMouse)
end
    
exports('SetUIFocus', SetUIFocus)

RegisterNUICallback("ld-ui:closeApp", function(data, cb)
    SetNuiFocus(false, false)
    SetUIFocus(false, false)
    cb({data = {}, meta = {ok = true, message = 'done'}})
end)

RegisterNUICallback("ld-ui:applicationClosed", function(data, cb)
    TriggerEvent("ld-ui:application-closed", data.name, data)
    cb({data = {}, meta = {ok = true, message = 'done'}})
    SetNuiFocus(false, false)
end)

-- SMALL MAP
-- RegisterCommand("ld-ui:small-map", function()
--     SetRadarBigmapEnabled(false, false)
-- end, false)

-- RegisterCommand("testbugui", function()
--     SetNuiFocus(true, true)
--     SetUIFocus(true, true)
-- end)

RegisterCommand("clearui", function()
    exports["ld-ui"]:showInteraction("Clearing UI .")
    Wait(1000)
    exports["ld-ui"]:showInteraction("Clearing UI ..")
    Wait(1000)
    exports["ld-ui"]:showInteraction("Clearing UI ...")
    Wait(1000)
    SetNuiFocus(false, false)
    SetUIFocus(false, false)
    exports["ld-ui"]:showInteraction("UI Cleared !", "success")
    Wait(1000)
    exports["ld-ui"]:hideInteraction()
    exports["ld-ui"]:hideInteraction("success")
end)

RegisterCommand("clearanim", function()
    exports["ld-ui"]:showInteraction("Stopping Animation .")
    Wait(1000)
    exports["ld-ui"]:showInteraction("Stopping Animation ..")
    Wait(1000)
    exports["ld-ui"]:showInteraction("Stopping Animation ...")
    Wait(1000)
    ClearPedTasks(GetPlayerPed(-1))
    ClearPedTasks(PlayerPedId())
    exports["ld-ui"]:showInteraction("Animation Cleared !", "success")
    Wait(1000)
    exports["ld-ui"]:hideInteraction()
    exports["ld-ui"]:hideInteraction("success")
end)

-- RegisterNetEvent("hidecursorbitch")
-- AddEventHandler("hidecursorbitch", function()
--     SetNuiFocus(false, false)
--     SetUIFocus(false, false)
-- end)

-- RegisterNUICallback("ld-ui:hidecursorbitch", function(data, cb)
--     SetNuiFocus(false, false)
--     SetUIFocus(false, false)
-- end)