CheckStocks = function(data)
    _G.Busy = true
    if not Progress(3000, locale("checking_stocks")) then return end

    local result = lib.callback.await("delivery:callback:get_current_stock", false, data)

    Notify(locale("current_stocks", result), "success")
    _G.Busy = false
end