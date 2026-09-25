

injob = false
windowsCleaner = {}
windowsCleaner.lastSpotZone = nil
windowsCleaner.currentSpotZone = nil
windowsCleaner.lastSpot = nil
windowsCleaner.currentSpot = nil
windowsCleaner.windowsCleaningSpots = {}
local hasEnteredMarker = false

RegisterNetEvent('lavavetri:toggle',function(bool)
    injob = bool
    
end)
RegisterCommand('jobna', function()
    injob = true
end)
windowsCleaner.createWindowsCleaningSpot = function(spotName, label, zones, clothes, onZoneInteract, onNextStep)
    for zoneName, zone in pairs(zones) do
        if not zone.scale then zones[zoneName].scale = {} end
        if not zone.color then zones[zoneName].color = {} end
        if not zone.direction then zones[zoneName].direction = {} end
        if not zone.rotation then zones[zoneName].rotation = {} end
    end
    windowsCleaner.windowsCleaningSpots[spotName] = { label = label, zones = zones, clothes = clothes, onZoneInteract = onZoneInteract, onNextStep = onNextStep }
    return true
end

windowsCleaner.getSpotZone = function(zoneName)
    return windowsCleaner.windowsCleaningSpots[windowsCleaner.currentSpot].zones[zoneName]
end

windowsCleaner.editSpotZone = function(zoneName, data, value)
    windowsCleaner.windowsCleaningSpots[windowsCleaner.currentSpot].zones[zoneName][data] = value
    return windowsCleaner.windowsCleaningSpots[windowsCleaner.currentSpot].zones[zoneName]
end

windowsCleaner.nearSpotZones = {}

Citizen.CreateThread(function()
    while true do
        if injob then
            local playerCoords = GetEntityCoords(PlayerPedId())
            local isPedInVehicle = IsPedInAnyVehicle(PlayerPedId())
            windowsCleaner.nearSpotZones = {}

            for name, spot in pairs(windowsCleaner.windowsCleaningSpots) do
                for zoneName, zone in pairs(spot.zones) do
                    zone.spot = spot
                    local distance = #(playerCoords - zone.coords)

                    if distance <= (zone.visibleDistance or 80.0) then
                        if (zone.isVisible == true or (zone.isVisible == "forJob" and windowsCleaner.currentSpot == name)) 
                            and (not zone.mustBeInACar or (zone.mustBeInACar and isPedInVehicle)) 
                            and (not zone.cantBeInACar or (zone.cantBeInACar and not isPedInVehicle)) then
                            windowsCleaner.nearSpotZones[zoneName] = zone
                        end
                    end
                end
            end
            Citizen.Wait(200) -- Aspetta 200ms se è in job
        else
            Citizen.Wait(1000) -- Aspetta 1000ms se non è in job
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        if injob then
            local playerCoords = GetEntityCoords(PlayerPedId())
            local isPedInVehicle = IsPedInAnyVehicle(PlayerPedId())
            windowsCleaner.lastSpotZone = windowsCleaner.currentSpotZone
            windowsCleaner.currentSpotZone = nil
            for zoneName, zone in pairs(windowsCleaner.nearSpotZones) do
                local distance = #(playerCoords - zone.coords)
                DrawMarker(zone.markerType or 30, zone.coords.x, zone.coords.y, zone.coords.z, zone.direction.x or 0.0, zone.direction.y or 0.0, zone.direction.z or 0.0, zone.rotation.x or 0.0, zone.rotation.y or 0.0, zone.rotation.z or 0.0, zone.scale.x or 0.6, zone.scale.y or 0.6, zone.scale.z or 0.6, zone.color.r or 0, zone.color.g or 50, zone.color.b or 150, zone.color.a or 100, zone.bobUpAndDown or false, zone.faceCamera or false, 2, false, false, false, false)
                if distance <= (zone.interactDistance or 1.5) then
                    windowsCleaner.currentSpotZone = zone
                else
                    if windowsCleaner.lastSpotZone and windowsCleaner.lastSpotZone.name == zone.name then
                        windowsCleaner.lastSpotZone = nil
                    end
                end
            end
            if windowsCleaner.currentSpotZone then
                
                    if not hasEnteredMarker then
                        lib.showTextUI(windowsCleaner.currentSpotZone.helpText)
                        hasEnteredMarker = true
                    end  


                if not windowsCleaner.currentSpotZone.disableHelpText then
                    --DisplayHelpText(windowsCleaner.currentSpotZone.helpText or 'Press ~INPUT_CONTEXT~ to~b~interact')
                    if IsControlJustPressed(0, 38) then
                        windowsCleaner.currentSpotZone.spot.onZoneInteract(windowsCleaner.currentSpotZone)
                    end
                end
            else
                
                if hasEnteredMarker then
                    lib.hideTextUI()
                    hasEnteredMarker = false
                end
            end
            Citizen.Wait(0) -- Aspetta 200ms se è in job
        else
            Citizen.Wait(1000) -- Aspetta 1000ms se non è in job
        end
    end
end)

windowsCleaner.loaded = true

function LoadAnim(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end
    return true
end

function DisplayHelpText(str)
    lib.showTextUI(str)
    -- SetTextComponentFormat("STRING")
    -- AddTextComponentString(str)
    -- DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterNetEvent('lilabyte_windowsCleaner:startCurrentJobCallback')
AddEventHandler('lilabyte_windowsCleaner:startCurrentJobCallback', function(spotName, callback)
    if callback == true and not string.match(spotName, "windows") then
        windowsCleaner.lastSpot = windowsCleaner.currentSpot
        windowsCleaner.currentSpot = spotName
        windowsCleaner.setJobOutfit(spotName)
        windowsCleaner.windowsCleaningSpots[spotName].currentVehicle = nil
        if windowsCleaner.windowsCleaningSpots[spotName].currentBlip then
            RemoveBlip(windowsCleaner.windowsCleaningSpots[spotName].currentBlip)
        end
        windowsCleaner.windowsCleaningSpots[spotName].currentBlip = nil
    end
end)

RegisterNetEvent('lilabyte_windowsCleaner:stopCurrentJobCallback')
AddEventHandler('lilabyte_windowsCleaner:stopCurrentJobCallback', function(spotName, callback)
    if callback == true and not string.match(spotName, "windows") then
        windowsCleaner.lastSpot = windowsCleaner.currentSpot
        windowsCleaner.currentSpot = nil
        windowsCleaner.windowsCleaningSpots[spotName].currentVehicle = nil
        if windowsCleaner.windowsCleaningSpots[spotName].currentBlip then
            RemoveBlip(windowsCleaner.windowsCleaningSpots[spotName].currentBlip)
        end
        windowsCleaner.windowsCleaningSpots[spotName].currentBlip = nil
        for index, zone in pairs(windowsCleaner.windowsCleaningSpots[spotName].zones) do
            if not (string.match(index, 'start') or zone.isVisible == "forJob") then
                windowsCleaner.windowsCleaningSpots[spotName].zones[index].isVisible = false
            end
        end
    end
end)

RegisterNetEvent('lilabyte_windowsCleaner:setNextStep')
AddEventHandler('lilabyte_windowsCleaner:setNextStep', function(stepData)
    local job = windowsCleaner.windowsCleaningSpots[windowsCleaner.currentSpot]
    if job then
        job.onNextStep(stepData)
    end
end)