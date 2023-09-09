lib.locale()

DrawText = function (msg)
    if KloudDev.DrawText == 'ox' then
        local pos = KloudDev.DrawTextAlignment.."-center"
        lib.showTextUI(msg, {
            position = pos or "right-center"
        })
    elseif KloudDev.DrawText == 'qb' then
        exports['qb-core']:DrawText(msg, KloudDev.DrawTextAlignment)
    end
end

HideText = function ()
    if KloudDev.DrawText == 'ox' then
        lib.hideTextUI()
    elseif KloudDev.DrawText == 'qb' then
        exports['qb-core']:HideText()
    end
end

Progress = function (duration, label, dict, clip)
    if KloudDev.Progress == "ox-circle" then
        local anim = nil
        if dict and clip then
            anim = {
                dict = dict,
                clip = clip
            }
        end
        return lib.progressCircle({
            duration = duration,
            label = label,
            useWhileDead = false,
            canCancel = false,
            position = KloudDev.ProgressCirclePos or "bottom",
            disable = {
                move = true,
                car = true,
                combat = true,
                mouse = false
            },
            anim = anim,
        })
    elseif KloudDev.Progress == "ox-bar" then
        local anim = nil
        if dict and clip then
            anim = {
                dict = dict,
                clip = clip
            }
        end
        return lib.progressBar({
            duration = duration,
            label = label,
            useWhileDead = false,
            canCancel = false,
            disable = {
                move = true,
                car = true,
                combat = true,
                mouse = false
            },
            anim = anim
        })
    end
end

Notify = function (msg, type, duration)
    local dur = duration or 3000
    if KloudDev.Notify == "ox" then
        if GetResourceState("ox_lib") ~= "started" then print("You need ox_lib running for the notifications to work") return end
        if type == "error" then
            lib.notify({
                description = msg,
                icon = 'ban',
                duration = dur,
                iconColor = '#C53030',
                position = KloudDev.NotifyPos or "top-right"
            })
        elseif type == "success" then
            lib.notify({
                description = msg,
                icon = 'check',
                duration = dur,
                iconColor = '#30c56a',
                position = KloudDev.NotifyPos or "top-right"
            })
        end
    elseif KloudDev.Notify == "qb" then
        TriggerEvent('QBCore:Notify', msg, type, dur)
    elseif KloudDev.Notify == "esx" then
        TriggerEvent('esx:showNotification', msg, type, dur)
    elseif KloudDev.Notify == "ps" then
        exports['ps-ui']:Notify(msg, type, dur)
    end
end

SVNotify = function (source, msg, type, duration)
    local dur = duration or 3000
    if KloudDev.Notify == "ox" then
        local randomID = math.random(1, 500)
        if type == "error" then
            TriggerClientEvent('ox_lib:notify', source, {
                description = msg,
                duration = dur,
                icon = 'ban',
                iconColor = '#C53030',
                position = KloudDev.NotifyPos or "top-right"
            })
        elseif type == "success" then
            TriggerClientEvent('ox_lib:notify', source, {
                description = msg,
                duration = dur,
                icon = 'check',
                iconColor = '#30c56a',
                position = KloudDev.NotifyPos or "top-right"
            })
        end
    elseif KloudDev.Notify == "qb" then
        TriggerClientEvent('QBCore:Notify', source, msg, type, dur)
    elseif KloudDev.Notify == "esx" then
        TriggerClientEvent('esx:showNotification', source, msg, type, dur)
    elseif KloudDev.Notify == "ps" then
        TriggerClientEvent('ps-ui:Notify', source, msg, type, dur)
    end
end

FaceEntity = function (entity1, entity2)
    local x, y, z = table.unpack(GetEntityCoords(entity1, true))
    local x1, y1, z1 = table.unpack(GetEntityCoords(entity2, true))

    local dx = x1 - x
    local dy = y1 - y

    local heading = GetHeadingFromVector_2d(dx, dy)
    SetPedDesiredHeading(entity1, heading)
    return tonumber(heading)
end

PlayAnim = function (ped, dict, clip, duration, upperbody)
    lib.requestAnimDict(dict)
    ClearPedTasks(ped)
    TaskPlayAnim(ped, dict, clip, 5.0, 5.0, duration or -1, upperbody and 51 or 0, 0, false, false, false)
end

DeleteProp = function (prop)
    DeleteObject(prop)
end

SkillCheck = function(difficulty, inputs)
    return lib.skillCheck(difficulty, inputs)
end

SpawnPed = function (hash, coords, dict, clip)
    lib.requestModel(hash, 10000)
    local ped = CreatePed(5, joaat(hash), coords.x, coords.y, coords.z, coords.w, false, false)
    FreezeEntityPosition(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetEntityInvincible(ped, true)

    if dict and clip then
        PlayAnim(ped, dict, clip, -1, true)
    end

    return ped
end

CreateProp = function(hash, coords)
    lib.requestModel(hash, 10000)
    local obj = CreateObject(hash, coords.x, coords.y, coords.z + 1, false, true, false)
    SetModelAsNoLongerNeeded(hash)
    return obj
end

CreateBag = function(ped, hash)
    lib.requestModel(hash, 10000)
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local prop = CreateObject(joaat(hash), x, y, z, true, false, false)

    AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 57005), 0.3300, 0.0, -0.0300, 0.0017365, -79.9999997, 110.0651988, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded(hash)
    return prop
end

CreateBagLeft = function(ped, hash)
    lib.requestModel(hash, 10000)
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local prop = CreateObject(joaat(hash), x, y, z, true, false, false)

    AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 18905), 0.3300, 0.0, -0.0300, 0.0017365, -79.9999997, 110.0651988, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded(hash)
    return prop
end