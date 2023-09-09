local qbVariations = {"qb-inventory", "ps-inventory", "lj-inventory"}
local Inventory = exports["qb-inventory"]
local foundInv = false

for i = 1, #qbVariations do
    if GetResourceState(qbVariations[i]) ~= "started" then
        if i == #qbVariations then
            if not foundInv then
                return
            end
        end
    else
        foundInv = true
        Inventory = exports[qbVariations[i]]
    end
end

AddItem = function(inv, item, amount, metadata)
    local metadata = metadata or nil
    if Inventory:AddItem(inv, item, amount, false, metadata) then
        for i = 1, amount do
            TriggerClientEvent('inventory:client:ItemBox', inv, QBCore.Shared.Items[item], 'add')
        end
        return true
    end
    return false
end

RemoveItem = function(inv, item, amount, metadata, slot)
    local metadata = metadata or nil
    local slot = slot or nil

    if Inventory:RemoveItem(inv, item, amount, slot) then
        for i = 1, amount do
            TriggerClientEvent('inventory:client:ItemBox', inv, QBCore.Shared.Items[item], 'remove')
        end
        return true
    end
    return false
end

CanCarryItem = function(inv, item, amount)
    return true
end

GetItemCount = function(inv, item)
    if #Inventory:GetItemsByName(inv, item) >= 1 then return true end
    return false
end

GetSlotWithItem = function(inv, item, metadata, strict)
    local metadata = metadata or nil
    local strict = strict or false
    local Player = GetPlayer(inv)
    return Inventory:GetFirstSlotByItem(Player.PlayerData.items, item)
end

SetDurability = function(inv, slot, durability)
    return true
end

lib.callback.register("GetItemCount", function(source, item)
    local items = Inventory:GetItemsByName(source, item)
    for k, v in pairs(items) do
        return v.amount
    end
    return 0
end)