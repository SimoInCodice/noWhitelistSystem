local DisableControl = false

Citizen.CreateThread(function()
    while true do
        if DisableControl then
            DisableControlAction(0, 24, true) -- Attack
            DisableControlAction(0, 257, true) -- Attack 2
            DisableControlAction(0, 25, true) -- Aim
            DisableControlAction(0, 263, true) -- Melee Attack 1
            DisableControlAction(0, 21, true) -- Shift
            DisableControlAction(0, 22, true) -- Space
        end
        Wait(0)
    end
end)

InService = false

local Route
local Garage
local IsDutty = false
local BlipForBag
local InDutty
local HashBag = GetHashKey("WEAPON_GARBAGEBAG")
local BagProp
local IsInAction = false
local ClothesChanged = false

Vehicle = nil 

local RewardAmount = Shared.RewardAmount

local function IncreaseReward()
    RewardAmount = RewardAmount + Shared.RewardIncrease
    local azbechistan = 'mangiamerdadown'
    TriggerServerEvent("Garbage:Reward", RewardAmount, true, azbechistan)
end

RegisterNetEvent('netturbino:toggle', function(bool)
    StartInService(bool)
end)

function StartInService(bool)
    InService = bool
    if BlipForBag then
        RemoveBlip(BlipForBag)
    end
    if InService then 
        -- InGarage = true 
    elseif not InService then
        -- InGarage = false
        RewardAmount = Shared.RewardAmount
    end 
end

local function SetBag(entity, Aria)
    SetPedCanSwitchWeapon(entity, Aria)
    if not Aria then
        ESX.Streaming.RequestAnimDict('anim@heists@narcotics@trash', function()
            TaskPlayAnim(PlayerPedId(), 'anim@heists@narcotics@trash", "pickup_45_r', 2.0, 2.0, -1, 48, 0, false, false, false)
        end)
        DisableControl = true
        GiveDelayedWeaponToPed(entity, HashBag, 0, true)

        BagProp = CreateObject(GetHashKey("prop_cs_street_binbag_01"), 0, 0, 0, true, true, true)
        AttachEntityToEntity(BagProp, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.4, 0, 0, 0, 270.0, 60.0, true, true, false, true, 1, true)
        
        RemoveBlip(BlipForBag)
        InDutty = InDutty + 1 >= #Shared.GarbagePos and 1 or InDutty + 1
    else
        if HasPedGotWeapon(entity, HashBag) then
            RemoveWeaponFromPed(entity, HashBag)
            GiveDelayedWeaponToPed(entity, "WEAPON_UNARMED", 0, true)
        end
        Citizen.Wait(300)
        if BlipForBag then
            RemoveBlip(BlipForBag)
        end
    end
    IsDutty = not Aria
end

Citizen.CreateThread(function()
    while true do
        local Wait = 750
        
        if InService then
            Wait = 0
            local pPed, pCoords = GetPlayerPed(-1), GetEntityCoords(GetPlayerPed(-1), false)
            if not InDutty then
                if not Route then
                    Route = {}
                    Garage = {}
                    --ESX.ShowNotification(Shared.Locale.Info)--
                    for i = 0, #Shared.GarbagePos, 25 do
                        if Shared.GarbagePos[i] then
                            Route[i] = CreateBlipGarbage(Shared.GarbagePos[i], 318, Shared.Blip.Colour, Shared.Blip.StringStart, nil, Shared.Blip.Scale)
                        end
                    end
                    -- for i = 0, #Shared.Garage, 1 do
                    --     if Shared.Garage[i] then
                    --         Garage[i] = CreateBlipGarbage(Shared.Garage[i], 357, Shared.Blip.Colour, Shared.Blip.StringGarage, nil, Shared.Blip.Scale)
                    --     end
                    -- end
                else
                    for bag, data in pairs(Route) do
                        if Shared.GarbagePos[bag] and GetDistanceBetweenCoords(pCoords, Shared.GarbagePos[bag], true) < 32 then
                            InDutty = bag
                            for i, blips in pairs(Route) do
                                RemoveBlip(blips)
                            end
                            Route = nil
                        end
                    end
                end
            elseif InDutty then
                local BagPos = Shared.GarbagePos[InDutty]
                if not DoesBlipExist(BlipForBag) then
                    BlipForBag = CreateBlipGarbage(BagPos, 128, Shared.Blip.Colour, Shared.Blip.StringBag, true, Shared.Blip.Scale)
                else
                    if not IsDutty then
                        local dist = GetDistanceBetweenCoords(pCoords, BagPos, true)
                        if dist < 64 then
                            DrawMarker(0, BagPos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.25, 0, 151, 168, 112, 0, 0, 2, 0,0, 0, 0)
                            if dist < 2 and not IsPedInAnyVehicle(pPed) then
                                DrawTopNotification(Shared.Locale.TakeBag)
                                if IsControlJustPressed(1, 51) then
                                    SetBag(pPed, false)
                                    
                                    Citizen.Wait(555)
                                    RequestAnimSet("clipset@move@trash_fast_turn")
                                    SetPedMovementClipset(pPed, "clipset@move@trash_fast_turn", true)
                                end
                            end
                        end
                    else
                        DrawTopNotification(Shared.Locale.DropBag)
                        if IsControlJustPressed(1, 51) and not IsInAction then
                            local vehicle = GetVehInSight()
                            if (GetDistanceBetweenCoords(pCoords, GetEntityCoords(vehicle) - GetEntityForwardVector(vehicle) * 5) < 2 or IsPedInAnyVehicle(pPed)) and GetEntityModel(vehicle) == 1917016601 then
                                IsInAction = true
                                Citizen.CreateThread(function()
                                    SetVehicleDoorOpen(vehicle, 5)
                                    TaskPlayAnim(pPed, 'anim@heists@narcotics@trash', 'throw_b', 1.0, -1.0,-1,2,0,0, 0,0)
                                    Citizen.Wait(1000)
                                    DeleteEntity(BagProp)
                                    ClearPedTasksImmediately(pPed)
                                    ResetPedMovementClipset(pPed)
                                    ResetPedWeaponMovementClipset(pPed)
                                    ResetPedStrafeClipset(pPed)
                                    SetVehicleDoorShut(vehicle, 5)
                                    IncreaseReward()
                                    ClearPedTasksImmediately(pPed)
                                    DeleteObject(BagProp)
                                    
                                    DisableControl = false
                                    SetBag(pPed, true)
                                    IsInAction = false
                                end)
                            end
                        end
                    end
                end
            end
        elseif InDutty or (IsDutty and GetSelectedPedWeapon(pPed) ~= HashBag) or Route then
            IsInAction = false
            if Route then
                for i, blip in pairs(Route) do
                    RemoveBlip(blip)
                end
                Route = nil
            end

            if Garage then
                for i, blip in pairs(Garage) do
                    RemoveBlip(blip)
                end
                Garage = nil
            end
        end
        Citizen.Wait(Wait)
    end
end)


function CreateBlipGarbage(vector3Pos, intSprite, intColor, stringText, boolRoad, floatScale, intDisplay, intAlpha)
	local blip = AddBlipForCoord(vector3Pos.x, vector3Pos.y, vector3Pos.z)
	SetBlipSprite(blip, intSprite)
	SetBlipAsShortRange(blip, true)
	if intColor then 
		SetBlipColour(blip, intColor) 
	end
	if floatScale then 
		SetBlipScale(blip, floatScale) 
	end
	if boolRoad then 
		SetBlipRoute(blip, boolRoad) 
	end
	if intDisplay then 
		SetBlipDisplay(blip, intDisplay) 
	end
	if intAlpha then 
		SetBlipAlpha(blip, intAlpha) 
	end
	if stringText and (not intDisplay or intDisplay ~= 8) then
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(stringText)
		EndTextCommandSetBlipName(blip)
	end
	return blip
end

function GetVehInSight()
	local ent = GetEntInSight(2)
	if ent == 0 then return end
	return ent
end

function GetEntInSight(entityType)
	if entityType and type(entityType) == "string" then entityType = entityType == "VEHICLE" and 2 or entityType == "PED" and 8 end
	local ped = GetPlayerPed(-1)
	local pos = GetEntityCoords(ped) + vector3(.0, .0, -.4)
	local entityWorld = GetOffsetFromEntityInWorldCoords(ped, 0.0, 20.0, 0.0) + vector3(.0, .0, -.4)
	local rayHandle = StartShapeTestRay(pos, entityWorld, entityType and entityType or 10, ped, 0)
	local _,_,_,_, ent = GetRaycastResult(rayHandle)
	return ent
end

function DrawTopNotification(txt, beep)
	SetTextComponentFormat("jamyfafi")
	AddTextComponentString(txt)
	if string.len(txt) > 99 and AddLongString then
		AddLongString(txt)
	end
	DisplayHelpTextFromStringLabel(0, 0, beep, -1)
end