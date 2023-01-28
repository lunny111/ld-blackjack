#How To Using me XD

###
client_script "@ld-lib/client/cl_ui.lua"
###

add that in fxmanifest.lua another resource who want will access 

i will update that adter sleep lol XD

#TextBox Aplication

###
exports['ld-ui']:openApplication('textbox', {
    callbackUrl = 'ld-ui:scenes:input', -> callbackUIName
    key = 1,
    items = {
        {
            icon = "fas fa-pencil-alt", -> Icon
            label = "Text", -> Text Label
            name = "text", 
        },
        {
            icon = "fas fa-palette",
            label = "Color (white, red, green, yellow, blue)",
            name = "color",
        },
        {
            icon = "fas fa-people-arrows",
            label = "Distance (0.1 - 10)",
            name = "distance",
        },
    },
    show = true,
})

after that make RegisterUiCallback

RegisterUICallback("ld-ui:scenes:input", function(data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    exports['ld-ui']:closeApplication('textbox')
   
    local text = data[1].value
    local color = data[2].value
    local distance = tonumber(data[3].value) + 0.01
    local key = data[4].value
    if distance < 0.1 or distance > 10 then
      distance = 10
    end
    RPC.execute("rated-scenes:addScene", {
      coords = activePos,
      text = text,
      distance = distance,
      color = color,
    })
end)
###

#ContextMenu Example

###
function showWheelChairMenu()
    local data = {
        {
            title = "Buy Wheelchair ($10,000)",
            description = "Buy a personal Wheelchair.",
            key = true,
            children = {
				{ title = "Confirm Purchase", action = "ld-ui:wheelchairPurchase", key = true }, -> action is name of UICallback
			},
        },
    }

    exports["ld-ui"]:showContextMenu(data)
end

RegisterUICallback("ld-ui:wheelchairPurchase", function(data, cb)

	local finished = exports["rated-taskbar"]:taskBar(10000, "Purchasing...", true)
	if finished ~= 100 then
	  cb({ data = {}, meta = { ok = false, message = 'cancelled' } })
	  return
	end
	
	local success, message = RPC.execute("wheelchair:purchase")
	if not success then
		cb({ data = {}, meta = { ok = success, message = message } })
		TriggerEvent("DoLongHudText", message, 2)
		return
	end

	TriggerEvent("player:receiveItem","wheelchair",1)
	
	cb({ data = {}, meta = { ok = true, message = "done" } })
end)
####

#Skillbar Example

####
exports["ld-ui"]:taskBarSkill(timer, skillGapSent)
####

#Set Value UI

###
exports["ld-ui"]:sendAppEvent("hud", {
    health = values(0-100),
    armor = values(0-100),
    food = values(0-100),
    water = values(0-100),
    oxygen = values(0-100),
    stress = values(0-100),
    stamina = values(0-100),
    voice = values(0-100),
    fuel = values(0-100),
    beltShow = true/ false,
    engineDamageShow = true / false,
    gasDamageShow = true / false
})
###

#Dev Mode or Debug Mode UI

###
exports["ld-ui"]:sendAppEvent("game", {
    modeDev = true / false,
    modeDebug = true / false,
})
###
