AddEventHandler("delivery:start_delivery", function(data)
    local current_stock = lib.callback.await("delivery:callback:get_current_stock", false, data)
    if current_stock < 1 then
        Notify(locale("no_stock"), "error")
        return
    end

    local can_start = lib.callback.await("delivery:callback:can_start", false, data)
    if not can_start then return end
    
    _G.Busy = true
    local bag = CreateBag(SpawnedEntities.Ped[data.pedID], `prop_food_bs_bag_01`)
    PlayAnim(SpawnedEntities.Ped[data.pedID], "mp_common", "givetake1_b", 1600, true)
    PlayAnim(cache.ped, "mp_common", "givetake1_a", 1600, true)
    
    SetTimeout(1600, function()
        DeleteProp(bag)
        bag = CreateBag(cache.ped, data.bag_model)
        ClearPedTasks(cache.ped)
        ClearPedTasks(SpawnedEntities.Ped[data.pedID])
    end)
    if not Progress(2000, locale("requesting")) then return end
    DeleteProp(bag)
    _G.Busy = false
    TriggerServerEvent("delivery:server:start_delivery", data)
    StartDelivery(data)
    Notify(locale("delivery_started"), "success")
end)

AddEventHandler("delivery:client:bag_anim", function(hash)
    local dict = "move_weapon@jerrycan@generic"
    local clip = "idle"
    SpawnedEntities.Delivery_Prop[1] = CreateBag(cache.ped, hash)
    while true do
        Wait(500)
        if not _G.OnGoing then return end

        if IsPedInAnyVehicle(cache.ped, true) then
            ClearPedTasks(cache.ped)
            DeleteProp(SpawnedEntities.Delivery_Prop[1])
            SpawnedEntities.Delivery_Prop[1] = nil
        end

        if not IsEntityPlayingAnim(cache.ped, dict, clip, 3) and not IsPedInAnyVehicle(cache.ped, true) and not _G.Busy and not IsPedFalling(cache.ped) then
            PlayAnim(cache.ped, dict, clip, -1, true)
            if not SpawnedEntities.Delivery_Prop[1] then
                SpawnedEntities.Delivery_Prop[1] = CreateBag(cache.ped, hash)
            end
        end
    end
end)