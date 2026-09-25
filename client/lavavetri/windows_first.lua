while not windowsCleaner.loaded do
    Citizen.Wait(0)
end

local canMoveElevator = true

local function onZoneInteract(zone)
    if zone.name == 'windows_1_start' then
        TriggerServerEvent('lilabyte_windowsCleaner:server:startCurrentJob', 'windows_1')
    elseif zone.name == 'cleaningzone_window' then
        TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_MAID_CLEAN', -1, false)
        canMoveElevator = false
        Citizen.Wait(10000)
        ClearPedTasksImmediately(PlayerPedId())
        data = 'dionegraccio'
        TriggerServerEvent('lavavetri:paga', data)
        TriggerServerEvent('lilabyte_windowsCleaner:server:realizeStep', 'windows_1', zone.cleaningpointIndex)
        canMoveElevator = true
    end
end

local function onNextStep(data)
    local nextStep = data.nextStep
    local lastStep = data.lastStep
    if nextStep ~= -1 then
        local cleaningpoint = windowsCleaner.getSpotZone('cleaningzone'..windowsCleaner.windowsCleaningSpots["windows_1"].cleaningZone.sessionIndex.."_window"..tostring(nextStep))
        if cleaningpoint then
            if lastStep ~= -1 then
                windowsCleaner.editSpotZone('cleaningzone'..windowsCleaner.windowsCleaningSpots["windows_1"].cleaningZone.sessionIndex.."_window"..tostring(lastStep), 'isVisible', false)
                -- Notification to go to the next window
            else
                -- Notification to go to the first window
            end
            windowsCleaner.editSpotZone('cleaningzone'..windowsCleaner.windowsCleaningSpots["windows_1"].cleaningZone.sessionIndex.."_window"..tostring(nextStep), 'isVisible', true)
        end
    else
        local cleaningpoint = windowsCleaner.getSpotZone('start')
        if cleaningpoint then
            if lastStep ~= -1 then
                windowsCleaner.editSpotZone('cleaningzone'..windowsCleaner.windowsCleaningSpots["windows_1"].cleaningZone.sessionIndex.."_window"..tostring(lastStep), 'isVisible', false)
            end
            DoScreenFadeOut(200)
            while not IsScreenFadedOut() do
                Citizen.Wait(0)
            end
            TriggerServerEvent('lilabyte_windowsCleaner:server:stopCurrentJob', "windows_1")
            Citizen.Wait(1000)
            DoScreenFadeIn(200)
        end
    end
end

windowsCleaner.createWindowsCleaningSpot('windows_1', 'Windows Cleaner', {
    ['start'] = {
        name = 'windows_1_start',
        isVisible = true,
        coords = vector3(4.4020872116089, -706.12438964844, 44.973045349121),
        faceCamera = true,
        markerType = 0,
        scale = {x = 0.0, y = 0.0, z = 0.0},
        helpText = "INIZIA A LAVORARE"
    },
    ['cleaningzone0'] = {
        coords = vector3(107.86, -734.65, 244.46),
        maxHeight = 244.46,
        minHeight = 118.06,
        heading = 236.31,
        sessionIndex = 0
    },
    ['cleaningzone0_window0'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 0,
        isVisible = false,
        coords = vector3(107.86, -734.65, 239.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone0_window1'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 1,
        isVisible = false,
        coords = vector3(107.86, -734.65, 235.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone0_window2'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 2,
        isVisible = false,
        coords = vector3(107.86, -734.65, 231.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone0_window3'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 3,
        isVisible = false,
        coords = vector3(107.86, -734.65, 227.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone0_window4'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 4,
        isVisible = false,
        coords = vector3(107.86, -734.65, 223.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone0_window5'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 5,
        isVisible = false,
        coords = vector3(107.86, -734.65, 219.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone0_window6'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 6,
        isVisible = false,
        coords = vector3(107.86, -734.65, 215.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone0_window7'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 7,
        isVisible = false,
        coords = vector3(107.86, -734.65, 211.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone0_window8'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 8,
        isVisible = false,
        coords = vector3(107.86, -734.65, 207.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone0_window9'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 9,
        isVisible = false,
        coords = vector3(107.86, -734.65, 203.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone0_window10'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 10,
        isVisible = false,
        coords = vector3(107.86, -734.65, 199.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone0_window11'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 11,
        isVisible = false,
        coords = vector3(107.86, -734.65, 195.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone0_window12'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 12,
        isVisible = false,
        coords = vector3(107.86, -734.65, 191.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone0_window13'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 13,
        isVisible = false,
        coords = vector3(107.86, -734.65, 187.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone0_window14'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 14,
        isVisible = false,
        coords = vector3(107.86, -734.65, 175.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone0_window15'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 15,
        isVisible = false,
        coords = vector3(107.86, -734.65, 171.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone0_window16'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 16,
        isVisible = false,
        coords = vector3(107.86, -734.65, 167.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    -- ZONE 2
    ['cleaningzone1'] = {
        coords = vector3(145.8, -725.41, 247.55),
        maxHeight = 247.55,
        minHeight = 131.63,
        heading = 145.84,
        sessionIndex = 1
    },
    ['cleaningzone1_window0'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 0,
        isVisible = false,
        coords = vector3(145.8, -725.41, 243.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone1_window1'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 1,
        isVisible = false,
        coords = vector3(145.8, -725.41, 239.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone1_window2'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 2,
        isVisible = false,
        coords = vector3(145.8, -725.41, 235.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone1_window3'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 3,
        isVisible = false,
        coords = vector3(145.8, -725.41, 231.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone1_window4'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 4,
        isVisible = false,
        coords = vector3(145.8, -725.41, 227.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone1_window5'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 5,
        isVisible = false,
        coords = vector3(145.8, -725.41, 223.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone1_window6'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 6,
        isVisible = false,
        coords = vector3(145.8, -725.41, 219.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone1_window7'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 7,
        isVisible = false,
        coords = vector3(145.8, -725.41, 215.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone1_window8'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 8,
        isVisible = false,
        coords = vector3(145.8, -725.41, 211.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone1_window9'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 9,
        isVisible = false,
        coords = vector3(145.8, -725.41, 207.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone1_window10'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 10,
        isVisible = false,
        coords = vector3(145.8, -725.41, 203.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone1_window11'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 11,
        isVisible = false,
        coords = vector3(145.8, -725.41, 199.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone1_window12'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 12,
        isVisible = false,
        coords = vector3(145.8, -725.41, 195.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone1_window13'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 13,
        isVisible = false,
        coords = vector3(145.8, -725.41, 191.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone1_window14'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 14,
        isVisible = false,
        coords = vector3(145.8, -725.41, 187.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone1_window15'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 15,
        isVisible = false,
        coords = vector3(145.8, -725.41, 175.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone1_window16'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 16,
        isVisible = false,
        coords = vector3(145.8, -725.41, 171.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    -- ZONE 3
    ['cleaningzone2'] = {
        coords = vector3(137.48, -722.5, 247.55),
        maxHeight = 247.55,
        minHeight = 131.63,
        heading = 145.84,
        sessionIndex = 2
    },
    ['cleaningzone2_window0'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 0,
        isVisible = false,
        coords = vector3(137.48, -722.5, 243.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone2_window1'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 1,
        isVisible = false,
        coords = vector3(137.48, -722.5, 239.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone2_window2'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 2,
        isVisible = false,
        coords = vector3(137.48, -722.5, 235.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone2_window3'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 3,
        isVisible = false,
        coords = vector3(137.48, -722.5, 231.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone2_window4'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 4,
        isVisible = false,
        coords = vector3(137.48, -722.5, 227.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone2_window5'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 5,
        isVisible = false,
        coords = vector3(137.48, -722.5, 223.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone2_window6'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 6,
        isVisible = false,
        coords = vector3(137.48, -722.5, 219.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone2_window7'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 7,
        isVisible = false,
        coords = vector3(137.48, -722.5, 215.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone2_window8'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 8,
        isVisible = false,
        coords = vector3(137.48, -722.5, 211.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone2_window9'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 9,
        isVisible = false,
        coords = vector3(137.48, -722.5, 207.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone2_window10'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 10,
        isVisible = false,
        coords = vector3(137.48, -722.5, 203.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone2_window11'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 11,
        isVisible = false,
        coords = vector3(137.48, -722.5, 199.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone2_window12'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 12,
        isVisible = false,
        coords = vector3(137.48, -722.5, 195.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone2_window13'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 13,
        isVisible = false,
        coords = vector3(137.48, -722.5, 191.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone2_window14'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 14,
        isVisible = false,
        coords = vector3(137.48, -722.5, 187.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone2_window15'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 15,
        isVisible = false,
        coords = vector3(137.48, -722.5, 175.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone2_window16'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 16,
        isVisible = false,
        coords = vector3(137.48, -722.5, 171.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    -- ZONE 4
    ['cleaningzone3'] = {
        coords = vector3(163.98, -764.21, 247.55),
        maxHeight = 247.55,
        minHeight = 131.63,
        heading = 56.0,
        sessionIndex = 3
    },
    ['cleaningzone3_window0'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 0,
        isVisible = false,
        coords = vector3(163.98, -764.21, 243.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone3_window1'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 1,
        isVisible = false,
        coords = vector3(163.98, -764.21, 239.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone3_window2'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 2,
        isVisible = false,
        coords = vector3(163.98, -764.21, 235.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone3_window3'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 3,
        isVisible = false,
        coords = vector3(163.98, -764.21, 231.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone3_window4'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 4,
        isVisible = false,
        coords = vector3(163.98, -764.21, 227.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone3_window5'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 5,
        isVisible = false,
        coords = vector3(163.98, -764.21, 223.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone3_window6'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 6,
        isVisible = false,
        coords = vector3(163.98, -764.21, 219.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone3_window7'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 7,
        isVisible = false,
        coords = vector3(163.98, -764.21, 215.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone3_window8'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 8,
        isVisible = false,
        coords = vector3(163.98, -764.21, 211.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone3_window9'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 9,
        isVisible = false,
        coords = vector3(163.98, -764.21, 207.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone3_window10'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 10,
        isVisible = false,
        coords = vector3(163.98, -764.21, 203.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone3_window11'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 11,
        isVisible = false,
        coords = vector3(163.98, -764.21, 199.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone3_window12'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 12,
        isVisible = false,
        coords = vector3(163.98, -764.21, 195.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone3_window13'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 13,
        isVisible = false,
        coords = vector3(163.98, -764.21, 191.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone3_window14'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 14,
        isVisible = false,
        coords = vector3(163.98, -764.21, 187.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone3_window15'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 15,
        isVisible = false,
        coords = vector3(163.98, -764.21, 175.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
    ['cleaningzone3_window16'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 16,
        isVisible = false,
        coords = vector3(163.98, -764.21, 171.42),
        faceCamera = true,
        helpText = "PULISCI FINESTRA"
    },
}, {
    [0] = {
        ['torso_1'] = 250,
        ['torso_2'] = 1,
        ['tshirt_1'] = 15,
        ['tshirt_2'] = 0,
        ['bproof_1'] = 48,
        ['bproof_2'] = 1,
        ['arms'] = 1,
        ['pants_1'] = 223,
        ['pants_2'] = 1
    },
    [1] = {
        ['torso_1'] = 244,
        ['torso_2'] = 1,
        ['tshirt_1'] = 14,
        ['tshirt_2'] = 0,
        ['bproof_1'] = 44,
        ['bproof_2'] = 1,
        ['arms'] = 1,
        ['pants_1'] = 223,
        ['pants_2'] = 1
    }
}, onZoneInteract, onNextStep)

AddEventHandler('lilabyte_windowsCleaner:startCurrentJobCallback', function(spotName, callback, session)
    if callback == true and string.match(spotName, "windows_1") then
        windowsCleaner.lastJob = windowsCleaner.currentSpot
        windowsCleaner.currentSpot = spotName
        if windowsCleaner.windowsCleaningSpots[spotName].currentBlip then
            RemoveBlip(windowsCleaner.windowsCleaningSpots[spotName].currentBlip)
        end
        windowsCleaner.windowsCleaningSpots[spotName].currentBlip = nil
        windowsCleaner.windowsCleaningSpots[spotName].cleaningZone = windowsCleaner.windowsCleaningSpots[spotName].zones["cleaningzone"..session]
        local cleaningZone = windowsCleaner.windowsCleaningSpots[spotName].cleaningZone
        DoScreenFadeOut(200)
        while not IsScreenFadedOut() do
            Citizen.Wait(0)
        end
        RequestModel('prop_byte_elevator')
        while not HasModelLoaded('prop_byte_elevator') do
            Citizen.Wait(0)
        end
        windowsCleaner.windowsCleaningSpots[spotName].currentElevator = CreateObject(GetHashKey('prop_byte_elevator'), cleaningZone.coords.x, cleaningZone.coords.y, cleaningZone.coords.z, true, true, true)
        FreezeEntityPosition(PlayerPedId(), true)
        SetEntityCollision(PlayerPedId(), false, true)
        SetEntityHeading(PlayerPedId(), cleaningZone.heading)
        SetEntityCoords(PlayerPedId(), cleaningZone.coords.x, cleaningZone.coords.y, cleaningZone.coords.z)
        AttachEntityToEntity(windowsCleaner.windowsCleaningSpots[spotName].currentElevator, PlayerPedId(), GetEntityBoneIndexByName(PlayerPedId(), 'skel_root'), 0.0, 0.0, 0.5, 0.0, 0.0, 270.0, false, false, false, false, true, true)
        DoScreenFadeIn(200)
    end
end)

Citizen.CreateThread(function()
    -- print(injob)
    local Scale = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS");
    while true do
        if injob then
            if (windowsCleaner.currentSpot == "windows_1") then
                if IsPedFalling(PlayerPedId()) then
                    ClearPedTasksImmediately(PlayerPedId())
                    FreezeEntityPosition(PlayerPedId(), true)
                end
                if GetEntityHeading(PlayerPedId()) ~= windowsCleaner.windowsCleaningSpots["windows_1"].cleaningZone.heading then
                    SetEntityHeading(PlayerPedId(), windowsCleaner.windowsCleaningSpots["windows_1"].cleaningZone.heading)
                end
                BeginScaleformMovieMethod(Scale, "CLEAR_ALL");
                EndScaleformMovieMethod();

                BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT");
                ScaleformMovieMethodAddParamInt(3);
                PushScaleformMovieMethodParameterString("~INPUT_MOVE_UP_ONLY~");
                PushScaleformMovieMethodParameterString("VAI SU");
                EndScaleformMovieMethod();

                BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT");
                ScaleformMovieMethodAddParamInt(2);
                PushScaleformMovieMethodParameterString("~INPUT_MOVE_DOWN_ONLY~");
                PushScaleformMovieMethodParameterString("VAI GIU");
                EndScaleformMovieMethod();

                
                BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT");
                ScaleformMovieMethodAddParamInt(1);
                PushScaleformMovieMethodParameterString("~INPUT_FRONTEND_RT~");
                PushScaleformMovieMethodParameterString("ESCI");
                EndScaleformMovieMethod();

                BeginScaleformMovieMethod(Scale, "DRAW_INSTRUCTIONAL_BUTTONS");
                ScaleformMovieMethodAddParamInt(0);
                EndScaleformMovieMethod();

                DrawScaleformMovieFullscreen(Scale, 255, 255, 255, 255, 0);
                local currentPosition = GetEntityCoords(PlayerPedId())
                DisableControlAction(0, 30, true)
                DisableControlAction(0, 31, true)
                DisableControlAction(0, 32, true)
                DisableControlAction(0, 33, true)
                DisableControlAction(0, 34, true)
                DisableControlAction(0, 35, true)
                DisableControlAction(0, 266, true)
                DisableControlAction(0, 267, true)
                DisableControlAction(0, 268, true)
                DisableControlAction(0, 269, true)
                DisableControlAction(0, 44, true)
                DisableControlAction(0, 20, true)
                DisableControlAction(0, 74, true)
                DisableControlAction(0, 14, true)
                DisableControlAction(0, 15, true)
                DisableControlAction(0, 16, true)
                DisableControlAction(0, 17, true)
                DisableControlAction(0, 99, true)
                DisableControlAction(0, 100, true)
                DisableControlAction(0, 261, true)
                DisableControlAction(0, 262, true)
                DisableControlAction(0, 157, true)
                DisableControlAction(0, 158, true)
                DisableControlAction(0, 159, true)
                DisableControlAction(0, 160, true)
                DisableControlAction(0, 161, true)
                DisableControlAction(0, 162, true)
                DisableControlAction(0, 163, true)
                DisableControlAction(0, 164, true)
                DisableControlAction(0, 165, true)
                if IsDisabledControlPressed(0, 32) and canMoveElevator then
                    -- Up
                    local newZ = tonumber((currentPosition.z + 0.0) + 0.07)
                    if newZ <= windowsCleaner.windowsCleaningSpots["windows_1"].cleaningZone.maxHeight then
                        SetEntityCoordsNoOffset(PlayerPedId(), currentPosition.x, currentPosition.y, newZ, true, true, true)
                    end
                elseif IsDisabledControlPressed(0, 33) and canMoveElevator then
                    -- Down
                    local newZ = tonumber((currentPosition.z + 0.0) - 0.07)
                    if newZ >= windowsCleaner.windowsCleaningSpots["windows_1"].cleaningZone.minHeight then
                        SetEntityCoordsNoOffset(PlayerPedId(), currentPosition.x, currentPosition.y, newZ, true, true, true)
                    end
                elseif IsControlJustPressed(0, 208) then
                    -- Exit
                    local cleaningpoint = windowsCleaner.getSpotZone('start')
                    if cleaningpoint then
                        DoScreenFadeOut(200)
                        while not IsScreenFadedOut() do
                            Citizen.Wait(0)
                        end
                        TriggerServerEvent('lilabyte_windowsCleaner:server:stopCurrentJob', "windows_1")
                        Citizen.Wait(1000)
                        DoScreenFadeIn(200)
                    end
                end
            end
            Citizen.Wait(0)
        else
            Citizen.Wait(1000)
        end
    end
end)

AddEventHandler('lilabyte_windowsCleaner:stopCurrentJobCallback', function(spotName, callback)
    if callback == true and string.match(spotName, "windows_1") then
        windowsCleaner.lastJob = windowsCleaner.currentSpot
        windowsCleaner.currentSpot = nil
        windowsCleaner.windowsCleaningSpots[spotName].currentVehicle = nil
        if windowsCleaner.windowsCleaningSpots[spotName].currentBlip then
            RemoveBlip(windowsCleaner.windowsCleaningSpots[spotName].currentBlip)
        end
        windowsCleaner.windowsCleaningSpots[spotName].currentBlip = nil
        local entity = windowsCleaner.windowsCleaningSpots[spotName].currentElevator
        DetachEntity(entity)
        DeleteObject(entity)
        FreezeEntityPosition(PlayerPedId(), false)
        SetEntityCollision(PlayerPedId(), true, true)
        SetEntityCoords(PlayerPedId(), 4.6440291404724, -706.30950927734, 45.97306060791)
        windowsCleaner.windowsCleaningSpots[spotName].currentElevator = nil
        windowsCleaner.windowsCleaningSpots[spotName].cleaningZone = nil
        for index, zone in pairs(windowsCleaner.windowsCleaningSpots[spotName].zones) do
            if not (string.match(index, 'start') or zone.isVisible == "forJob") then
                windowsCleaner.windowsCleaningSpots[spotName].zones[index].isVisible = false
            end
        end
    end
end)