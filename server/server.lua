ESX = nil
local vehicles = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
RegisterServerEvent('renzu_vehicleshop:GetAvailableVehicle')
AddEventHandler('renzu_vehicleshop:GetAvailableVehicle', function(shop)
    local src = source 
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    if Config.Mysql == 'mysql-async' then
        Owned_Vehicle = MySQL.Sync.fetchAll('SELECT * FROM vehicles WHERE shop = @shop', {['shop'] = shop})
        --TriggerClientEvent('table',-1,Owned_Vehicle)
        if #Owned_Vehicle > 0 then
            Owned_Vehicle = Owned_Vehicle
        else
            Owned_Vehicle = VehicleShop[shop].shop
        end
        TriggerClientEvent("renzu_vehicleshop:receive_vehicles", src , Owned_Vehicle)
    else
        exports['ghmattimysql']:execute('SELECT * FROM vehicles WHERE shop = @shop', {['@shop'] = shop}, function(result)
            if #result > 0 then
                Owned_Vehicle = result
            else
                Owned_Vehicle = VehicleShop[shop].shop
            end
            TriggerClientEvent("renzu_vehicleshop:receive_vehicles", src , Owned_Vehicle)
        end)
    end
end)

local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/' -- You will need this for encoding/decoding
-- encoding
function veh(data)
	data = tostring(data)
    return ((data:gsub('.', function(x) 
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

local NumberCharset = {}
for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

-- RegisterCommand('testa', function()
--     MySQL.Async.fetchAll('SELECT * FROM owned_vehicles', {}, function (result)
--         local plate = veh(tonumber(92299))
--         plate = plate:gsub("=", "")
--         print(plate)
--         local total = 8 - plate:len()
--         print(total)
--         if total ~= 0 then
--             plate = veh(tonumber(92299))..GetRandomNumber(total)
--             plate = plate:gsub("=", "")
--         end
--         print(plate,plate:len())
--         cb(plate)
-- 	end)
-- end)

ESX.RegisterServerCallback('renzu_vehicleshop:GenPlate', function (source, cb)
    if Config.Mysql == 'mysql-async' then then
        MySQL.Async.fetchAll('SELECT * FROM owned_vehicles', {}, function (result)
            local plate = veh(tonumber(#result))
            plate = plate:gsub("=", "")
            local total = 8 - plate:len()
            if total ~= 0 then
                plate = veh(tonumber(#result))..GetRandomNumber(total)
                plate = plate:gsub("=", "")
            end
            print(plate,plate:len())
            cb(plate)
        end)
    else
        exports['ghmattimysql']:execute('SELECT * FROM owned_vehicles', {}, function(result)
            local plate = veh(tonumber(#result))
            plate = plate:gsub("=", "")
            local total = 8 - plate:len()
            if total ~= 0 then
                plate = veh(tonumber(#result))..GetRandomNumber(total)
                plate = plate:gsub("=", "")
            end
            print(plate,plate:len())
            cb(plate)
        end)
    end
end)

ESX.RegisterServerCallback('renzu_vehicleshop:buyvehicle', function (source, cb, model, props, payment)
    local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
    local function sqlfunc(sql, query)
        if sql == 'mysql-async' then
            MySQL.Async.fetchAll(query, {
                ['@model'] = model
            }, function (result)
                cb(Buy(result,xPlayer,model, props, payment))
                return result
            end)
        else
            exports['ghmattimysql']:execute(query, {
                ['@model'] = model
            }, function (result)
                cb(Buy(result,xPlayer,model, props, payment))
                return result
            end)
        end
    end
    sqlfunc(Config.Mysql,'SELECT * FROM vehicles WHERE model = @model LIMIT 1')
end)

function Buy(result,xPlayer,model, props, payment)
    fetchdone = false
    bool = false
    if result then
        local model = result[1].model
        local price = result[1].price
        local stock = result[1].stock
        local payment = payment
        if payment == 'cash' then
            money = xPlayer.getMoney() >= tonumber(price)
        else
            money = xPlayer.getAccount('bank').money >= tonumber(price)
        end
        stock = 999
        if stock > 0 then           
            if money then
                if payment == 'cash' then
                    xPlayer.removeMoney(tonumber(price))
                else
                    xPlayer.removeAccountMoney('bank', tonumber(price))
                end
                stock = stock - 1
                local data = json.encode(props)
                if Config.Mysql == 'mysql-async' then
                    MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, `stored`) VALUES (@owner, @plate, @props, @stored)',
                    {
                        ['@owner']   = xPlayer.identifier,
                        ['@plate']   = props.plate,
                        ['@props'] = data,
                        ['@stored'] = 1
                    },
                    function (rowsChanged)
                        MySQL.Sync.execute('UPDATE vehicles SET stock = @stock WHERE model = @model',
                        {
                            ['@stock'] = stock,
                            ['@model'] = model
                        })
                        fetchdone = true
                        bool = true
                    end)
                else
                    exports['ghmattimysql']:execute('INSERT INTO owned_vehicles (owner, plate, vehicle, `stored`) VALUES (@owner, @plate, @props, @stored)', {
                        ['@owner']   = xPlayer.identifier,
                        ['@plate']   = props.plate,
                        ['@props'] = data,
                        ['@stored'] = 1
                    }, function (rowsChanged)
                        exports['ghmattimysql']:execute('UPDATE vehicles SET stock = @stock WHERE model = @model', {
                            ['@stock'] = stock,
                            ['@model'] = model
                        })
                        fetchdone = true
                        bool = true
                    end)
                end
            else
                xPlayer.showNotification('Not Enough Money',1,0,110)
                fetchdone = true
                bool = false
            end
        else
            xPlayer.showNotification('Vehicle Out of stock',1,0,110)
            fetchdone = true
            bool = false
        end
    else
        xPlayer.showNotification('Vehicle does not Exist',1,0,110)
        fetchdone = true
        bool = false
    end
    while not fetchdone do Wait(0) end
    return bool
end