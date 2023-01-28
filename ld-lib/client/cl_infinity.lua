function IsPlayerActive(pServerId)
    return exports['tp-infinity']:IsPlayerActive(pServerId)
end

function DoesPlayerExist(pServerId)
    return exports['tp-infinity']:DoesPlayerExist(pServerId)
end

function GetPlayerCoords(pServerId)
    return exports['tp-infinity']:GetPlayerCoords(pServerId)
end

function GetNetworkedCoords(pType, pNetId)
    return exports['tp-infinity']:GetNetworkedCoords(pType, pNetId)
end

function GetLocalEntity(pType, pNetId)
    return exports['tp-infinity']:GetLocalEntity(pType, pNetId)
end