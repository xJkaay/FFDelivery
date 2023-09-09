_G = {
    WaypointBlip = nil,
    DropOffTarget = nil,
    OnGoing = false,
    Busy = false,
    InZone = false,
    CurrentData = {},
    CurrentDropOff = {}
}

SpawnedEntities = {
    Ped = {},
    Invi_Prop = {},
    Delivery_Prop = {}
}

local CreateTargets = function()
    for job, data in pairs(KloudDev.Locations) do
        for k, v in pairs(data.positions) do
            if v.type == "target" then
                local options = {
                    {
                        label = locale('delivery:'..k),
                        name = 'delivery:'..k,
                        icon = "fas fa-hand-holding-hand",
                        distance = 2.5,
                        debug = KloudDev.Debug,
                        canInteract = function()
                            if v.job.required then
                                if PlayerJob.name == v.job.job_name and not _G.OnGoing then return true end
                            else
                                if not _G.OnGoing then return true end
                            end

                            return false
                        end,
                        onSelect = function()
                            data.job = job
                            data.pedID = job.." "..k
                            TriggerEvent("delivery:"..k, data)
                        end
                    },
                    {
                        label = locale('check_stock'),
                        name = 'delivery:check_stocks'..job..k,
                        icon = "fas fa-boxes-stacked",
                        distance = 2.5,
                        debug = KloudDev.Debug,
                        canInteract = function()
                            if v.job.required then
                                if PlayerJob.name == v.job.job_name and not _G.OnGoing then return true end
                            else
                                if not _G.OnGoing then return true end
                            end

                            return false
                        end,
                        onSelect = function()
                            data.job = job
                            data.pedID = job.." "..k

                            CheckStocks(data)
                        end
                    },
                }
                if v.ped.enabled then
                    SpawnedEntities.Ped[job.." "..k] = SpawnPed(v.ped.model, v.coords, v.ped.animation.dict, v.ped.animation.clip)
                    AddEntityTarget(SpawnedEntities.Ped[job.." "..k], options)
                else
                    SpawnedEntities.Invi_Prop[job.." "..k] = CreateProp(`ng_proc_brick_01a`, v.coords)
                    SetEntityAlpha(SpawnedEntities.Invi_Prop[job.." "..k], 0, false)
                    AddTarget(vec3(v.coords.x, v.coords.y, v.coords.z + 1), 0.55, options)
                end
            else
                if v.ped.enabled then
                    SpawnedEntities.Ped[job.." "..k] = SpawnPed(v.ped.model, v.coords, v.ped.animation.dict, v.ped.animation.clip)
                end
                lib.zones.box({
                    coords = vec3(v.coords.x, v.coords.y, v.coords.z + 1),
                    size = vec3(1.7, 1.7, 2),
                    rotation = v.coords.w,
                    debug = KloudDev.Debug,
                    onEnter = function()
                        if _G.OnGoing then return end

                        _G.InZone = true

                        data.job = job
                        data.pedID = job.." "..k

                        _G.CurrentZone = {
                            zone = k
                        }
                        _G.CurrentData = data
                        DrawText(locale(k))
                    end,
                    onExit = function()
                        _G.InZone = false
                        table.wipe(_G.CurrentZone)
                        HideText()
                    end
                })
            end
        end
    end
end

local CreateBlips = function()
    for _, data in pairs(KloudDev.Locations) do
        local blip = data.blip
        if blip.enabled then
            local jobBlip = AddBlipForCoord(blip.coords.x, blip.coords.y, blip.coords.z)
            SetBlipSprite(jobBlip, blip.sprite)
            SetBlipDisplay(jobBlip, 4)
            SetBlipScale(jobBlip, blip.scale)
            SetBlipColour(jobBlip, blip.colour)
            SetBlipAsShortRange(jobBlip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(blip.label)
            EndTextCommandSetBlipName(jobBlip)
        end
    end
end

local Init = function()
    CreateTargets()
    CreateBlips()
end

CreateThread(Init)

AddEventHandler("onResourceStop", function(name)
    if GetCurrentResourceName() ~= name then return end
    for _, v in pairs(SpawnedEntities) do
        for _, b in pairs(v) do
            if DoesEntityExist(b) then
                DeleteEntity(b)
            end
        end
    end

    HideText()
end)

RegisterCommand("delivery:interact", function()
    if not _G.InZone or _G.Busy then return end

    InteractZone()
end, false)

RegisterKeyMapping("delivery:interact", "Interact", "keyboard", "e")