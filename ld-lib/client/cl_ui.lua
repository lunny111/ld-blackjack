local registered = {}

function RegisterUICallback(name, cb)
  local function interceptCb(data, innerCb)
    cb(data, function(result)
      if result.meta.ok then
        result.meta.message = "done"
      end
      innerCb(result)
    end)
  end
  AddEventHandler(('_npx_uiReq:%s'):format(name), interceptCb)

  if (GetResourceState("ld-ui") == "started") then exports["ld-ui"]:RegisterUIEvent(name) end

  registered[#registered + 1] = name
end

function SendUIMessage(data)
  exports["ld-ui"]:SendUIMessage(data)
end

function SetUIFocus(hasFocus, hasCursor)
  exports["ld-ui"]:SetUIFocus(hasFocus, hasCursor)
end

function GetUIFocus()
  return exports["ld-ui"]:GetUIFocus()
end

AddEventHandler("_npx_uiReady", function()
  for _, eventName in ipairs(registered) do
    exports["ld-ui"]:RegisterUIEvent(eventName)
  end
end)
