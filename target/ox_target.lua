if GetResourceState("ox_target") ~= "started" then return end

AddTarget = function (coords, radius, options)
    return exports.ox_target:addSphereZone({
        coords = coords,
        radius = radius or 2.0,
        debug = KloudDev.Debug,
        drawSprite = KloudDev.DrawSprite,
        options = options
    })
end

RemoveTarget = function (id, name)
    exports.ox_target:removeZone(id, name)
end
AddEntityTarget = function (entity, options)
    if NetworkGetEntityIsNetworked(entity) then
        local netId = NetworkGetNetworkIdFromEntity(entity)
        exports.ox_target:addEntity(netId, options)
    else
        exports.ox_target:addLocalEntity(entity, options)
    end
end

RemoveEntityTarget = function(entity, optionNames)
    if NetworkGetEntityIsNetworked(entity) then
        local netId = NetworkGetNetworkIdFromEntity(entity)
        exports.ox_target:removeEntity(netId, optionNames)
    else
        exports.ox_target:removeLocalEntity(entity, optionNames)
    end
end

AddTargetModel = function(model, options)
    exports.ox_target:addModel(model, options)
end

RemoveTargetModel = function(models, optionNames, optionLabels)
    exports.ox_target:removeModel(models, optionNames)
end
