local CoreName = nil
local Prop = nil
local Vehicle = nil
local Placed = nil
local Repairing = nil
local RepearingPart = nil
local VehiclePart = nil
local nuiLoaded = false

if GetResourceState('qb-core') == 'started' and Config.Framework == 'qb-core' then
    QBCore = exports['qb-core']:GetCoreObject()
    CoreName = 'qb-core'
elseif GetResourceState('qbx_core') == 'started' and Config.Framework == 'qbx_core' then
    QBX = exports['qbx_core']
    CoreName = 'qbx_core'
elseif GetResourceState('es_extended') == 'started' and Config.Framework == 'es_extended' then
    ESX = exports['es_extended']:getSharedObject()
    CoreName = 'es_extended'
end

if CoreName == nil then
    print('No framework found, please make sure you have one of the supported frameworks installed.')
    return
end

RegisterNetEvent('onResourceStart')
AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        if Config.Interaction == 'ox_target' then
            exports.ox_target:addGlobalVehicle({
                name = 'check_vehicle_status',
                label = Locales[Config.Locale].LUA.checkVehicle,
                icon = 'fas fa-car-burst',
                distance = 5.0,
                bones = 'engine',
                onSelect = function()
                    TriggerEvent('0r-repairkit:client:openDialog')
                end,
                canInteract = function()
                    if Prop ~= nil and Repairing ~= true then
                        return true
                    else
                        return false
                    end
                end,
            })
        elseif Config.Interaction == 'qb-target' then
            exports['qb-target']:AddTargetBone({'engine'}, {
                options = {
                    {
                        label = Locales[Config.Locale].LUA.checkVehicle,
                        icon = 'fas fa-car-burst',
                        action = function(entity)
                            if IsPedAPlayer(entity) then return false end
                            TriggerEvent('0r-repairkit:client:openDialog')
                        end,
                        canInteract = function(entity, distance, data)
                            if Prop ~= nil and Repairing ~= true then
                                return true
                            else
                                return false
                            end
                        end,
                    }
                },
                distance = 2.5,
            })
        end
        
        SendMessage('locales', Locales[Config.Locale].WEB)
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    if Config.Interaction == 'ox_target' then
        exports.ox_target:addGlobalVehicle({
            name = 'check_vehicle_status',
            label = Locales[Config.Locale].LUA.checkVehicle,
            icon = 'fas fa-car-burst',
            distance = 5.0,
            bones = 'engine',
            onSelect = function()
                TriggerEvent('0r-repairkit:client:openDialog')
            end,
            canInteract = function()
                if Prop ~= nil and Repairing ~= true then
                    return true
                else
                    return false
                end
            end,
        })
    elseif Config.Interaction == 'qb-target' then
        exports['qb-target']:AddTargetBone({'engine'}, {
            options = {
                {
                    label = Locales[Config.Locale].LUA.checkVehicle,
                    icon = 'fas fa-car-burst',
                    action = function(entity)
                        if IsPedAPlayer(entity) then return false end
                        TriggerEvent('0r-repairkit:client:openDialog')
                    end,
                    canInteract = function(entity, distance, data)
                        if Prop ~= nil and Repairing ~= true then
                            return true
                        else
                            return false
                        end
                    end,
                }
            },
            distance = 2.5,
        })
    end

    SendMessage('locales', Locales[Config.Locale].WEB)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    if Config.Interaction == 'ox_target' then
        exports.ox_target:addGlobalVehicle({
            name = 'check_vehicle_status',
            label = Locales[Config.Locale].LUA.checkVehicle,
            icon = 'fas fa-car-burst',
            distance = 5.0,
            bones = 'engine',
            onSelect = function()
                TriggerEvent('0r-repairkit:client:openDialog')
            end,
            canInteract = function()
                if Prop ~= nil and Repairing ~= true then
                    return true
                else
                    return false
                end
            end,
        })
    elseif Config.Interaction == 'qb-target' then
        exports['qb-target']:AddTargetBone({'engine'}, {
            options = {
                {
                    label = Locales[Config.Locale].LUA.checkVehicle,
                    icon = 'fas fa-car-burst',
                    action = function(entity)
                        if IsPedAPlayer(entity) then return false end
                        TriggerEvent('0r-repairkit:client:openDialog')
                    end,
                    canInteract = function(entity, distance, data)
                        if Prop ~= nil and Repairing ~= true then
                            return true
                        else
                            return false
                        end
                    end,
                }
            },
            distance = 2.5,
        })
    end

    SendMessage('locales', Locales[Config.Locale].WEB)
end)


RegisterNetEvent('onResourceStop')
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        ClearPedTasks(PlayerPedId())
        if DoesEntityExist(Prop) then
            DeleteEntity(Prop)
        end

        if DoesEntityExist(RepairTool) then
            DeleteEntity(RepairTool)
        end

        if DoesEntityExist(WheelObject) then
            DeleteEntity(WheelObject)
        end

        if GetResourceState('qb-target') == 'started' then
            exports['qb-target']:RemoveGlobalVehicle(Locales[Config.Locale].LUA.checkVehicle)
        elseif GetResourceState('ox_target') == 'started' then
            exports.ox_target:removeGlobalVehicle('check_vehicle_status')
        end
    end
end)

CreateThread(function()
    while not nuiLoaded do
        if NetworkIsSessionStarted() then
            SendNUIMessage({
                action = "check_nui",
            })
        end
        Wait(2000)
    end
end)

local function checkNUI()
    while not nuiLoaded do
        Wait(0)
    end
end

function SendMessage(action, payload)
    checkNUI()
    SendNUIMessage({
        action = action,
        payload = payload
    })
end

local function CreateToolBoxObject()
    RequestAnimDict(Config.Animation.Hold.Toolbox.animDictionary)
    while not HasAnimDictLoaded(Config.Animation.Hold.Toolbox.animDictionary) do
        Citizen.Wait(0)
    end

    TaskPlayAnim(PlayerPedId(), Config.Animation.Hold.Toolbox.animDictionary, Config.Animation.Hold.Toolbox.animName, Config.Animation.Hold.Toolbox.blendInSpeed, Config.Animation.Hold.Toolbox.blendOutSpeed, Config.Animation.Hold.Toolbox.duration, Config.Animation.Hold.Toolbox.flag, Config.Animation.Hold.Toolbox.playbackRate, Config.Animation.Hold.Toolbox.lockX, Config.Animation.Hold.Toolbox.lockY, Config.Animation.Hold.Toolbox.lockZ)
    
    Prop = CreateObject(GetHashKey(Config.Object.Toolbox), 0, 0, 0, true, true, false)
    SetEntityAsMissionEntity(Prop, true, true)
    FreezeEntityPosition(Prop, true)
    FreezeEntityPosition(Prop, true)
    SetEntityInvincible(Prop, true)
    SetEntityCollision(Prop, true, true)

    if DoesEntityExist(Prop) then
        AttachEntityToEntity(Prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), Config.Animation.Hold.Toolbox.xPos, Config.Animation.Hold.Toolbox.yPos, Config.Animation.Hold.Toolbox.zPos, Config.Animation.Hold.Toolbox.xRot, Config.Animation.Hold.Toolbox.yRot, Config.Animation.Hold.Toolbox.zRot, Config.Animation.Hold.Toolbox.p9, Config.Animation.Hold.Toolbox.useSoftPinning, Config.Animation.Hold.Toolbox.collision, Config.Animation.Hold.Toolbox.isPed, Config.Animation.Hold.Toolbox.rotationOrder, Config.Animation.Hold.Toolbox.syncRot)
    end
end

local function DeleteToolBoxObject()
    if DoesEntityExist(Prop) then
        DeleteEntity(Prop)
        Prop = nil
        Placed = nil
        Repairing = false
        if not Config.ItemDelete then
            TriggerServerEvent('0r-repairkit:server:addItem')
        end

        if Config.Interaction == 'ox_target' then
            exports.ox_target:removeModel(Config.Object.Toolbox, 'remove_prop')
        elseif Config.Interaction == 'qb-target' then
            exports['qb-target']:RemoveTargetModel(Config.Object.Toolbox, Locales[Config.Locale].LUA.removeToolbox)
        end

    end
end

local function PlaceToolBoxInFront()
    if DoesEntityExist(Prop) then
        
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)
        local forwardPos = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 1.0, 0.0)

        local groundZ
        local foundGround, zPos = GetGroundZFor_3dCoord(forwardPos.x, forwardPos.y, forwardPos.z, 0)
        
        if foundGround then
            groundZ = zPos
        else
            groundZ = forwardPos.z
        end

        local vehicleDetected = IsAnyVehicleNearPoint(forwardPos.x, forwardPos.y, groundZ, 1.5)
        
        if vehicleDetected then
            if CoreName == 'qb-core' then
                QBCore.Functions.Notify(Locales[Config.Locale].LUA.cantPut, 'error', 2500)
            elseif CoreName == 'qbx_core' then
                QBX:Notify(Locales[Config.Locale].LUA.cantPut, 'error', 2500)
            elseif CoreName == 'es_extended' then
                ESX.ShowNotification(Locales[Config.Locale].LUA.cantPut, 'error', 2500)
            end
            return
        end

        DetachEntity(Prop, true, true)
        
        SetEntityCoords(Prop, forwardPos.x, forwardPos.y, groundZ, false, false, false, true)
        
        local playerHeading = GetEntityHeading(playerPed)
        SetEntityHeading(Prop, playerHeading)

        SetEntityRotation(Prop, 0.0, 0.0, playerHeading, 2, true)

        ClearPedTasksImmediately(playerPed)
        PlaceObjectOnGroundProperly(Prop)
        Placed = true


        if CoreName == 'qb-core' then
            QBCore.Functions.Notify(Locales[Config.Locale].LUA.placedBox, 'success', 5000)
        elseif CoreName == 'qbx_core' then
            QBX:Notify(Locales[Config.Locale].LUA.placedBox, 'success', 5000)
        elseif CoreName == 'es_extended' then
            ESX.ShowNotification(Locales[Config.Locale].LUA.placedBox, 'success', 5000)
        end
        
        if Config.Interaction == 'ox_target' then
            exports.ox_target:addModel(Config.Object.Toolbox, {{
                name = 'remove_prop',
                label = Locales[Config.Locale].LUA.removeToolbox,
                icon = 'fas fa-toolbox',
                distance = 5.0,
                onSelect = function()
                    DeleteToolBoxObject()
                end,
                canInteract = function()
                    if Prop ~= nil then
                        return true
                    else
                        return false
                    end
                end
            }})
        elseif Config.Interaction == 'qb-target' then
            exports['qb-target']:AddTargetModel(Config.Object.Toolbox, {
                options = {
                    {
                        label = Locales[Config.Locale].LUA.removeToolbox,
                        icon = 'fas fa-toolbox',
                        action = function(entity)
                            if IsPedAPlayer(entity) then return false end
                            DeleteToolBoxObject()
                        end,
                        canInteract = function(entity, distance, data)
                            if Prop ~= nil then
                                return true
                            else
                                return false
                            end
                        end,
                    }
                },
                distance = 2.5,
            })
        end
    end
end

local function GetColor(value)
    if value >= 80 then
        return '#40c057'
    elseif value >= 60 then
        return '#fcc419'
    elseif value >= 50 then
        return '#ffc078'
    elseif value >= 20 then
        return 'fd7e14'
    else
        return '#e03131'
    end
end

local function wheelObj()
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)

    RequestAnimDict(Config.Animation.Hold[VehiclePart].animDictionary)
    while not HasAnimDictLoaded(Config.Animation.Hold[VehiclePart].animDictionary) do
        Wait(100)
    end

    TaskPlayAnim(PlayerPedId(), Config.Animation.Hold[VehiclePart].animDictionary, Config.Animation.Hold[VehiclePart].animName, Config.Animation.Hold[VehiclePart].blendInSpeed, Config.Animation.Hold[VehiclePart].blendOutSpeed, Config.Animation.Hold[VehiclePart].duration, Config.Animation.Hold[VehiclePart].flag, Config.Animation.Hold[VehiclePart].playbackRate, Config.Animation.Hold[VehiclePart].lockX, Config.Animation.Hold[VehiclePart].lockY, Config.Animation.Hold[VehiclePart].lockZ)
    
    WheelObject = CreateObject(GetHashKey(Config.Object.Wheels), 0, 0, 0, true, true, false)
    if DoesEntityExist(WheelObject) then
        AttachEntityToEntity(WheelObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), Config.Animation.Hold[VehiclePart].xPos, Config.Animation.Hold[VehiclePart].yPos, Config.Animation.Hold[VehiclePart].zPos, Config.Animation.Hold[VehiclePart].xRot, Config.Animation.Hold[VehiclePart].yRot, Config.Animation.Hold[VehiclePart].zRot, Config.Animation.Hold[VehiclePart].p9, Config.Animation.Hold[VehiclePart].useSoftPinning, Config.Animation.Hold[VehiclePart].collision, Config.Animation.Hold[VehiclePart].isPed, Config.Animation.Hold[VehiclePart].rotationOrder, Config.Animation.Hold[VehiclePart].syncRot)
    end

    exports.ox_target:removeModel(Config.Object.Toolbox, 'collect_wheel')
end

local function RepairVehicle(part)
    local playerPed = PlayerPedId()
    RepearingPart = part

    RequestAnimDict(Config.Animation.Repair[part].animDictionary)
    while not HasAnimDictLoaded(Config.Animation.Repair[part].animDictionary) do
        Wait(100)
    end

    if part == 'wheels' then
        if not WheelObject then
            if CoreName == 'qb-core' then
                QBCore.Functions.Notify(Locales[Config.Locale].LUA.noWheel, 'error', 2500)
            elseif CoreName == 'qbx_core' then
                QBX:Notify(Locales[Config.Locale].LUA.noWheel, 'error', 2500)
            elseif CoreName == 'es_extended' then
                ESX.ShowNotification(Locales[Config.Locale].LUA.noWheel, 'error', 2500)
            end
            return
        else 
            DeleteEntity(WheelObject)
            ClearPedTasks(playerPed)
        end
    end

    SetNuiFocus(true, true)
    SendMessage('progressOpen')

    TaskPlayAnim(playerPed, Config.Animation.Repair[part].animDictionary, Config.Animation.Repair[part].animName, 8.0, -8.0, -1, 1, 0, false, false, false)

    Wait(2000)
    SendMessage('keyOpen', {
        keyType = Config.KeyType,
        needKeyPressSize = Config.Difficulty[part].Number,
        time = Config.Difficulty[part].Time,
    })
end

RegisterCommand('placeToolbox', function()
    if Prop and Placed then return end
    PlaceToolBoxInFront()
end, false)

RegisterKeyMapping('placeToolbox', 'Place Toolbox In Front', 'keyboard', 'E')

RegisterNetEvent('0r-repairkit:client:itemUsed')
AddEventHandler('0r-repairkit:client:itemUsed', function()
    if Prop then
        return
    end


    if IsPedInAnyVehicle(PlayerPedId(), false) then
        if CoreName == 'qb-core' then
            QBCore.Functions.Notify(Locales[Config.Locale].LUA.vehicleInUsed, 'error', 3000)
        elseif CoreName == 'qbx_core' then
            QBX:Notify(Locales[Config.Locale].LUA.vehicleInUsed, 'error', 3000)
        elseif CoreName == 'es_extended' then
            ESX.ShowNotification(Locales[Config.Locale].LUA.vehicleInUsed, 'error', 3000)
        end
        return
    end

    local coords = GetEntityCoords(PlayerPedId())
    local closestVehicle, vehicleCoords = lib.getClosestVehicle(coords, Config.ItemSettings.Distance)

    if vehicleCoords == nil then 
        if CoreName == 'qb-core' then
            QBCore.Functions.Notify(Locales[Config.Locale].LUA.noVehicle, 'error', 2500)
        elseif CoreName == 'qbx_core' then
            QBX:Notify(Locales[Config.Locale].LUA.noVehicle, 'error', 2500)
        elseif CoreName == 'es_extended' then
            ESX.ShowNotification(Locales[Config.Locale].LUA.noVehicle, 'error', 2500)
        end
        return
    end

    Vehicle = closestVehicle

    if CoreName == 'qb-core' then
        local vehicleHealth = GetVehicleEngineHealth(closestVehicle)

        if vehicleHealth < 1000 then
            TriggerServerEvent('0r-repairkit:server:RemoveItem')
            CreateToolBoxObject()
            QBCore.Functions.Notify(Locales[Config.Locale].LUA.pressToPlace, 'primary', 5000)
        else
            QBCore.Functions.Notify(Locales[Config.Locale].LUA.alreadyRepaired, 'error', 2500)
        end
    elseif CoreName == 'qbx_core' then
            local vehicleHealth = GetVehicleEngineHealth(Vehicle)

            if vehicleHealth < 1000 then
                TriggerServerEvent('0r-repairkit:server:RemoveItem')
                CreateToolBoxObject()
                QBX:Notify(Locales[Config.Locale].LUA.pressToPlace, 'primary', 5000)
            else
                QBX:Notify(Locales[Config.Locale].LUA.alreadyRepaired, 'error', 2500)
            end
    elseif CoreName == 'es_extended' then
        local vehicleHealth = GetVehicleEngineHealth(Vehicle)

        if vehicleHealth < 1000 then
            TriggerServerEvent('0r-repairkit:server:RemoveItem')
            CreateToolBoxObject()
            ESX.ShowNotification(Locales[Config.Locale].LUA.pressToPlace, 'primary', 5000)
        else
            ESX.ShowNotification(Locales[Config.Locale].LUA.alreadyRepaired, 'error', 2500)
        end
    end
end)

RegisterNetEvent('0r-repairkit:client:openDialog')
AddEventHandler('0r-repairkit:client:openDialog', function()
    SetVehicleDoorOpen(Vehicle, 4, false, false)

    local engine = GetVehicleEngineHealth(Vehicle) / 10
    local body = GetVehicleBodyHealth(Vehicle) / 10
    local petrolTank = GetVehiclePetrolTankHealth(Vehicle) / 10
    local frontLeftWheel = GetVehicleWheelHealth(Vehicle, 0) / 10
    local frontRightWheel = GetVehicleWheelHealth(Vehicle, 1) / 10
    local backLeftWheel = GetVehicleWheelHealth(Vehicle, 2) / 10
    local backRightWheel = GetVehicleWheelHealth(Vehicle, 3) / 10

    local wheels = (frontLeftWheel + frontRightWheel + backLeftWheel + backRightWheel) / 4

    local data = {
        {
            title = Config.Parts['engine'].label, 
            description = Config.Parts['engine'].description,
            icon = 'fas fa-car',
            iconAnimation = engine >= 90 and nil or 'fade',
            progress = engine,
            colorScheme = GetColor(engine),
            metadata = {
                label = Locales[Config.Locale].LUA.requirements,
                value = Config.Parts['engine'].tool
            },
            onSelect = function()
                TriggerEvent('0r-repairkit:client:reapirPart', 'engine')
            end
        },
        {
            title = Config.Parts['body'].label, 
            description = Config.Parts['body'].description,
            icon = 'fas fa-car',
            iconAnimation = body >= 90 and nil or 'fade',
            progress = body,
            colorScheme = GetColor(body),
            metadata = {
                label = Locales[Config.Locale].LUA.requirements,
                value = Config.Parts['body'].tool
            },
            onSelect = function()
                TriggerEvent('0r-repairkit:client:reapirPart', 'body')
            end
        },
        {
            title = Config.Parts['petrolTank'].label, 
            description = Config.Parts['petrolTank'].description,
            icon = 'fas fa-car',
            iconAnimation = petrolTank >= 90 and nil or 'fade',
            progress = petrolTank,
            colorScheme = GetColor(petrolTank),
            metadata = {
                label = Locales[Config.Locale].LUA.requirements,
                value = Config.Parts['petrolTank'].tool
            },
            onSelect = function()
                TriggerEvent('0r-repairkit:client:reapirPart', 'petrolTank')
            end
        },
        {
            title = Config.Parts['wheels'].label, 
            description = Config.Parts['wheels'].description,
            icon = 'fas fa-car',
            iconAnimation = wheels >= 90 and nil or 'fade',
            progress = wheels,
            colorScheme = GetColor(wheels),
            metadata = {
                label = Locales[Config.Locale].LUA.requirements,
                value = Config.Parts['wheels'].tool
            },
            onSelect = function()
                TriggerEvent('0r-repairkit:client:reapirPart', 'wheels')
            end
        },
    }

    lib.registerContext({
        id = 'check_vehicle_status',
        title = Locales[Config.Locale].LUA.checkVehicle,
        menu = 'check_vehicle_status',
        onExit = function()
            ClearPedTasks(PlayerPedId())
            SetVehicleDoorShut(Vehicle, 4, false)
        end,
        options = data
    })
    
    RequestAnimDict("mini@repair")
    while not HasAnimDictLoaded("mini@repair") do
        Wait(100)
    end

    TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_ped", 8.0, -8.0, -1, 48, 0, false, false, false)
    lib.showContext('check_vehicle_status')
end)

RegisterNetEvent('0r-repairkit:client:reapirPart')
AddEventHandler('0r-repairkit:client:reapirPart', function(part, index)
    if part ~= 'wheels' then
        SetVehicleDoorShut(Vehicle, 4, false)
    end
    if part == 'wheels' then
        if Config.Interaction == 'ox_target' then
            exports.ox_target:addModel(Config.Object.Toolbox, {{
                name = 'collect_wheel',
                label = Locales[Config.Locale].LUA.collectWheelT,
                icon = 'fas fa-toolbox',
                distance = 5.0,
                onSelect = function()
                    wheelObj()
                end,
                canInteract = function()
                    if Prop ~= nil then
                        return true
                    else
                        return false
                    end
                end
            }})
        elseif Config.Interaction == 'qb-target' then
            exports['qb-target']:AddTargetModel(Config.Object.Toolbox, {
                options = {
                    {
                        label = Locales[Config.Locale].LUA.collectWheelT,
                        icon = 'fas fa-toolbox',
                        action = function(entity)
                            if IsPedAPlayer(entity) then return false end
                            wheelObj()
                        end,
                        canInteract = function(entity, distance, data)
                            if Prop ~= nil then
                                return true
                            else
                                return false
                            end
                        end,
                    }
                },
                distance = 2.5,
            })
        end
    end

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local vehicleCoords = GetEntityCoords(Vehicle)
    local distance = #(playerCoords - vehicleCoords)

    if CoreName == 'qb-core' then
        if part == 'body' then
            QBCore.Functions.Notify(Locales[Config.Locale].LUA.cleanBody)
        elseif part == 'wheels' then
            QBCore.Functions.Notify(Locales[Config.Locale].LUA.collectWheel)
        end
    elseif CoreName == 'qbx_core' then
        if part == 'body' then
            QBX:Notify(Locales[Config.Locale].LUA.cleanBody)
        elseif part == 'wheels' then
            QBX:Notify(Locales[Config.Locale].LUA.collectWheel)
        end
    elseif CoreName == 'es_extended' then
        if part == 'body' then
            ESX.ShowNotification(Locales[Config.Locale].LUA.cleanBody)
        elseif part == 'wheels' then
            ESX.ShowNotification(Locales[Config.Locale].LUA.collectWheel)
        end
    end

    Repairing = true
    ClearPedTasks(playerPed)
    local parts = nil

    VehiclePart = part:lower()

    if VehiclePart == 'wheels' then
        parts = Config.Parts[part].bones
    else
        parts = 'engine'
    end

    if Config.Interaction == 'ox_target' then
        exports.ox_target:addLocalEntity(Vehicle, {
            name = 'repair_vehicle',
            label = Locales[Config.Locale].LUA.repairVehicle,
            icon = 'fas fa-car-burst',
            distance = 5.0,
            bones = parts,
            onSelect = function()
                RepairVehicle(part)
            end
        })
    elseif Config.Interaction == 'qb-target' then
        exports['qb-target']:AddTargetEntity(Vehicle, {
            options = {
                {
                    label = Locales[Config.Locale].LUA.repairVehicle,
                    icon = 'fas fa-car-burst',
                    action = function(entity)
                        if IsPedAPlayer(entity) then return false end
                        RepairVehicle(part)
                    end,
                    canInteract = function(entity, distance, data)
                        if Prop ~= nil then
                            return true
                        else
                            return false
                        end
                    end,
                }
            },
            distance = 2.5,
        })
    end
end)

RegisterNUICallback("closeMenu", function()
    SetNuiFocus(false, false)
    ClearPedTasks(PlayerPedId())
    DeleteEntity(RepairTool)
end)

RegisterNUICallback("keySuccess", function()
    SetNuiFocus(false, false)
    ClearPedTasks(PlayerPedId())
    DeleteEntity(RepairTool)

    Repairing = false
    WheelObject = nil

    if Config.Interaction == 'ox_target' then
        exports.ox_target:removeLocalEntity(Vehicle, 'repair_vehicle')
        exports.ox_target:removeModel(Config.Object.Toolbox, 'collect_wheel')
    elseif Config.Interaction == 'qb-target' then
        exports['qb-target']:RemoveTargetEntity(Vehicle, Locales[Config.Locale].LUA.repairVehicle)
        exports['qb-target']:RemoveTargetModel(Config.Object.Toolbox, Locales[Config.Locale].LUA.collectWheelT)
    end

    if CoreName == 'qb-core' then
        QBCore.Functions.Notify(Locales[Config.Locale].LUA.successRepaired, 'success', 5000)
    elseif CoreName == 'qbx_core' then
        QBX:Notify(Locales[Config.Locale].LUA.successRepaired, 'success', 5000)
    elseif CoreName == 'es_extended' then
        ESX.ShowNotification(Locales[Config.Locale].LUA.successRepaired, 'success', 5000)
    end


    if RepearingPart == 'engine' then
        SetVehicleEngineHealth(Vehicle, 1000.0)
    elseif RepearingPart == 'body' then
        SetVehicleFixed(Vehicle)
        SetVehicleBodyHealth(Vehicle, 1000.0)
        SetVehicleDeformationFixed(Vehicle)
        SetVehicleUndriveable(Vehicle, false)
        SetVehicleDirtLevel(Vehicle, 0.0)
    elseif RepearingPart == 'petrolTank' then
        SetVehiclePetrolTankHealth(Vehicle, 1000.0)
    elseif RepearingPart == 'wheels' then
        for i = 0, 7 do
            SetVehicleTyreFixed(Vehicle, i)
            SetVehicleWheelHealth(Vehicle, i, 1000.0)
        end
    end
end)

RegisterNUICallback("keyFailed", function()
    SetNuiFocus(false, false)
    ClearPedTasks(PlayerPedId())
    DeleteEntity(RepairTool)

    Repairing = false
    WheelObject = nil
    exports.ox_target:removeLocalEntity(Vehicle, 'repair_vehicle')

    if CoreName == 'qb-core' then
        QBCore.Functions.Notify(Locales[Config.Locale].LUA.failedRepaired, 'error', 5000)
    elseif CoreName == 'qbx_core' then
        QBX:Notify(Locales[Config.Locale].LUA.failedRepaired, 'error', 5000)
    elseif CoreName == 'es_extended' then
        ESX.ShowNotification(Locales[Config.Locale].LUA.failedRepaired, 'error', 5000)
    end
end)

RegisterNUICallback("nui_loaded", function()
    nuiLoaded = true
end)