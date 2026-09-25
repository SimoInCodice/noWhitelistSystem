ESX = exports.es_extended:getSharedObject()
local display = false
local jobselezionato = false
local inservizio = false
local veicolospawnato = false
-------------------------------------------------------------------------------------------------------------------

CreateThread(function()
        local model = GetHashKey(Config.Impiego.PedModel)
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(100)
        end
        local ped = CreatePed(4, model, Config.Impiego.PedPosition, false, false)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)

        exports.ox_target:addLocalEntity(ped, {
            {
                name = 'centroimpiego',
                icon = 'fa-solid fa-suitcase',
                label = 'Gestione Lavori',
                distance = 2.5,
                canInteract = function()
                    if not jobselezionato and not inservizio then return true else return false end
                end,
                onSelect = function(data)
                    OpenJobCenter()
                end,
            },
            {
                name = 'centroimpiego',
                icon = 'fa-solid fa-shirt',
                label = 'Indossa abiti da lavoro',
                distance = 2.5,
                canInteract = function()
                    if jobselezionato and not inservizio then return true else return false end
                end,
                onSelect = function(data)
                    IndossaAbitiLavoro(jobselezionato)
                    inservizio = true
                end,
            },
            {
                name = 'centroimpiego',
                icon = 'fa-solid fa-shirt',
                label = 'Esci dal servizio',
                distance = 2.5,
                canInteract = function()
                    if inservizio then return true else return false end
                end,
                onSelect = function(data)
                    RimuoviLavoroSelezionato()
                end,
            }
        })
end)




function RimuoviLavoroSelezionato()
    
    if lib.progressBar({
        duration = 3000,
        label = 'Rimuovendo i vestiti da lavoro...',
        useWhileDead = false,
        allowCuffed = false,
        canCancel = false,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
            dict = 'clothingshirt',
            clip = 'try_shirt_positive_d'
        },
    }) then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            exports['fivem-appearance']:setPlayerAppearance(skin)
            TriggerEvent('esx:restoreLoadout')
        end)
    end
    TriggerEvent('jobs_nowl:jobselezionato', jobselezionato, false)
    jobselezionato = false
    inservizio = false
end

RegisterNetEvent('jobs_nowl:jobselezionato', function(job, bool)
    if job == 'lavavetri' then 
        jobselezionato = 'lavavetri'
        TriggerEvent('lavavetri:toggle', bool)
    elseif job == 'netturbino' then 
        jobselezionato = 'netturbino'
        TriggerEvent('netturbino:toggle', bool)
    elseif job == 'taxi' then 
        jobselezionato = 'taxi'
        TriggerEvent('taxi:toggle', bool)
    elseif job == 'camionista' then 
        jobselezionato = 'camionista'
        if not bool then
            lib.callback.await('randol_trucking:server:clockOut', false)
        end
    end
    
end)


















-------------------------------------------------------------------------------------------------------------------
--                                                NUI                                                            --
-------------------------------------------------------------------------------------------------------------------


function OpenJobCenter()
    TriggerEvent('aadk93_:jobcenter:sendJobsToUI')
    display = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "open_jobcenter",
        show = true
    })
end

function CloseJobCenter()
    display = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "close_jobcenter"
    })
end

RegisterNUICallback('close', function(data, cb)
    CloseJobCenter()
    cb('ok')
end)

RegisterNUICallback('select_job', function(data, cb)
    local jobId = data.job
    if jobId == nil then ESX.ShowNotification('Errore: ID lavoro non valido (nil)') cb('error') return end
    if jobId == "" then ESX.ShowNotification('Errore: ID lavoro non valido (vuoto)') cb('error') return end
    
    CloseJobCenter()
    Citizen.Wait(100)
    TriggerEvent('jobs_nowl:jobselezionato', data.job, true)
    ESX.ShowNotification('Hai scelto il lavoro: ' .. GetJobLabel(jobId)..', ora puoi vestirti e andare a lavorare!', 'CENTRO IMPIEGHI', 4500)
    cb('ok')
end)

function GetJobLabel(jobId)
    for _, job in ipairs(Config.Jobs) do
        if job.id == jobId then
            return job.label
        end
    end
    return "Lavoro"
end



RegisterNetEvent('aadk93_:jobcenter:sendJobsToUI')
AddEventHandler('aadk93_:jobcenter:sendJobsToUI', function()
    local jobsData = {}
    
    for _, job in ipairs(Config.Jobs) do
        table.insert(jobsData, {
            id = job.id,
            label = job.label,
            icon = job.icon,
            image = job.image,
            description = job.description,
            salary = job.salary,
            type = job.type,
            difficulty = job.difficulty
        })
    end
    
    SendNUIMessage({
        type = "update_jobs",
        jobs = jobsData,
        hideUI = true
    })
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Citizen.Wait(1000)
        TriggerEvent('aadk93_:jobcenter:sendJobsToUI')
    end
end)

AddEventHandler('esx:playerLoaded', function()
    TriggerEvent('aadk93_:jobcenter:sendJobsToUI')
end) 


-- FUNZIONI


function IndossaAbitiLavoro(lavoro)
    if lib.progressBar({
        duration = 3000,
        label = 'Indossando i vestiti da lavoro...',
        useWhileDead = false,
        allowCuffed = false,
        canCancel = false,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
            dict = 'clothingshirt',
            clip = 'try_shirt_positive_d'
        },
    }) then
        SetClothes(lavoro)
        ESX.ShowNotification('Abiti indossati, ora prendi il veicolo!', 'CENTRO IMPIEGHI', 3500)
        TriggerEvent('gridsystem:registerMarker', {
            name = 'veicololavoro',
            pos = Config.Impiego.SpawnVeh,
            scale = vector3(2.0,2.0,2.0),
            size = vector3(2.0,2.0,2.0),
            control = 'E',
            type = 36,        
            drawDistance = 20,
            interactDistance = 5,
            msg = 'VEICOLO DA LAVORO',
            color = { r = 255, g = 255, b = 255 },
            action = function()
                if not veicolospawnato then
                    if jobselezionato == 'camionista' then
                        TriggerServerEvent('camionista:inizialavoro')
                    else
                        SpawnVeh()
                    end
                    veicolospawnato = true
                else
                    if IsPedInAnyVehicle(PlayerPedId()) then
                        ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                        ESX.ShowNotification('Veicolo depositato con successo')
                        TriggerEvent('gridsystem:unregisterMarker', 'veicololavoro')
                        veicolospawnato = false
                    else
                        ESX.ShowNotification('Non sei in un veicolo')
                    end
                end
            end,
        })
    end
end

function SpawnVeh()
    if ESX.Game.IsSpawnPointClear(Config.Impiego.SpawnVeh, 3.5) then
        ESX.Game.SpawnVehicle(Config.Impiego.Veicolo[jobselezionato], Config.Impiego.SpawnVeh, Config.Impiego.SpawnVehHeading, function(vehicle)
            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
                SetVehicleModKit(vehicle, 0)
                SetVehicleMod(vehicle, 15, 3, false)
                SetVehicleMod(vehicle, 13, 2, false)
                SetVehicleMod(vehicle, 11, 3, false)
                SetVehicleMod(vehicle, 12, 2, false)
                ToggleVehicleMod(vehicle, 22, true)
                ToggleVehicleMod(vehicle, 18, true)
                SetVehicleNumberPlateText(vehicle, 'NO WL')
                SetVehicleCustomPrimaryColour(vehicle, Config.Impiego.ColoreVeh.x, Config.Impiego.ColoreVeh.y, Config.Impiego.ColoreVeh.z)
                SetVehicleCustomSecondaryColour(vehicle, Config.Impiego.ColoreVeh.x, Config.Impiego.ColoreVeh.y, Config.Impiego.ColoreVeh.z)
        end)
        if Config.Impiego.PuntoWayPoint[jobselezionato] then
            SetNewWaypoint(Config.Impiego.PuntoWayPoint[jobselezionato])
            ESX.ShowNotification('Punto di destinazione impostato, ora dirigiti lì per iniziare a lavorare!', 'CENTRO IMPIEGHI', 5500)
        elseif jobselezionato == 'netturbino' then
            ESX.ShowNotification('Dirigiti verso i punti di ritiro indicati sulla mappa.', 'CENTRO IMPIEGHI', 5500)
        elseif jobselezionato == 'taxi' then
            Wait(500)
            TriggerEvent('taxi:lavoro')
        elseif jobselezionato == 'camionista' then
            Wait(500)
            TriggerServerEvent('camionista:toggle', true)
        end
    else
        lib.notify({
            title = 'Notifica',
            description = 'Punto di spawn occupato',
            type = 'error'
        })
    end
end

function SetClothes(lavoro)
    print(lavoro)
    local playerPed = cache.ped
    local clothes = Config.Vestiti[lavoro]
    local model = exports['fivem-appearance']:getPedModel(playerPed)
    
    if model == 'mp_m_freemode_01' then
        data = clothes.male
    elseif model == 'mp_f_freemode_01' then
        data = clothes.female
    end

    exports['fivem-appearance']:setPedProps(playerPed, {
        {
            component_id = 0,
            texture = data['helmet_2'],
            drawable = data['helmet_1']
        },
    })

    exports['fivem-appearance']:setPedComponents(playerPed, {
        {
            component_id = 1,
            texture = data['mask_2'],
            drawable = data['mask_1']
        },
        {
            component_id = 3,
            texture = 0,
            drawable = data['arms']
        },
        {
            component_id = 8,
            texture = data['tshirt_2'],
            drawable = data['tshirt_1']
        },
        {
            component_id = 11,
            texture = data['torso_2'],
            drawable = data['torso_1']
        },
        {
            component_id = 9,
            texture = data['bproof_2'],
            drawable = data['bproof_1']
        },
        {
            component_id = 10,
            texture = data['decals_2'],
            drawable = data['decals_1']
        },
        {
            component_id = 7,
            texture = data['chain_2'],
            drawable = data['chain_1']
        },
        {
            component_id = 4,
            texture = data['pants_2'],
            drawable = data['pants_1']
        },
        {
            component_id = 6,
            texture = data['shoes_2'],
            drawable = data['shoes_1']
        },
        {
            component_id = 5,
            texture = data['bag_color'],
            drawable = data['bag']
        },
    })
end

