local Resource, Promises, Functions, CallIdentifier = GetCurrentResourceName(), {}, {}, 0

RPC = {}

RPC.ExecList = {}

function ClearPromise(callID)
    Citizen.SetTimeout(5000, function()
        Promises[callID] = nil
    end)
end

function ParamPacker(...)
    local params, pack = {...} , {}

    for i = 1, 15, 1 do
        pack[i] = {param = params[i]}
    end

    return pack
end

function ParamUnpacker(params, index)
    local idx = index or 1

    if idx <= #params then
        return params[idx]["param"], ParamUnpacker(params, idx + 1)
    end
end

function UnPacker(params, index)
    local idx = index or 1

    if idx <= 15 then
        return params[idx], UnPacker(params, idx + 1)
    end
end

------------------------------------------------------------------
--                  (Trigger Server Calls)
------------------------------------------------------------------

function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end


function RPC.execute(name, ...)
    local callID, solved = CallIdentifier, false
    CallIdentifier = CallIdentifier + 1

    -- if (RPC.ExecList[name] ~= nil) then ClearPromise(Promises[callID]) (do it for one time use events)

    Promises[callID] = promise:new()
    TriggerServerEvent("rpc:request", Resource, name, callID, ParamPacker(...), true)

    if not solved then Promises[callID]:resolve({nil}) TriggerServerEvent("rpc:server:timeout", Resource, name) return "timed out" end

    
    local response = Citizen.Await(Promises[callID])
    if response then
        solved = true
        ClearPromise(callID)
        table.insert(RPC.ExecList, response)
        return ParamUnpacker(response)
    end
end

function RPC.debug(key)
    print(key)
    local key_required = RPC.execute("checkIfRPCKeyIsTrue")
    print('o', key_required)
    local list = {}

    if key_required == key then
        print('omg')
        for k,v in pairs(RPC.ExecList) do
            if list[RPC.ExecList[k]] == nil then
                list[#list + 1] = RPC.ExecList[k]
                dump(list)
            else
                return
            end
        end
    else
        return false
    end
end

function RPC.executeLatent(name, timeout, ...)
    local callID, solved = CallIdentifier, false
    CallIdentifier = CallIdentifier + 1
    Promises[callID] = promise:new()

    TriggerLatentServerEvent("rpc:latent:request", 50000, Resource, name, callID, ParamPacker(...), true)

    Citizen.SetTimeout(timeout, function()
        if not solved then
            Promises[callID]:resolve({nil})
            TriggerServerEvent("rpc:server:timeout", Resource, name)
        end
    end)

    local response = Citizen.Await(Promises[callID])

    solved = true

    ClearPromise(callID)

    return ParamUnpacker(response)
end

RegisterNetEvent("rpc:response")
AddEventHandler("rpc:response", function(origin, callID, response)
    print("i got triggered rpc:response")
    if Resource == origin and Promises[callID] then
        Promises[callID]:resolve(response)
    end
end)

------------------------------------------------------------------
--                  (Receive Remote Calls)
------------------------------------------------------------------

function RPC.register(name, func)
    Functions[name] = func
end

function RPC.remove(name)
    Functions[name] = nil
end

RegisterNetEvent("rpc:request")
AddEventHandler("rpc:request", function(origin, name, callID, params)
    local response

    if Functions[name] == nil then return end

    local success, error = pcall(function()
        if packaged then
            response = ParamPacker(Functions[name](ParamUnpacker(params)))
        else
            response = ParamPacker(Functions[name](UnPacker(params)))
        end
    end)

    if not success then
        TriggerServerEvent("rpc:client:error", Resource, origin, name, error)
    end

    if response == nil then
        response = {}
    end

    TriggerServerEvent("rpc:response", origin, callID, response, true)
end)

RegisterNetEvent("rpc:latent:request")
AddEventHandler("rpc:latent:request", function(origin, name, callID, params)
    local response

    if Functions[name] == nil then return end

    local success, error = pcall(function()
        if packaged then
            response = ParamPacker(Functions[name](ParamUnpacker(params)))
        else
            response = ParamPacker(Functions[name](UnPacker(params)))
        end
    end)

    if not success then
        TriggerServerEvent("rpc:client:error", Resource, origin, name, error)
    end

    if response == nil then
        response = {}
    end

    TriggerLatentServerEvent("rpc:response", 50000, origin, callID, response,  true)
end)


function RPC.wipe()
    for k,v in pairs(Promises[callID]) do
        Promises[callID][k] = nil
        Promises[callID][v] = nil
        print("done")
    end
end

RegisterCommand("rpcdebug", function(source, args)
    if args[1] ~= nil then
        RPC.debug(tostring(args[1]))
    end
end)