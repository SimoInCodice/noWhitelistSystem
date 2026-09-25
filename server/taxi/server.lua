
function v3(coords) return vec3(coords.x, coords.y, coords.z), coords.w end

ESX.RegisterServerCallback("pickle_taxijob:npcMissionComplete", function(source, cb, from, to)
    local player = ESX.GetPlayerFromId(source)
    local cfg = TaxiJob.Missions
    local coords = {
        from = v3(cfg.locations[from]),
        to = v3(cfg.locations[to]),
    }
    local dist = #(coords.from - coords.to)
        local amount = math.random(cfg.reward.min, cfg.reward.max)
        local multi = cfg.reward.miles * (dist / 1000)
        amount = math.ceil(amount * multi)
        -- print(source)
        exports.ox_inventory:AddItem(source, cfg.reward.name, amount)
        player.showNotification(source, string.format("Hai completato il percorso e hai ricevuto $%s.", amount))
        cb(true)
end)