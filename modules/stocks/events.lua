AddEventHandler("delivery:stock_zone", function(data)
    local can_stock = lib.callback.await("delivery:callback:can_stock", false, data)
    if not can_stock then return end

    _G.Busy = true
    local bag = CreateBag(cache.ped, data.bag_model)
    PlayAnim(SpawnedEntities.Ped[data.pedID], "mp_common", "givetake1_a", -1, true)
    PlayAnim(cache.ped, "mp_common", "givetake1_b", -1, true)

    SetTimeout(1600, function()
        DeleteProp(bag)
        bag = CreateBag(SpawnedEntities.Ped[data.pedID], data.bag_model)
        ClearPedTasks(cache.ped)
        ClearPedTasks(SpawnedEntities.Ped[data.pedID])
    end)

    if not Progress(2000, locale("adding_stock")) then return end

    DeleteProp(bag)
    _G.Busy = false
    lib.callback("delivery:callback:add_stock", false, nil, data)
end)