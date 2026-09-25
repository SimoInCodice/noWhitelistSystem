RegisterServerEvent('lavavetri:paga', function(data)
    if data == 'dionegraccio' then
        exports.ox_inventory:AddItem(source, 'money', 120)
    end
end)