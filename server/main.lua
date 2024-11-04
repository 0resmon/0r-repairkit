CoreName = nil

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

local function RemoveItem(src, item)
    exports[Config.Inventory]:RemoveItem(src, item, 1)
end

local function AddItem(src, item)
    exports[Config.Inventory]:AddItem(src, item, 1)
end

if CoreName == 'qb-core' then
    QBCore.Functions.CreateUseableItem(Config.ItemSettings.Name, function(source, item)
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)

        local jobName = Player.PlayerData.job.name
        local jobGrade = Player.PlayerData.job.grade.level

        if not jobName or not jobGrade or not Config.Job[jobName] or Config.Job[jobName][jobGrade] == nil or not Config.Job[jobName][jobGrade] then
            TriggerClientEvent('QBCore:Notify', src, Locales[Config.Locale].LUA.notAllowed, 'error')
            return
        end

        TriggerClientEvent('0r-repairkit:client:itemUsed', source)
    end)
elseif CoreName == 'qbx_core' then
    QBX:CreateUseableItem(Config.ItemSettings.Name, function(source, item)
        local src = source
        local Player = QBX:GetPlayer(src)

        local jobName = Player.PlayerData.job.name
        local jobGrade = Player.PlayerData.job.grade.level

        if not jobName or not jobGrade or not Config.Job[jobName] or Config.Job[jobName][jobGrade] == nil or not Config.Job[jobName][jobGrade] then
            QBX:Notify(src, Locales[Config.Locale].LUA.notAllowed, 'error')
            return
        end

        TriggerClientEvent('0r-repairkit:client:itemUsed', source)
    end)
elseif CoreName == 'es_extended' then
    ESX.RegisterUsableItem(Config.ItemSettings.Name, function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        local Job = xPlayer.getJob()
        
        local jobName = Job.name
        local jobGrade = Job.grade

        if not jobName or not jobGrade or not Config.Job[jobName] or Config.Job[jobName][jobGrade] == nil or not Config.Job[jobName][jobGrade] then
            xPlayer.showNotification(Locales[Config.Locale].LUA.notAllowed)
            return
        end

        TriggerClientEvent('0r-repairkit:client:itemUsed', source)
    end)
end

RegisterNetEvent('0r-repairkit:server:addItem', function()
    local src = source
    AddItem(src, Config.ItemSettings.Name)
end)

RegisterNetEvent('0r-repairkit:server:RemoveItem', function()
    local src = source
    RemoveItem(src, Config.ItemSettings.Name)
end)