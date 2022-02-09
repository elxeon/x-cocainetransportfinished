ESX = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(30)
  end
end)

local isWorking = false
local vehicle = nil
local vehicleChoice = nil
local ped = nil
local cooldown = nil
local spawnLocation = nil
local destinationLocation = nil
local vehBlip = nil
local destinationBlip = nil
local spawns = nil
local spawnDriving = false
local player = nil
local isLoggedIn = false
local startEntitySpawned = false
local table = nil
local laptop = nil
local npc = nil
local rank = nil
local copVehicle = nil
local cop = nil
local goFindCar = nil
local goFindParkedCar = nil

local timeout = 0
local level = 1
local tableModel = GetHashKey("prop_table_03b")
local laptopModel = GetHashKey("prop_laptop_01a")
local vehicleHash = GetHashKey("police4")
local pedHash = GetHashKey("s_m_y_cop_01")

RegisterNetEvent('x-cocainetransport:client-receive-rank')
AddEventHandler('x-cocainetransport:client-receive-rank', function(rank_in)
    rank = rank_in
end)

RegisterNetEvent('xeon:Client:OnPlayerLoaded')
AddEventHandler('xeon:Client:OnPlayerLoaded', function()
    TriggerServerEvent("esx_skin:loadPlayerSkin")
    isLoggedIn = true
    player = PlayerPedId()

    if not startEntitySpawned then
        CreateThread(function()
            TriggerServerEvent('x-cocainetransport:GetMetaData')
            Citizen.Wait(100)
            if not showNpc then
                RequestModel(tableModel)
                while not HasModelLoaded(tableModel) do
                    Citizen.Wait(5)
                end

                RequestModel(laptopModel)
                while not HasModelLoaded(laptopModel) do
                    Citizen.Wait(5)
                end


                table = CreateObject(tableModel, npcCoords.x, npcCoords.y, npcCoords.z - 0.99, false, true, false)
                laptop = CreateObject(laptopModel, npcCoords.x, npcCoords.y, npcCoords.z - 0.2, false, true, false)
            
                FreezeEntityPosition(table, true)
                FreezeEntityPosition(laptop, true)
            else
                RequestModel(pedModel)

                while not HasModelLoaded(pedModel) do
                    Citizen.Wait(5)
                end
                
                npc = CreatePed(4, pedModel, npcCoords.x, npcCoords.y, npcCoords.z - 1, npcHeading, false, true)
                FreezeEntityPosition(npc, true)
                SetEntityInvincible(npc, true)
                SetBlockingOfNonTemporaryEvents(npc, true)
                TaskStartScenarioInPlace(npc, "WORLD_HUMAN_DRUG_DEALER", 0, true)
            end
            startEntitySpawned = true
            for i=1, #levelXpGoal, 1 do
                if rank >= levelXpGoal[i] then
                    level = i + 1
                end
            end
        end)
    end
end)

RegisterNetEvent('xeon:Client:OnPlayerUnload')
AddEventHandler('xeon:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

-- Allows the ability to reload this resource live
-- Remove the if for live version
AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Wait(100)
        player = PlayerPedId()
        isLoggedIn = true
    end

    if not startEntitySpawned then
        CreateThread(function()
            TriggerServerEvent('x-cocainetransport:GetMetaData')
            Citizen.Wait(100)
            if not showNpc then
                RequestModel(tableModel)
                while not HasModelLoaded(tableModel) do
                    Citizen.Wait(5)
                end

                RequestModel(laptopModel)
                while not HasModelLoaded(laptopModel) do
                    Citizen.Wait(5)
                end


                table = CreateObject(tableModel, npcCoords.x, npcCoords.y, npcCoords.z - 0.99, false, true, false)
                laptop = CreateObject(laptopModel, npcCoords.x, npcCoords.y, npcCoords.z - 0.2, false, true, false)
            
                FreezeEntityPosition(table, true)
                FreezeEntityPosition(laptop, true)
            else
                RequestModel(pedModel)

                while not HasModelLoaded(pedModel) do
                    Citizen.Wait(5)
                end
                
                npc = CreatePed(4, pedModel, npcCoords.x, npcCoords.y, npcCoords.z - 1, npcHeading, false, true)
                FreezeEntityPosition(npc, true)
                SetEntityInvincible(npc, true)
                SetBlockingOfNonTemporaryEvents(npc, true)
                TaskStartScenarioInPlace(npc, "WORLD_HUMAN_DRUG_DEALER", 0, true)
            end
        end)
    end
end)

RegisterNetEvent("x-cocainetransport:update-cooldown")
AddEventHandler("x-cocainetransport:update-cooldown", function(status)
    cooldown = status
end)

-- Adds a blip
if showblip then
    local blip = AddBlipForCoord(npcCoords.x, npcCoords.y, npcCoords.z)
    SetBlipSprite(blip, 524)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(blipName)
    EndTextCommandSetBlipName(blip)
end

function SpawnCopCar()
    RequestModel(vehicleHash)
    while not HasModelLoaded(vehicleHash) do
        Citizen.Wait(5)
    end

    if spawnDriving then
        copVehicle = CreateVehicle(vehicleHash, drive_spawns[spawnLocation].copx, drive_spawns[spawnLocation].copy, drive_spawns[spawnLocation].copz, drive_spawns[spawnLocation].copHeading, true, true)
    else
        copVehicle = CreateVehicle(vehicleHash, parked_spawns[spawnLocation].copx, parked_spawns[spawnLocation].copy, parked_spawns[spawnLocation].copz, parked_spawns[spawnLocation].copHeading, true, true)
    end

    SetModelAsNoLongerNeeded(vehicleHash)
    cop = CreatePed(4, pedHash, 0, 0, 0, 0, true, true)
    GiveWeaponToPed(cop, "weapon_pistol", 999, false, true)
    SetPedIntoVehicle(cop, copVehicle, -1)
end

function carWithAi()
    CreateThread(function()
        TriggerServerEvent("xeon_cardelivery:start_cooldown")
        TriggerServerEvent('x-cocainetransport:GetMetaData')
        vehicleChoice = math.random(1, #vehicles[level])
        local model = GetHashKey(vehicles[level][vehicleChoice].model)

        RequestModel(model)
        local modelLoadingTimeout = 5000
        while not HasModelLoaded(model) do
            Citizen.Wait(10)
            modelLoadingTimeout = modelLoadingTimeout - 10
            if modelLoadingTimeout <= 0 then
                TriggerEvent('Notificatie',"error.")
                isWorking = false
                return
            end
        end

        -- Decides if the car should spawn parked or driving (Will be made soon)
        if math.random(0, 10) % 2 == 1 and driveAround then
            spawns = drive_spawns
            spawnDriving = true
        else
            spawns = parked_spawns
        end

        if spawns == nil or #spawns < 1 then
            TriggerEvent('Notificatie',"Geen spawn locatie.")
            isWorking = false
            return
        end

        if #spawns >= 1 then
            spawnLocation = math.random(1, #spawns)
        else
            spawnLocation = #spawns
        end

        vehicle = CreateVehicle(model, spawns[spawnLocation].x, spawns[spawnLocation].y, spawns[spawnLocation].z, spawns[spawnLocation].heading, true, true)
        local netid = NetworkGetNetworkIdFromEntity(vehicle)

        SetVehicleHasBeenOwnedByPlayer(vehicle, true)
        SetNetworkIdCanMigrate(netid, true)

        SetEntityAsMissionEntity(vehicle, true, true)
        SetModelAsNoLongerNeeded(model)

        if spawnDriving then
            ped = CreatePed(4, pedModel, spawns[spawnLocation].x, spawns[spawnLocation].y, spawns[spawnLocation].z, 0, true, true)
            SetPedIntoVehicle(ped, vehicle, -1)
            TaskVehicleDriveWander(driver, veh, 15.0, SetDriveTaskDrivingStyle(ped, 786603))
        end

        vehBlip = AddBlipForEntity(vehicle)

        SetBlipRoute(vehBlip, true)
        SetBlipColour(vehBlip, 5)
        SetBlipRouteColour(vehBlip, 5)

        goFindCar = text_GoFindCar(spawns, level, vehicleChoice, spawnLocation)
        goFindParkedCar = text_GoFindParkedCar(spawns, level, vehicleChoice, spawnLocation)

        if notification and not showAboveHead then
            if spawnDriving then
                TriggerServerEvent('gcPhone:tchat_addMessage', "cocaine", "Er is een cocaine transport gestart vanuit de haven Voertuig: " .. vehicle .. " | Kenteken: ONBEKEND")
            else
                TriggerEvent('Notificatie',"Zoek naar de auto.")
            end
        end

        local zCoord = 0
        player = PlayerPedId()
        while not IsPedInVehicle(player, vehicle, true) and isWorking and IsVehicleDriveable(vehicle, true) and GetVehicleEngineHealth(vehicle) > 50 do
            Citizen.Wait(5)
            if showNpc then
                zCoord = npcCoords.z + 1
            else
                zCoord = npcCoords.z
            end

            if spawnDriving then
                TaskVehicleDriveWander(driver, veh, 15.0, SetDriveTaskDrivingStyle(ped, 786603))
            end
            
            timeout = timeout + 0.5
            if notification and timeout < 200 and showAboveHead then
                if spawnDriving then
                    DrawText3D(npcCoords.x, npcCoords.y, zCoord, goFindCar)
                else
                    DrawText3D(npcCoords.x, npcCoords.y, zCoord, goFindParkedCar)
                end
            end
        end

        SetBlipRoute(vehBlip, false)
        RemoveBlip(vehBlip)
        
        destinationLocation = math.random(1, #destinations)
        destinationBlip = AddBlipForCoord(destinations[destinationLocation].x, destinations[destinationLocation].y, destinations[destinationLocation].z)
        SetBlipRoute(destinationBlip, true)
        SetBlipColour(destinationBlip, 5)
        SetBlipRouteColour(destinationBlip, 5)

        player = PlayerPedId()
        local playerCoords = GetEntityCoords(player)
        local countdown = choiceTimer * 1000

        if IsVehicleDriveable(vehicle, true) and GetVehicleEngineHealth(vehicle) > 50 then
            TriggerEvent('Notificatie',"Hou de auto.")
            if math.random(1, chanceToSpawnCop) == 1 and copSpawn then
                SpawnCopCar()
            else
            end
        end

        while (Vdist2(destinations[destinationLocation].x, destinations[destinationLocation].y, destinations[destinationLocation].z, playerCoords.x, playerCoords.y, playerCoords.z) > 15 or GetEntitySpeed(vehicle) > 0) and IsVehicleDriveable(vehicle, true) and GetVehicleEngineHealth(vehicle) > 50 and isWorking do
            Citizen.Wait(8)
            playerCoords = GetEntityCoords(player)
            TaskVehicleDriveToCoord(cop, copVehicle, playerCoords.x, playerCoords.y, playerCoords.z, 30.0, 1.0, vehicleHash, SetDriveTaskDrivingStyle(ped, 786603), 1.0, true)
            TaskCombatPed(cop, player, 0, 16)

            if abilityToKeepVehicle and countdown > choiceTimer then
                if IsControlPressed( 0, 303) then
                    isWorking = false

                    DeletePed(cop)
                    UpdateRank(rankPenalty)
                    
                    ESX.Game.DeleteVehicle(copVehicle)
                    TriggerEvent('Notificatie',"Hou de auto Job is gecancelled.")
                    TriggerEvent('Notificatie',"Hier is je XP.")
                    Citizen.Wait(300)
                end
                countdown = countdown - 8
            end
        end

        SetBlipRoute(destinationBlip, false)
        RemoveBlip(destinationBlip)

        if isWorking then
            DeletePed(cop)
            ESX.Game.DeleteVehicle(copVehicle)

            if GetVehicleEngineHealth(vehicle) > 50 and IsVehicleDriveable(vehicle, true) then
                local extraPoints = GetVehicleEngineHealth(vehicle) + GetVehicleBodyHealth(vehicle)
                TaskLeaveVehicle(PlayerPedId(), vehicle, 256)
                Citizen.Wait(2000)
                TriggerServerEvent("x-cocainetransport:server:receiveCB", math.floor(math.random(destinations[destinationLocation].from, destinations[destinationLocation].to) + (extraPoints / 2.0) + level * 1000))
                ESX.Game.DeleteVehicle(vehicle)
            else
                TriggerEvent('Notificatie', "Voertuig is verwoest Job is gecanceld")
                TriggerEvent('Notificatie',"Je XP is omlaag gegaan")
                Citizen.Wait(2000)
                ESX.Game.DeleteVehicle(vehicle)
            end
        end
        isWorking = false
    end)
end

CreateThread(function()
    local notifSent = false

    while true do
        Citizen.Wait(10)

        local pCoords = GetEntityCoords(PlayerPedId())

        if Vdist2(npcCoords, pCoords) < startSize and isLoggedIn then
            timeout = 0
            if IsControlPressed(0, 38) then
                if isWorking then
                    isWorking = false
                    TriggerEvent('Notificatie',"Je hebt de job gequit")
                    ESX.Game.DeleteVehicle(vehicle)
                    DeletePed(ped)
                    timeout = 200
                    Citizen.Wait(500)
                else 
                    if not cooldown then
                        isWorking = true
                        TriggerEvent('Notificatie',"Job is gestart")
                        carWithAi()
                        Citizen.Wait(500)
                    else
                        TriggerServerEvent("x-cocainetransport:request-cooldown-time")
                        Citizen.Wait(500)
                    end
                end

            else
                if not notifSent then
                    if not isWorking then
                        TriggerEvent('Notificatie',"Je hebt de job gestart")
                    else
                        TriggerEvent('Notificatie',"Je hebt de job gequit")
                    end
                    notifSent = true
                end
            end
        else
            notifSent = false
        end
    end
end)

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end
