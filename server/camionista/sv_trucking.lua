local storedRoutes = {}
local queue = {}
local spawnedTrailers = {}
local handlingPayments = {}


local ESX = exports['es_extended']:getSharedObject()

function GetPlayer(id)
    return ESX.GetPlayerFromId(id)
end

function DoNotification(src, text, nType)
    TriggerClientEvent('esx:showNotification', src, text, nType)
end

function GetPlyIdentifier(xPlayer)
    return xPlayer.identifier
end

function GetSourceFromIdentifier(cid)
    local xPlayer = ESX.GetPlayerFromIdentifier(cid)
    return xPlayer and xPlayer.source or false
end

function GetCharacterName(xPlayer)
    return xPlayer.getName()
end

function AddItem(xPlayer, item, amount)
    if ox_inv then
        exports.ox_inventory:AddItem(xPlayer.source, item, amount)
    end
end

function RemoveItem(xPlayer, item, amount)
    if ox_inv then
        exports.ox_inventory:RemoveItem(xPlayer.source, item, amount)
    end
end

function AddMoney(xPlayer, moneyType, amount)
    local account = moneyType == 'cash' and 'money' or moneyType
    xPlayer.addAccountMoney(account, amount)
end

function itemCount(xPlayer, item)
    if not ox_inv then return 0 end

    local count = exports.ox_inventory:GetItemCount(xPlayer.source, item)
    return count
end

function itemLabel(item)
    return exports.ox_inventory:Items(item).label
end

AddEventHandler('esx:playerLogout', function(playerId)
    OnPlayerUnload(playerId)
end)

AddEventHandler('esx:playerLoaded', function(source)
    OnPlayerLoaded(source)
end)

local function removeFromQueue(cid)
    for i, cids in ipairs(queue) do
        if cids == cid then
            table.remove(queue, i)
            break
        end
    end
end

local function createTruckingVehicle(source, model, warp, coords)
    if not coords then coords = CFG_Camionista.VehicleSpawn end

    -- CreateVehicleServerSetter can be funky and I cba, especially for a temp vehicle. Cry about it. I just need the entity handle.
    local vehicle = CreateVehicle(joaat(model), coords.x, coords.y, coords.z, coords.w, true, true)
    local ped = GetPlayerPed(source)

    while not DoesEntityExist(vehicle) do Wait(0) end 

    if warp then
        while GetVehiclePedIsIn(ped, false) ~= vehicle do
            TaskWarpPedIntoVehicle(ped, vehicle, -1)
            Wait(100)
        end
    end

    return vehicle
end

local function resetEverything()
    local players = GetPlayers()
    if #players > 0 then
        for i = 1, #players do
            local src = tonumber(players[i])
            local player = GetPlayer(src)

            if player then
                if Player(src).state.truckDuty then
                    Player(src).state:set('truckDuty', false, true)
                end
                local cid = GetPlyIdentifier(player)
                if storedRoutes[cid] and storedRoutes[cid].vehicle and DoesEntityExist(storedRoutes[cid].vehicle) then
                    DeleteEntity(storedRoutes[cid].vehicle)
                end
            end

            if spawnedTrailers[src] and DoesEntityExist(spawnedTrailers[src]) then
                DeleteEntity(spawnedTrailers[src])
            end
        end
    end
end

local function generateRoute(cid)
    local data = {}
    data.pickup = SVCFG_Camionista.Pickups[math.random(#SVCFG_Camionista.Pickups)] 
    data.payment = math.random(SVCFG_Camionista.Payment.min, SVCFG_Camionista.Payment.max)
    repeat
        data.deliver = SVCFG_Camionista.Deliveries[math.random(#SVCFG_Camionista.Deliveries)]

        local found = false
        for _, route in ipairs(storedRoutes[cid].routes) do
            if route.deliver == data.deliver then
                found = true
                break
            end
        end

        if not found then break end
    until false

    return data
end

lib.callback.register('randol_trucking:server:clockIn', function(source)
    local src = source
    local player = GetPlayer(src)
    local cid = GetPlyIdentifier(player)

    if storedRoutes[cid] then
        --DoNotification(src, 'You have already clocked in. Check your routes.')
        return false
    end

    queue[#queue+1] = cid
    storedRoutes[cid] = { routes = {}, vehicle = 0, }
    Player(src).state:set('truckDuty', true, true)

    DoNotification(src, 'Hai timbrato il cartellino per il lavoro di autotrasporto. Controlla le notifiche di lavoro o i tuoi percorsi attuali.', 'success', 7000)
    return true
end)

lib.callback.register('randol_trucking:server:clockOut', function(source) 
    local src = source
    local player = GetPlayer(src)
    local cid = GetPlyIdentifier(player)

    local data = storedRoutes[cid]

    AddMoney(player, 'cash', data.currentRoute.payment)
    
    if not storedRoutes[cid] or not Player(src).state.truckDuty then
        --DoNotification(src, 'You are not clocked in to the trucking job.', 'error')
        return false
    end

    local workTruck = storedRoutes[cid].vehicle
    local workTrailer = spawnedTrailers[src]

    --if workTruck and DoesEntityExist(workTruck) then DeleteEntity(workTruck) end
    if workTrailer and DoesEntityExist(workTrailer) then DeleteEntity(workTrailer) end

    removeFromQueue(cid)
    storedRoutes[cid] = nil
    Player(src).state:set('truckDuty', false, true)
    TriggerClientEvent('randol_trucking:client:clearRoutes', src)
    --DoNotification(src, 'You have clocked out and cleared all your routes.', 'success')
    return true
end)


lib.callback.register('randol_trucking:server:spawnTrailer', function(source) 
    local src = source
    local player = GetPlayer(src)
    local cid = GetPlyIdentifier(player)

    if not storedRoutes[cid] or not Player(src).state.truckDuty then return false end

    local model = SVCFG_Camionista.Trailers[math.random(#SVCFG_Camionista.Trailers)]
    local coords = storedRoutes[cid].currentRoute.pickup
    local trailer = createTruckingVehicle(src, model, false, coords)

    spawnedTrailers[src] = trailer
    return true, NetworkGetNetworkIdFromEntity(trailer)
end)

lib.callback.register('randol_trucking:server:chooseRoute', function(source, index) 
    local src = source
    local player = GetPlayer(src)
    local cid = GetPlyIdentifier(player)

    if not storedRoutes[cid] or not Player(src).state.truckDuty then return false end

    if spawnedTrailers[src] or storedRoutes[cid].currentRoute then
        DoNotification(src, 'Hai già un percorso attivo da completare.', 'success')
        return false 
    end

    storedRoutes[cid].currentRoute = storedRoutes[cid].routes[index]
    storedRoutes[cid].currentRoute.index = index

    return storedRoutes[cid].currentRoute
end)

lib.callback.register('randol_trucking:server:getRoutes', function(source) 
    local src = source
    local player = GetPlayer(src)
    local cid = GetPlyIdentifier(player)

    if not storedRoutes[cid] or not Player(src).state.truckDuty then return false end

    return storedRoutes[cid].routes
end)

lib.callback.register('randol_trucking:server:updateRoute', function(source, netid, route)
    if handlingPayments[source] then return false end
    handlingPayments[source] = true
    local src = source
    local player = GetPlayer(src)
    local cid = GetPlyIdentifier(player)
    local pos = GetEntityCoords(GetPlayerPed(src))
    local entity = NetworkGetEntityFromNetworkId(netid)
    local coords = GetEntityCoords(entity)
    local data = storedRoutes[cid]

    if not data or not DoesEntityExist(entity) or #(coords - data.currentRoute.deliver.xyz) > 15.0 or #(pos - data.currentRoute.deliver.xyz) > 15.0 then
        handlingPayments[src] = nil
        return false 
    end
    
    if spawnedTrailers[src] == entity and route.index == data.currentRoute.index then
        local payout = data.currentRoute.payment
        DeleteEntity(entity)
        spawnedTrailers[src] = nil
        data.currentRoute = nil
        table.remove(data.routes, route.index)
        AddMoney(player, 'cash', payout)
        DoNotification(src, ('Hai completato il percorso e hai ricevuto $%s'):format(payout), 'success', 7000)
        SetTimeout(2000, function()
            handlingPayments[src] = nil
        end)
    end
end)

lib.callback.register('randol_trucking:server:abortRoute', function(source, index)
    local src = source
    local player = GetPlayer(src)
    local cid = GetPlyIdentifier(player)

    if not storedRoutes[cid] or not Player(src).state.truckDuty then return false end

    local data = storedRoutes[cid]

    if data.currentRoute and data.currentRoute.index == index then
        if spawnedTrailers[src] and DoesEntityExist(spawnedTrailers[src]) then
            DeleteEntity(spawnedTrailers[src])
            spawnedTrailers[src] = nil
        end
        data.currentRoute = nil
        table.remove(data.routes, index)
        TriggerClientEvent('randol_trucking:client:clearRoutes', src)
        return true
    end

    return false
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    resetEverything()
end)

AddEventHandler('playerDropped', function()
    local src = source
    if Player(src).state.truckDuty then
        Player(src).state:set('truckDuty', false, true)
        if spawnedTrailers[src] and DoesEntityExist(spawnedTrailers[src]) then
            DeleteEntity(spawnedTrailers[src])
        end
    end
end)

function OnPlayerLoaded(source)
    local src = source
    local player = GetPlayer(src)
    local cid = GetPlyIdentifier(player)
    
    if storedRoutes[cid] then
        Player(src).state:set('truckDuty', true, true)
    end
end

function OnPlayerUnload(source)
    local src = source
    if Player(src).state.truckDuty then
        Player(src).state:set('truckDuty', false, true)
        if spawnedTrailers[src] and DoesEntityExist(spawnedTrailers[src]) then
            DeleteEntity(spawnedTrailers[src])
        end
    end
end

local function initQueue()
    if #queue == 0 then return end

    for i = 1, #queue do
        local cid = queue[i]
        local src = GetSourceFromIdentifier(cid)
        local player = GetPlayer(src)
        if player and Player(src).state.truckDuty then
            if #storedRoutes[cid].routes < 5 then
                storedRoutes[cid].routes[#storedRoutes[cid].routes + 1] = generateRoute(cid)
                DoNotification(src, 'A new route has been added to your current routes.')
            end
        end
    end
end

SetInterval(initQueue, SVCFG_Camionista.QueueTimer * 60000)

RegisterNetEvent('camionista:inizialavoro', function()
    local src = source
    local player = GetPlayer(src)
    local cid = GetPlyIdentifier(player)

    -- ClockIn automatico
    if not storedRoutes[cid] then
        queue[#queue+1] = cid
        storedRoutes[cid] = { routes = {}, vehicle = 0 }
        Player(src).state:set('truckDuty', true, true)
    end

    -- Spawn truck
    if not storedRoutes[cid].vehicle or not DoesEntityExist(storedRoutes[cid].vehicle) then
        local model = SVCFG_Camionista.Trucks[math.random(#SVCFG_Camionista.Trucks)]
        local vehicle = createTruckingVehicle(src, model, true)
        storedRoutes[cid].vehicle = vehicle
        TriggerClientEvent('randol_trucking:server:spawnTruck', src, NetworkGetNetworkIdFromEntity(vehicle))
    end

    -- Genera primo route
    if #storedRoutes[cid].routes < 1 then
        storedRoutes[cid].routes[1] = generateRoute(cid)
    end

    -- Auto-seleziona il route
    storedRoutes[cid].currentRoute = storedRoutes[cid].routes[1]
    storedRoutes[cid].currentRoute.index = 1

    -- Avvisa il client di iniziare subito
    TriggerClientEvent('randol_trucking:client:startAutoRoute', src, storedRoutes[cid].currentRoute)
end)


RegisterNetEvent('randol_trucking:server:giveNewRoute', function()
    local src = source
    local player = GetPlayer(src)
    local cid = GetPlyIdentifier(player)
    local data = storedRoutes[cid]

    AddMoney(player, 'cash', data.currentRoute.payment)
    if not storedRoutes[cid] or not Player(src).state.truckDuty then return end

    local newRoute = generateRoute(cid)
    table.insert(storedRoutes[cid].routes, newRoute)

    storedRoutes[cid].currentRoute = newRoute
    storedRoutes[cid].currentRoute.index = #storedRoutes[cid].routes

    TriggerClientEvent('randol_trucking:client:startAutoRoute', src, storedRoutes[cid].currentRoute)
end)
