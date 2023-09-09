if GetResourceState("ox_inventory") ~= "started" then return end

Inventory = exports.ox_inventory

AddItem = function(inv, item, amount, metadata)
    local metadata = metadata or nil
    return Inventory:AddItem(inv, item, amount, metadata)
end

RemoveItem = function(inv, item, amount, metadata, slot)
    local metadata = metadata or nil
    local slot = slot or nil

    return Inventory:RemoveItem(inv, item, amount, metadata, slot)
end

CanCarryItem = function(inv, item, amount)
    return Inventory:CanCarryItem(inv, item, amount)
end

GetItemCount = function(inv, item)
    return Inventory:GetItemCount(inv, item, nil, false)
end

GetSlotWithItem = function(inv, item, metadata, strict)
    local metadata = metadata or nil
    local strict = strict or false
    return Inventory:GetSlotWithItem(inv, item, metadata, strict)
end

SetDurability = function(inv, slot, durability)
    return Inventory:SetDurability(inv, slot, durability)
end