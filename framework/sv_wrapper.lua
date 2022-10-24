function Initialized()
	if Config.framework == 'ESX' then
		ESX = nil
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		RegisterServerCallBack_ = ESX.RegisterServerCallback
		vehicletable = 'owned_vehicles'
		vehiclemod = 'vehicle'
	elseif Config.framework == 'QBCORE' then
		QBCore = exports['qb-core']:GetCoreObject()
		RegisterServerCallBack_ =  QBCore.Functions.CreateCallback
		vehicletable = 'player_vehicles '
		vehiclemod = 'mods'
		owner = 'license'
		stored = 'state'
		garage_id = 'garage'
		type_ = 'vehicle'
	end
end

function GetPlayerFromId(src)
	self = {}
	self.src = src
	if Config.framework == 'ESX' then
		return ESX.GetPlayerFromId(self.src)
	elseif Config.framework == 'QBCORE' then
		selfcore = {}
		selfcore.data = QBCore.Functions.GetPlayer(self.src)
		if selfcore.data.identifier == nil then
			selfcore.data.identifier = selfcore.data.PlayerData.license
		end
		if selfcore.data.citizenid == nil then
			selfcore.data.citizenid = selfcore.data.PlayerData.citizenid
		end
		if selfcore.data.job == nil then
			selfcore.data.job = selfcore.data.PlayerData.job
		end

		selfcore.data.getMoney = function(value)
			return selfcore.data.PlayerData.money['cash']
		end
		selfcore.data.addMoney = function(value)
				QBCore.Functions.GetPlayer(tonumber(self.src)).Functions.AddMoney('cash',tonumber(value))
			return true
		end
		selfcore.data.removeMoney = function(value)
			QBCore.Functions.GetPlayer(tonumber(self.src)).Functions.RemoveMoney('cash',tonumber(value))
			return true
		end
		selfcore.data.getAccount = function(type)
			if type == 'money' then
				type = 'cash'
			end
			return {money = selfcore.data.PlayerData.money[type]}
		end
		selfcore.data.removeAccountMoney = function(type,val)
			if type == 'money' then
				type = 'cash'
			end
			QBCore.Functions.GetPlayer(tonumber(self.src)).Functions.RemoveMoney(type,tonumber(val))
			return true
		end
		selfcore.data.showNotification = function(msg)
			TriggerEvent('QBCore:Notify',self.src, msg)
			return true
		end
		if selfcore.data.source == nil then
			selfcore.data.source = self.src
		end
		-- we only do wrapper or shortcuts for what we used here.
		-- a lot of qbcore functions and variables need to port , its possible to port all, but we only port what this script needs.
		return selfcore.data
	end
end

function VehicleNames()
	if Config.framework == 'ESX' then
		vehiclesname = CustomsSQL(Config.Mysql,'fetchAll','SELECT * FROM vehicles', {})
	elseif Config.framework == 'QBCORE' then
		vehiclesname = QBCore.Shared.Vehicles
	end
end

function CustomsSQL(plugin,type,query,var)
    if type == 'fetchAll' and plugin == 'mysql-async' then
        local result = MySQL.Sync.fetchAll(query, var)
        return result
    end
    if type == 'execute' and plugin == 'mysql-async' then
        MySQL.Sync.execute(query,var) 
    end
    if type == 'execute' and plugin == 'ghmattisql' then
        exports['ghmattimysql']:execute(query, var)
    end
    if type == 'fetchAll' and plugin == 'ghmattisql' then
        local data = nil
        exports.ghmattimysql:execute(query, var, function(result)
            data = result
        end)
        while data == nil do Wait(0) end
        return data
    end
    if type == 'execute' and plugin == 'oxmysql' then
        exports.oxmysql:execute(query, var)
    end
    if type == 'fetchAll' and plugin == 'oxmysql' then
        local result = exports.oxmysql:fetchSync(query, var)
        return result
    end
end
