local InServizio = false
RegisterNetEvent('taxi:toggle', function(bool)
    InServizio = bool
end)

RegisterNetEvent('taxi:lavoro', function()
    StartMission()
end)

function v3(coords) return vec3(coords.x, coords.y, coords.z), coords.w end

function GetRandomInt(min, max, exclude)
    for i=1, 1000 do 
        local int = math.random(min, max)
        if exclude == nil or exclude ~= int then 
            return int
        end
    end
end

local blip
local mission

function Destination(text, coords)
    if blip then 
        RemoveBlip(blip)
    end
    if not text then
        return
    end
    blip = CreateBlip({
        Location = coords,
        Label = text,
        ID = 1,
        Display = 4,
        Color = 5,
        Scale = 0.75
    })
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 5)
    return blip
end

function StartMission(lastIndex)
    if not InServizio then
        return ESX.ShowNotification("Non sei in servizio.")
    end
    local cfg = TaxiJob.Missions
    mission = {}
    mission.from = GetRandomInt(1, #cfg.locations, lastIndex)
    mission.to = GetRandomInt(1, #cfg.locations, mission.from)
    mission.model = cfg.models[GetRandomInt(1, #cfg.models)]
    mission.ped = nil
    mission.taxi = GetVehiclePedIsIn(PlayerPedId())
    mission.status = "pickup"
    
    if GetPedInVehicleSeat(mission.taxi, 2) ~= 0 then 
        return ESX.ShowNotification("C'è già una persona dietro, lascia il passeggero prima di iniziare una nuova missione.")
    end
    if GetPedInVehicleSeat(mission.taxi, -1) ~= PlayerPedId() or GetEntityModel(GetVehiclePedIsIn(PlayerPedId())) ~= GetHashKey("taxi") then 
        return ESX.ShowNotification("Non stai guidando un taxi.")
    end
    
    if (mission and mission.status == "pickup") then
        local coords, heading = v3(cfg.locations[mission.from])
        local enteringVehicle = false

        ESX.ShowNotification("Ritira il cliente localizzato sul tuo GPS.")
        Destination("Ritiro Cliente", coords)

        while mission and mission.status == "pickup" do 
            local wait = 1000
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
            local dist = #(coords - pedCoords)
            if (not DoesEntityExist(mission.taxi) or GetEntityHealth(mission.taxi) == 0) then 
                mission.status = "fail"
            end
            if (dist < 60.0) then 
                if not mission.ped then
                    enteringVehicle = false
                    mission.ped = CreateNPC(mission.model, coords.x, coords.y, coords.z, heading, true, true)
                else
                    if IsEntityDead(mission.ped) then 
                        mission.status = "fail"
                    end
                    if (dist < 10.0 and not enteringVehicle) then 
                        enteringVehicle = true
                        TaskEnterVehicle(mission.ped, mission.taxi, -1, 2, 2.0, 1, 0)
                    elseif GetVehiclePedIsIn(mission.ped) == mission.taxi then
                        mission.status = "dropoff"
                    end
                end
            elseif mission.ped then
                DeleteEntity(mission.ped)
                mission.ped = nil
            end
            Wait(wait)
        end
    end
    
    if (mission and mission.status == "dropoff") then
        local coords, heading = v3(cfg.locations[mission.to])
        local exitingVehicle = false

        ESX.ShowNotification("Porta il cliente alla destinazione indicata sul GPS.")
        Destination("Consegna Cliente", coords)

        while mission and mission.status == "dropoff" do 
            local wait = 1000
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
            local dist = #(coords - pedCoords)

            if (not DoesEntityExist(mission.taxi) or GetEntityHealth(mission.taxi) == 0) then 
                mission.status = "fail"
            end
            if (not exitingVehicle and GetVehiclePedIsIn(mission.ped) ~= mission.taxi) or (not DoesEntityExist(mission.ped) or IsEntityDead(mission.ped)) then 
                mission.status = "fail"
            end
            if (dist < 5.0 and not exitingVehicle) then 
                exitingVehicle = true
                TaskLeaveAnyVehicle(mission.ped, 1, 1)
            elseif exitingVehicle and GetVehiclePedIsIn(mission.ped) ~= mission.taxi then
                mission.status = "success"
            end
            Wait(wait)
        end
    end

    Destination()
    
    if (mission and mission.status == "success") then
        for i=-1, 4 do 
            SetVehicleDoorShut(mission.taxi, i, false)
        end
        -- print('paga')
        ESX.TriggerServerCallback("pickle_taxijob:npcMissionComplete", function(result)
            if not result then
                ESX.ShowNotification("Hai fallito la missione.")
            end
        end, mission.from, mission.to)

        -- print('dopo paga')
        local ped = mission.ped
        TaskWanderStandard(ped, 1, 1)
        SetTimeout(5000, function()
            DeleteEntity(ped)
        end)
        
        mission = nil

        local alert = lib.alertDialog({
            header = 'DATORE DI LAVORO',
            content = 'Vuoi continuare questo lavoro?',
            centered = true,
            cancel = true
        })
        if alert == 'confirm' then
            StartMission()
        else
            ESX.ShowNotification('Allora torna al centro impieghi a concludere il lavoro!', 'CENTRO IMPIEGHI', 4500)
        end
    else
        for i=-1, 4 do 
            SetVehicleDoorShut(mission.taxi, i, false)
        end
        ESX.ShowNotification("Hai fallito la missione.")
        mission = nil

        local alert = lib.alertDialog({
            header = 'DATORE DI LAVORO',
            content = 'Vuoi continuare questo lavoro?',
            centered = true,
            cancel = true
        })
        if alert == 'confirm' then
            StartMission()
        else
            ESX.ShowNotification('Allora torna al centro impieghi a concludere il lavoro!', 'CENTRO IMPIEGHI', 4500)
        end
    end
end

function StopMission()
    local _mission = mission
    mission = nil
    if _mission.ped then
        DeleteEntity(_mission.ped)
    end
    Destination()
    ESX.ShowNotification("Missione annullata.")
end


function CreateVeh(modelHash, ...)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do Wait(0) end
    local veh = CreateVehicle(modelHash, ...)
    SetModelAsNoLongerNeeded(modelHash)
    return veh
end

function CreateNPC(modelHash, ...)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do Wait(0) end
    local ped = CreatePed(26, modelHash, ...)
    SetModelAsNoLongerNeeded(modelHash)
    return ped
end

function CreateProp(modelHash, ...)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do Wait(0) end
    local obj = CreateObject(modelHash, ...)
    SetModelAsNoLongerNeeded(modelHash)
    return obj
end

function PlayAnim(ped, dict, ...)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) end
    TaskPlayAnim(ped, dict, ...)
end

function PlayEffect(dict, particleName, entity, off, rot, time, cb)
    CreateThread(function()
        RequestNamedPtfxAsset(dict)
        while not HasNamedPtfxAssetLoaded(dict) do
            Wait(0)
        end
        UseParticleFxAssetNextCall(dict)
        Wait(10)
        local particleHandle = StartParticleFxLoopedOnEntity(particleName, entity, off.x, off.y, off.z, rot.x, rot.y, rot.z, 1.0)
        SetParticleFxLoopedColour(particleHandle, 0, 255, 0 , 0)
        Wait(time)
        StopParticleFxLooped(particleHandle, false)
        cb()
    end)
end

function CreateBlip(data)
    local x,y,z = table.unpack(data.Location)
    local blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, data.ID)
    SetBlipDisplay(blip, data.Display)
    SetBlipScale(blip, data.Scale)
    SetBlipColour(blip, data.Color)
    if (data.Rotation) then 
        SetBlipRotation(blip, math.ceil(data.Rotation))
    end
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(data.Label)
    EndTextCommandSetBlipName(blip)
    return blip
end