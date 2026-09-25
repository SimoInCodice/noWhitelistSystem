while not windowsCleaner.loaded do
    Citizen.Wait(0)
end

local canMoveElevator = true

local function onZoneInteract(zone)
    if zone.name == 'windows_2_start' then
        TriggerServerEvent('lilabyte_windowsCleaner:server:startCurrentJob', 'windows_2')
    elseif zone.name == 'cleaningzone_window' then
        TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_MAID_CLEAN', -1, false)
        canMoveElevator = false
        Citizen.Wait(10000)
        ClearPedTasksImmediately(PlayerPedId())
        TriggerServerEvent('lilabyte_windowsCleaner:server:realizeStep', 'windows_2', zone.cleaningpointIndex)
        canMoveElevator = true
    end
end

local function onNextStep(data)
    local nextStep = data.nextStep
    local lastStep = data.lastStep
    if nextStep ~= -1 then
        local cleaningpoint = windowsCleaner.getSpotZone('cleaningzone'..windowsCleaner.windowsCleaningSpots["windows_2"].cleaningZone.sessionIndex.."_window"..tostring(nextStep))
        if cleaningpoint then
            if lastStep ~= -1 then
                windowsCleaner.editSpotZone('cleaningzone'..windowsCleaner.windowsCleaningSpots["windows_2"].cleaningZone.sessionIndex.."_window"..tostring(lastStep), 'isVisible', false)
                -- Notification to go to the next window
            else
                -- Notification to go to the first window
            end
            windowsCleaner.editSpotZone('cleaningzone'..windowsCleaner.windowsCleaningSpots["windows_2"].cleaningZone.sessionIndex.."_window"..tostring(nextStep), 'isVisible', true)
        end
    else
        local cleaningpoint = windowsCleaner.getSpotZone('start')
        if cleaningpoint then
            if lastStep ~= -1 then
                windowsCleaner.editSpotZone('cleaningzone'..windowsCleaner.windowsCleaningSpots["windows_2"].cleaningZone.sessionIndex.."_window"..tostring(lastStep), 'isVisible', false)
            end
            DoScreenFadeOut(200)
            while not IsScreenFadedOut() do
                Citizen.Wait(0)
            end
            TriggerServerEvent('lilabyte_windowsCleaner:server:stopCurrentJob', "windows_2")
            Citizen.Wait(1000)
            DoScreenFadeIn(200)
        end
    end
end

windowsCleaner.createWindowsCleaningSpot('windows_2', 'Windows Cleaner', {
    ['start'] = {
        name = 'windows_2_start',
        isVisible = true,
        coords = vector3(4.4020872116089, -706.12438964844, -43.973045349121),
        faceCamera = true,
        helpText = "Premi ~INPUT_CONTEXT~ per iniziare a pulire"
    },
    ['cleaningzone0'] = {
        coords = vector3(3.11, -715.12, 203.03),
        maxHeight = 203.03,
        minHeight = 118.06,
        heading = 12.0,
        sessionIndex = 0
    },
    ['cleaningzone0_window0'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 0,
        isVisible = false,
        coords = vector3(3.11, -715.12, 199.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone0_window1'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 1,
        isVisible = false,
        coords = vector3(3.11, -715.12, 195.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone0_window2'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 2,
        isVisible = false,
        coords = vector3(3.11, -715.12, 191.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone0_window3'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 3,
        isVisible = false,
        coords = vector3(3.11, -715.12, 187.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone0_window4'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 4,
        isVisible = false,
        coords = vector3(3.11, -715.12, 183.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone0_window5'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 5,
        isVisible = false,
        coords = vector3(3.11, -715.12, 179.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone0_window6'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 6,
        isVisible = false,
        coords = vector3(3.11, -715.12, 175.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone0_window7'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 7,
        isVisible = false,
        coords = vector3(3.11, -715.12, 171.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone0_window8'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 8,
        isVisible = false,
        coords = vector3(3.11, -715.12, 167.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone0_window9'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 9,
        isVisible = false,
        coords = vector3(3.11, -715.12, 163.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone0_window10'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 10,
        isVisible = false,
        coords = vector3(3.11, -715.12, 159.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone0_window11'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 11,
        isVisible = false,
        coords = vector3(3.11, -715.12, 155.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone0_window12'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 12,
        isVisible = false,
        coords = vector3(3.11, -715.12, 151.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone0_window13'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 13,
        isVisible = false,
        coords = vector3(3.11, -715.12, 147.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone0_window14'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 14,
        isVisible = false,
        coords = vector3(3.11, -715.12, 143.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone0_window15'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 15,
        isVisible = false,
        coords = vector3(3.11, -715.12, 139.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone0_window16'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 16,
        isVisible = false,
        coords = vector3(3.11, -715.12, 135.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    -- ZONE 2
    ['cleaningzone1'] = {
        coords = vector3(12.64, -710.66, 203.03),
        maxHeight = 203.03,
        minHeight = 118.06,
        heading = 12.0,
        sessionIndex = 1
    },
    ['cleaningzone1_window0'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 0,
        isVisible = false,
        coords = vector3(12.64, -710.66, 199.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone1_window1'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 1,
        isVisible = false,
        coords = vector3(12.64, -710.66, 195.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone1_window2'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 2,
        isVisible = false,
        coords = vector3(12.64, -710.66, 191.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone1_window3'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 3,
        isVisible = false,
        coords = vector3(12.64, -710.66, 187.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone1_window4'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 4,
        isVisible = false,
        coords = vector3(12.64, -710.66, 183.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone1_window5'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 5,
        isVisible = false,
        coords = vector3(12.64, -710.66, 179.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone1_window6'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 6,
        isVisible = false,
        coords = vector3(12.64, -710.66, 175.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone1_window7'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 7,
        isVisible = false,
        coords = vector3(12.64, -710.66, 171.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone1_window8'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 8,
        isVisible = false,
        coords = vector3(12.64, -710.66, 167.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone1_window9'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 9,
        isVisible = false,
        coords = vector3(12.64, -710.66, 163.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone1_window10'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 10,
        isVisible = false,
        coords = vector3(12.64, -710.66, 159.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone1_window11'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 11,
        isVisible = false,
        coords = vector3(12.64, -710.66, 155.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone1_window12'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 12,
        isVisible = false,
        coords = vector3(12.64, -710.66, 151.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone1_window13'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 13,
        isVisible = false,
        coords = vector3(12.64, -710.66, 147.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone1_window14'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 14,
        isVisible = false,
        coords = vector3(12.64, -710.66, 143.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone1_window15'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 15,
        isVisible = false,
        coords = vector3(12.64, -710.66, 139.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone1_window16'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 16,
        isVisible = false,
        coords = vector3(12.64, -710.66, 135.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    -- ZONE 3
    ['cleaningzone2'] = {
        coords = vector3(25.21, -701.16, 203.03),
        maxHeight = 203.03,
        minHeight = 118.06,
        heading = 57.0,
        sessionIndex = 2
    },
    ['cleaningzone2_window0'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 0,
        isVisible = false,
        coords = vector3(25.21, -701.16, 199.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone2_window1'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 1,
        isVisible = false,
        coords = vector3(25.21, -701.16, 195.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone2_window2'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 2,
        isVisible = false,
        coords = vector3(25.21, -701.16, 191.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone2_window3'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 3,
        isVisible = false,
        coords = vector3(25.21, -701.16, 187.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone2_window4'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 4,
        isVisible = false,
        coords = vector3(25.21, -701.16, 183.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone2_window5'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 5,
        isVisible = false,
        coords = vector3(25.21, -701.16, 179.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone2_window6'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 6,
        isVisible = false,
        coords = vector3(25.21, -701.16, 175.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone2_window7'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 7,
        isVisible = false,
        coords = vector3(25.21, -701.16, 171.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone2_window8'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 8,
        isVisible = false,
        coords = vector3(25.21, -701.16, 167.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone2_window9'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 9,
        isVisible = false,
        coords = vector3(25.21, -701.16, 163.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone2_window10'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 10,
        isVisible = false,
        coords = vector3(25.21, -701.16, 159.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone2_window11'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 11,
        isVisible = false,
        coords = vector3(25.21, -701.16, 155.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone2_window12'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 12,
        isVisible = false,
        coords = vector3(25.21, -701.16, 151.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone2_window13'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 13,
        isVisible = false,
        coords = vector3(25.21, -701.16, 147.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone2_window14'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 14,
        isVisible = false,
        coords = vector3(25.21, -701.16, 143.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone2_window15'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 15,
        isVisible = false,
        coords = vector3(25.21, -701.16, 139.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone2_window16'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 16,
        isVisible = false,
        coords = vector3(25.21, -701.16, 135.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    -- ZONE 4
    ['cleaningzone3'] = {
        coords = vector3(30.22, -687.08, 203.03),
        maxHeight = 203.03,
        minHeight = 118.06,
        heading = 57.0,
        sessionIndex = 3
    },
    ['cleaningzone3_window0'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 0,
        isVisible = false,
        coords = vector3(30.22, -687.08, 199.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone3_window1'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 1,
        isVisible = false,
        coords = vector3(30.22, -687.08, 195.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone3_window2'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 2,
        isVisible = false,
        coords = vector3(30.22, -687.08, 191.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone3_window3'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 3,
        isVisible = false,
        coords = vector3(30.22, -687.08, 187.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone3_window4'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 4,
        isVisible = false,
        coords = vector3(30.22, -687.08, 183.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone3_window5'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 5,
        isVisible = false,
        coords = vector3(30.22, -687.08, 179.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone3_window6'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 6,
        isVisible = false,
        coords = vector3(30.22, -687.08, 175.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone3_window7'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 7,
        isVisible = false,
        coords = vector3(30.22, -687.08, 171.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone3_window8'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 8,
        isVisible = false,
        coords = vector3(30.22, -687.08, 167.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone3_window9'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 9,
        isVisible = false,
        coords = vector3(30.22, -687.08, 163.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone3_window10'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 10,
        isVisible = false,
        coords = vector3(30.22, -687.08, 159.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone3_window11'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 11,
        isVisible = false,
        coords = vector3(30.22, -687.08, 155.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone3_window12'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 12,
        isVisible = false,
        coords = vector3(30.22, -687.08, 151.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone3_window13'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 13,
        isVisible = false,
        coords = vector3(30.22, -687.08, 147.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone3_window14'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 14,
        isVisible = false,
        coords = vector3(30.22, -687.08, 143.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone3_window15'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 15,
        isVisible = false,
        coords = vector3(30.22, -687.08, 139.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
    },
    ['cleaningzone3_window16'] = {
        name = 'cleaningzone_window',
        cleaningpointIndex = 16,
        isVisible = false,
        coords = vector3(30.22, -687.08, 135.03),
        faceCamera = true,
        helpText = "Press ~INPUT_CONTEXT~ to ~b~clean the window"
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
    if callback == true and string.match(spotName, "windows_2") then
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
    local Scale = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS");
    while true do
        if injob then 
            if (windowsCleaner.currentSpot == "windows_2") then
                if IsPedFalling(PlayerPedId()) then
                    ClearPedTasksImmediately(PlayerPedId())
                    FreezeEntityPosition(PlayerPedId(), true)
                end
                if GetEntityHeading(PlayerPedId()) ~= windowsCleaner.windowsCleaningSpots["windows_2"].cleaningZone.heading then
                    SetEntityHeading(PlayerPedId(), windowsCleaner.windowsCleaningSpots["windows_2"].cleaningZone.heading)
                end
                BeginScaleformMovieMethod(Scale, "CLEAR_ALL");
                EndScaleformMovieMethod();

                BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT");
                ScaleformMovieMethodAddParamInt(3);
                PushScaleformMovieMethodParameterString("~INPUT_MOVE_UP_ONLY~");
                PushScaleformMovieMethodParameterString("Go up");
                EndScaleformMovieMethod();

                BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT");
                ScaleformMovieMethodAddParamInt(2);
                PushScaleformMovieMethodParameterString("~INPUT_MOVE_DOWN_ONLY~");
                PushScaleformMovieMethodParameterString("Go down");
                EndScaleformMovieMethod();

                
                BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT");
                ScaleformMovieMethodAddParamInt(1);
                PushScaleformMovieMethodParameterString("~INPUT_FRONTEND_RT~");
                PushScaleformMovieMethodParameterString("Exit");
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
                    if newZ <= windowsCleaner.windowsCleaningSpots["windows_2"].cleaningZone.maxHeight then
                        SetEntityCoordsNoOffset(PlayerPedId(), currentPosition.x, currentPosition.y, newZ, true, true, true)
                    end
                elseif IsDisabledControlPressed(0, 33) and canMoveElevator then
                    -- Down
                    local newZ = tonumber((currentPosition.z + 0.0) - 0.07)
                    if newZ >= windowsCleaner.windowsCleaningSpots["windows_2"].cleaningZone.minHeight then
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
                        TriggerServerEvent('lilabyte_windowsCleaner:server:stopCurrentJob', "windows_2")
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
    if callback == true and string.match(spotName, "windows_2") then
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
        SetEntityCoords(PlayerPedId(), 3.62, -707.44, 44.99)
        windowsCleaner.windowsCleaningSpots[spotName].currentElevator = nil
        windowsCleaner.windowsCleaningSpots[spotName].cleaningZone = nil
        for index, zone in pairs(windowsCleaner.windowsCleaningSpots[spotName].zones) do
            if not (string.match(index, 'start') or zone.isVisible == "forJob") then
                windowsCleaner.windowsCleaningSpots[spotName].zones[index].isVisible = false
            end
        end
    end
end)