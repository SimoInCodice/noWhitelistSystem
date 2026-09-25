
local ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    ESX.PlayerLoaded = true
    -- OnPlayerLoaded()
end)

RegisterNetEvent('esx:onPlayerLogout', function()
    ESX.PlayerLoaded = false
    OnPlayerUnload()
end)

function hasPlyLoaded()
    return ESX.PlayerLoaded
end

function hasItem(item)
    if not ox_inv then return 0 end
    local count = exports.ox_inventory:Search('count', item)
    return count and count > 0
end

function DoNotification(text, nType)
    ESX.ShowNotification(text, nType)
end

function handleVehicleKeys(veh)
    -- ?
end

local DropOffZone, activeTrailer, pickupZone, PICKUP_BLIP, DELIVERY_BLIP
local activeRoute = {}
local droppingOff = false
local delay = false

local function targetLocalEntity(entity, options, distance)
    if GetResourceState('ox_target') == 'started' then
        for _, option in ipairs(options) do
            option.distance = distance
            option.onSelect = option.action
            option.action = nil
        end
        exports.ox_target:addLocalEntity(entity, options)
    else
        exports['qb-target']:AddTargetEntity(entity, {
            options = options,
            distance = distance
        })
    end
end

local function cleanupShit()
    if DropOffZone then DropOffZone:remove() DropOffZone = nil end
    if pickupZone then pickupZone:remove() pickupZone = nil end
    if DoesBlipExist(PICKUP_BLIP) then RemoveBlip(PICKUP_BLIP) end
    if DoesBlipExist(DELIVERY_BLIP) then RemoveBlip(DELIVERY_BLIP) end

    activeTrailer, PICKUP_BLIP, DELIVERY_BLIP = nil
    table.wipe(activeRoute)
    delay = false
    droppingOff = false
end

local function getStreetandZone(coords)
    local currentStreetHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
    return currentStreetName
end

local function createRouteBlip(coords, label)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 479)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, 3)
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 3)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(label)
    EndTextCommandSetBlipName(blip)
    return blip
end

local function viewRoutes()
    local context = {}

    local routes = lib.callback.await('randol_trucking:server:getRoutes', false)
    if not next(routes) then
        return --DoNotification('You do not have any routes currently.', 'error')
    end

    for index, data in pairs(routes) do
        local isDisabled = activeRoute.index == index
        local info = ('Route: %s \nPayment: $%s'):format(getStreetandZone(data.deliver.xyz), data.payment)
        context[#context + 1] = {
            title = ('%s'):format(getStreetandZone(data.pickup.xyz)),
            description = info,
            icon = 'fa-solid fa-location-dot',
            disabled = isDisabled,
            onSelect = function()
                local choice = lib.callback.await('randol_trucking:server:chooseRoute', false, index)
                if choice and type(choice) == 'table' then
                    activeRoute = choice
                    activeRoute.index = index
                    SetRoute()
                end
            end,
        }
    end

    lib.registerContext({ id = 'view_work_routes', title = 'Work Routes', options = context })
    lib.showContext('view_work_routes')
end

local function nearZone(point)
    DrawMarker(1, point.coords.x, point.coords.y, point.coords.z - 1, 0, 0, 0, 0, 0, 0, 6.0, 6.0, 1.5, 79, 194, 247, 165, 0, 0, 0,0)
    
    if point.isClosest and point.currentDistance <= 4 then
        if not showText then
            showText = true
            lib.showTextUI('**E** - Deliver Trailer', {position = 'left-center'})
        end
        if next(activeRoute) and cache.vehicle and IsEntityAttachedToEntity(cache.vehicle, activeTrailer) then
            if IsControlJustPressed(0, 38) and not droppingOff then
                droppingOff = true
                FreezeEntityPosition(cache.vehicle, true)
                lib.hideTextUI()
                if lib.progressCircle({
                    duration = 5000,
                    position = 'bottom',
                    label = 'Dropping trailer..',
                    useWhileDead = false,
                    canCancel = false,
                    disable = { move = true, car = true, mouse = false, combat = true, },
                }) then
                    DetachEntity(activeTrailer, true, true)
                    NetworkFadeOutEntity(activeTrailer, 0, 1)
                    Wait(500)
                    lib.callback.await('randol_trucking:server:updateRoute', false, NetworkGetNetworkIdFromEntity(activeTrailer), activeRoute)
                    FreezeEntityPosition(cache.vehicle, false)
                    cleanupShit()
                    afterDelivery()
                end
            end
        end
    elseif showText then
        showText = false
        lib.hideTextUI()
    end
end

local function createDropoff()
    RemoveBlip(PICKUP_BLIP)
    pickupZone:remove()
    DropOffZone = lib.points.new({ coords = vec3(activeRoute.deliver.x, activeRoute.deliver.y, activeRoute.deliver.z), distance = 20, nearby = nearZone })
    DELIVERY_BLIP = createRouteBlip(activeRoute.deliver.xyz, 'Punto di consegna')
    SetNewWaypoint(activeRoute.deliver.x, activeRoute.deliver.y)
    DoNotification('Il tuo itinerario di consegna è stato contrassegnato.', 'success')
    Wait(1000)
    delay = false
end

function SetRoute()
    PICKUP_BLIP = createRouteBlip(activeRoute.pickup.xyz, 'Punto di recupero')
    DoNotification('Dirigiti al punto di raccolta e ritira il tuo rimorchio.')
    pickupZone = lib.points.new({ 
        coords = vec3(activeRoute.pickup.x, activeRoute.pickup.y, activeRoute.pickup.z), 
        distance = 70, 
        onEnter = function()
            if not activeTrailer then
                local success, netid = lib.callback.await('randol_trucking:server:spawnTrailer', false)
                if success and netid then
                    activeTrailer = lib.waitFor(function()
                        if NetworkDoesEntityExistWithNetworkId(netid) then
                            return NetToVeh(netid)
                        end
                    end, 'Could not load entity in time.', 3000)
                end
            end
        end,
        nearby = function()
            DrawMarker(1, activeRoute.pickup.x, activeRoute.pickup.y, activeRoute.pickup.z - 1, 0, 0, 0, 0, 0, 0, 6.0, 6.0, 1.5, 79, 194, 247, 165, 0, 0, 0,0)
            
            if cache.vehicle and IsEntityAttachedToEntity(cache.vehicle, activeTrailer) and not delay then
                delay = true
                createDropoff()
            end
        end,
    })
end



RegisterNetEvent('randol_trucking:client:clearRoutes', function()
    if GetInvokingResource() then return end
    cleanupShit()
end)

RegisterNetEvent('randol_trucking:server:spawnTruck', function(netid)
    if GetInvokingResource() or not netid then return end
    local MY_VEH = lib.waitFor(function()
        if NetworkDoesEntityExistWithNetworkId(netid) then
            return NetToVeh(netid)
        end
    end, 'Could not load entity in time.', 3000)
    
    handleVehicleKeys(MY_VEH)
    if CFG_Camionista.Fuel.enable then
        exports[CFG_Camionista.Fuel.script]:SetFuel(MY_VEH, 100.0)
    else
        Entity(MY_VEH).state.fuel = 100
    end
end)


AddEventHandler('onResourceStop', function(resourceName) 
    if GetCurrentResourceName() == resourceName and hasPlyLoaded() then
        OnPlayerUnload()
    end 
end)

function OnPlayerUnload()
    if truckingPedZone then truckingPedZone:remove() truckingPedZone = nil end
    cleanupShit()
end

RegisterNetEvent('randol_trucking:client:startAutoRoute', function(route)
    activeRoute = route
    SetRoute()
end)

-- Dopo la consegna
function afterDelivery()
    lib.registerContext({
        id = 'continue_work_menu',
        title = 'Continua a lavorare?',
        options = {
            {
                title = 'Sì, voglio un altro lavoro',
                description = 'Continua a trasportare merci.',
                icon = 'fa-solid fa-truck',
                onSelect = function()
                    TriggerServerEvent('randol_trucking:server:giveNewRoute')
                    
                end,
            },
            {
                title = 'No, termina il turno',
                description = 'Finisci di lavorare.',
                icon = 'fa-solid fa-handshake',
                onSelect = function()
                    lib.callback.await('randol_trucking:server:clockOut', false)
                end,
            }
        }
    })
    lib.showContext('continue_work_menu')
end

RegisterCommand('lavoro', function()
TriggerServerEvent('camionista:inizialavoro')
end)