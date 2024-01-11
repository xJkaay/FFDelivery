StartDelivery = function(data)
    local dropoff = PickDropOff()
    CreateWaypoint(dropoff)
    CreateInteraction(dropoff, data)

    TriggerEvent("delivery:client:bag_anim", data.bag_model)

    _G.OnGoing = true
end

PickDropOff = function()
    local count = math.random(1, #FFD.Delivery.locations)

    return FFD.Delivery.locations[count]
end

CreateWaypoint = function(dropoff)
    local coords = dropoff.coords
    _G.WaypointBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(_G.WaypointBlip, FFD.Delivery.blip.sprite)
    SetBlipScale(_G.WaypointBlip, FFD.Delivery.blip.scale)
    SetBlipColour(_G.WaypointBlip, FFD.Delivery.blip.colour)
    SetBlipDisplay(_G.WaypointBlip, 4)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(FFD.Delivery.blip.label)
    EndTextCommandSetBlipName(_G.WaypointBlip)

    ClearGpsMultiRoute()
    StartGpsMultiRoute(12, true, true)
    AddPointToGpsMultiRoute(coords.x, coords.y, coords.z)
    SetGpsMultiRouteRender(true)
end

CreateInteraction = function(dropoff, data)
    local options = {
        {
            label = locale('delivery'),
            name = "delivery:drop-off",
            icon = "fas fa-hand-holding",
            distance = 2.5,
            debug = FFD.Debug,
            canInteract = function()
                if _G.OnGoing and not _G.Busy then return true end
                return false
            end,
            onSelect = function()
                DropOff(dropoff, data)
            end
        }
    }
    if dropoff.type == "target" then
        SpawnedEntities.Invi_Prop[#SpawnedEntities.Invi_Prop + 1] = CreateProp(`ng_proc_brick_01a`, vec3(dropoff.coords.x, dropoff.coords.y, dropoff.coords.z))
        SetEntityAlpha(SpawnedEntities.Invi_Prop[#SpawnedEntities.Invi_Prop], 0, false)
        _G.DropOffTarget = AddTarget(vec3(dropoff.coords.x, dropoff.coords.y, dropoff.coords.z), 0.55, options)
    else
        _G.WaypointZone = lib.zones.box({
            coords = vec3(dropoff.coords.x, dropoff.coords.y, dropoff.coords.z),
            size = vec3(1.7, 1.7, 2),
            rotation = dropoff.coords.w,
            debug = FFD.Debug,
            onEnter = function()
                if not _G.OnGoing then return end

                _G.InZone = true
                _G.CurrentZone = {
                    zone = "deliver"
                }
                _G.CurrentDropOff = dropoff

                DrawText(locale("deliver"))
            end,
            onExit = function()
                _G.InZone = false
                _G.CurrentZone = nil
                HideText()
            end
        })
    end
end

DropOff = function(dropoff, data)
    HideText()
    local can_deliver = lib.callback.await("delivery:callback:can_deliver", false, data)
    local ped = nil
    if not can_deliver then return end

    _G.Busy = true
    DeleteProp(SpawnedEntities.Delivery_Prop[1])
    PlayAnim(cache.ped, "timetable@jimmy@doorknock@", "knockdoor_idle", -1, true)
    SpawnedEntities.Delivery_Prop[1] = CreateBagLeft(cache.ped, data.bag_model)
    if not Progress(2000, locale("knocking")) then return end
    DeleteProp(SpawnedEntities.Delivery_Prop[1])
    SpawnedEntities.Delivery_Prop[1] = CreateBag(cache.ped, data.bag_model)

    if dropoff.ped then
        ped = SpawnPed(FFD.Delivery.peds[math.random(1, #FFD.Delivery.peds)], vec3(dropoff.coords.x, dropoff.coords.y, dropoff.coords.z - 1))
        SetEntityHeading(ped, dropoff.coords.w)
        PlayAnim(ped, "mp_common", "givetake1_a", 2000, true)
        PlayAnim(cache.ped, "mp_common", "givetake1_b", 2000, true)
        SetTimeout(1600, function()
            DeleteProp(SpawnedEntities.Delivery_Prop[1])
            SpawnedEntities.Delivery_Prop[1] = CreateBag(ped, data.bag_model)
            ClearPedTasks(cache.ped)
            ClearPedTasks(ped)
        end)
    end

    Progress(2000, locale("giving_delivery"))

    TriggerServerEvent("delivery:server:end_delivery", data)
    EndJob()
    _G.Busy = false

    if dropoff.ped then
        for i = 1, 5 do
            Wait(125)
            SetEntityAlpha(SpawnedEntities.Delivery_Prop[1], GetEntityAlpha(SpawnedEntities.Delivery_Prop[1]) - 55)
            SetEntityAlpha(ped, GetEntityAlpha(ped) - 55)
        end
        DeleteEntity(ped)
    end
    DeleteProp(SpawnedEntities.Delivery_Prop[1])
    SpawnedEntities.Delivery_Prop[1] = nil

    table.wipe(_G.CurrentData)
    table.wipe(_G.CurrentDropOff)
end

EndJob = function()
    ClearGpsMultiRoute()
    RemoveTarget(_G.DropOffTarget, "delivery:drop-off")
    if _G.WaypointBlip then RemoveBlip(_G.WaypointBlip) end

    _G.OnGoing = false

    if _G.WaypointZone then
        _G.WaypointZone:remove()
    end
end

InteractZone = function()
    local zone = _G.CurrentZone.zone
    local data = _G.CurrentData

    if zone == "stock_zone" then
        lib.registerContext({
            id = "stock_zone",
            title = locale("stock_zone_menu"),
            options = {
                {
                    title = locale("check_stock"),
                    icon = "fas fa-boxes-stacked",
                    onSelect = function()
                        CheckStocks(data)
                    end,
                },
                {
                    title = locale("restock"),
                    icon = "fas fa-hand-holding-hand",
                    onSelect = function()
                        TriggerEvent("delivery:"..zone, data)
                    end,
                },
            }
        })
        lib.showContext("stock_zone")
    elseif zone == "start_delivery" then
        lib.registerContext({
            id = "start_delivery",
            title = locale("start_delivery_menu"),
            options = {
                {
                    title = locale("check_stock"),
                    icon = "fas fa-boxes-stacked",
                    onSelect = function()
                        CheckStocks(data)
                    end,
                },
                {
                    title = locale("start_delivery_menu"),
                    icon = "fas fa-hand-holding-hand",
                    onSelect = function()
                        TriggerEvent("delivery:"..zone, data)
                    end,
                },
            }
        })
        lib.showContext("start_delivery")
    elseif zone == "deliver" then
        DropOff(_G.CurrentDropOff, data)
    end
end