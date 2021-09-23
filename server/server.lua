ESX = nil
local vehicles = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand('pdm', function(source,args)
    TriggerClientEvent('renzu_vehicleshop:manage', source)
end, false)

RegisterServerEvent('renzu_vehicleshop:GetAvailableVehicle')
AddEventHandler('renzu_vehicleshop:GetAvailableVehicle', function(shop)
    local src = source 
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    local shop = shop or 'pdm'
    Owned_Vehicle = {}
    if Config.Mysql == 'mysql-async' then
        Owned_Vehicle = MySQL.Sync.fetchAll('SELECT * FROM vehicles WHERE shop = @shop', {['@shop'] = shop})
        --TriggerClientEvent('table',-1,Owned_Vehicle)
        if Owned_Vehicle[1] then
            Owned_Vehicle = Owned_Vehicle
        else
            local shoplist = {}
            for k,v in pairs(VehicleShop[shop].shop) do
                if v.grade ~= nil and v.grade <= xPlayer.job.grade then
                    shoplist[k] = v
                elseif v.grade == nil then
                    shoplist[k] = v
                end
            end
            Owned_Vehicle = shoplist
        end
        TriggerClientEvent("renzu_vehicleshop:receive_vehicles", src , Owned_Vehicle,VehicleShop[shop].type or 'car')
    else
        exports['ghmattimysql']:execute('SELECT * FROM vehicles WHERE shop = @shop', {['@shop'] = shop}, function(result)
            if #result > 0 then
                Owned_Vehicle = result
            else
                local shoplist = {}
                for k,v in pairs(VehicleShop[shop].shop) do
                    if v.grade ~= nil and v.grade <= xPlayer.job.grade then
                        shoplist[k] = v
                    elseif v.grade == nil then
                        shoplist[k] = v
                    end
                end
                Owned_Vehicle = shoplist
            end
            TriggerClientEvent("renzu_vehicleshop:receive_vehicles", src , Owned_Vehicle,VehicleShop[shop].type or 'car')
        end)
    end
end)

local NumberCharset = {}
for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

function Database(query,var,src,type)
    if Config.Mysql == 'mysql-async' and type =='fetch' then
        return MySQL.Sync.fetchAll(query,var)
    elseif Config.Mysql == 'mysql-async' and type == 'execute' then
        MySQL.Async.execute(query,var, function (rowsChanged)
            TriggerClientEvent('sellvehiclecallback',src)
        end)
    else
        local res = nil
        exports['ghmattimysql']:execute(query,var, function (result)
            res = result
            if type == 'execute' then
                TriggerClientEvent('sellvehiclecallback',src)
            end
        end)
        local c = 0
        while res == nil and c < 2000 do Wait(10) c = c + 1 end
        return res
    end
end

function Deleteveh(plate,src)
    local plate = tostring(plate)
    if plate and type(plate) == 'string' then
        Database('DELETE FROM owned_vehicles WHERE plate=@plate', {['@plate'] = plate},src,'execute')
    else
        print('error not string - Delete Vehicle')
    end
end



RegisterServerEvent('renzu_vehicleshop:sellvehicle')
AddEventHandler('renzu_vehicleshop:sellvehicle', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = 1000
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(source))
    local plate = GetVehicleNumberPlateText(vehicle)
    r = Database('SELECT * FROM owned_vehicles WHERE UPPER(plate) = @plate and owner = @owner', {['@plate'] = plate:upper(), ['@owner'] = xPlayer.identifier},xPlayer.source,'fetch')
    if #r > 0 then
        local model = json.decode(r[1].vehicle).model
        if model == GetEntityModel(vehicle) then
            result = Database('SELECT * FROM vehicles', {},xPlayer.source,'fetch')
                if #result > 0 then
                    for k,v in pairs(result) do
                        if model == GetHashKey(v.model) then
                            price = v.price * (Config.RefundPercent * 0.01)
                        end
                    end
                    Deleteveh(plate,xPlayer.source)
                    xPlayer.addMoney(price)
                    xPlayer.showNotification('Vehicle has been Sold for ^g '..price..'',1,0,110)
                end
        else
            print("EXPLOIT")
            xPlayer.showNotification('Are you really sure this is the vehicle?',1,0,110)
        end
    else
        xPlayer.showNotification('You dont owned this vehicle',1,0,110)
        print("not owned")
    end
end)

local Charset = {}
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end
local temp = {}
CreateThread(function()
    Wait(1000)
    if Config.Mysql == 'mysql-async' then
        local vehicles = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles ', {})
        for k,v in pairs(vehicles) do
            if v.plate ~= nil then
                temp[v.plate] = v
            end
        end
    else
        exports['ghmattimysql']:execute('SELECT * FROM owned_vehicles', {}, function(result)
            for k,v in pairs(result) do
                if v.plate ~= nil then
                    temp[v.plate] = v
                end
            end
        end)
    end
end)

ESX.RegisterServerCallback('renzu_vehicleshop:GenPlate', function (source, cb)
    cb(GenPlate())
end)

ESX.RegisterServerCallback('renzu_vehicleshop:buyvehicle', function (source, cb, model, props, payment, job, type, garage, notregister)
    print("BUYING START")
    local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
    local function sqlfunc(sql, query)
        if sql == 'mysql-async' then
            MySQL.Async.fetchAll(query, {
                ['@model'] = model
            }, function (result)
                print("USING MYSQL ASYNC")
                cb(Buy(result,xPlayer,model, props, payment, job, type , garage))
                return result
            end)
        else
            exports['ghmattimysql']:execute(query, {
                ['@model'] = model
            }, function (result)
                print("USING GHMATTISQL")
                cb(Buy(result,xPlayer,model, props, payment, job, type , garage))
                return result
            end)
        end
    end
    --print(type)
    if not job and type == 'car' and not notregister then
        print("BUYING VEHICLES SAVED FROM SQL vehicles tables")
        sqlfunc(Config.Mysql,'SELECT * FROM vehicles WHERE model = @model LIMIT 1')
    elseif notregister then
        cb(Buy(true,xPlayer,model, props, payment, job, type or 'car' , garage or false, notregister))
    else
        print("BUYING CUSTOM CARS FROM CONFIG SHOP")
        for k,v in pairs(VehicleShop) do
            local actualShop = v
            if v.job == job then
                local result = {}
                for k,v in pairs(v.shop) do
                    if v.model:lower() == model:lower() then
                        print("FOUND A MATCHING MODEL")
                        result[1] = {}
                        result[1].model = v.model
                        result[1].price = v.price
                        result[1].stock = 100
                        cb(Buy(result,xPlayer,model, props, payment, job, type, garage))
                        break
                    end
                end
            elseif type ~= 'car' then
                local result = {}
                if v.shop then
                    for k,v in pairs(v.shop) do
                        --print(model)
                        if v.model:lower() == model:lower() then
                            --print(model)
                            print("FOUND A MATCHING MODEL")
                            result[1] = {}
                            result[1].model = v.model
                            result[1].price = v.price
                            result[1].stock = 100
                            cb(Buy(result,xPlayer,model, props, payment, job, type, garage))
                            break
                        end
                    end
                end
            end
        end
    end
end)

function Buy(result,xPlayer,model, props, payment, job, type, garage, notregister)
    fetchdone = false
    bool = false
    print(" FUNCTION  BUY")
    if result then
        print("RESULT FETCHED")
        local model = nil
        local price = nil
        local stock = nil
        if not notregister then
            model = result[1].model
            price = result[1].price
        else
            model = model
            price = notregister.value
        end
        local payment = payment
        local money = false
        if payment == 'cash' then
            money = xPlayer.getMoney() >= tonumber(price)
        else
            money = xPlayer.getAccount('bank').money >= tonumber(price)
        end
        stock = 999
        if stock > 0 then
            print("STOCK CONDITION")         
            if money then
                print("MONEY CONDITION")
                if payment == 'cash' then
                    xPlayer.removeMoney(tonumber(price))
                else
                    xPlayer.removeAccountMoney('bank', tonumber(price))
                end
                stock = stock - 1
                local data = json.encode(props)
                local query = 'INSERT INTO owned_vehicles (owner, plate, vehicle, `stored`, garage_id, `type`) VALUES (@owner, @plate, @props, @stored, @garage_id, @type)'
                local var = {
                    ['@owner']   = xPlayer.identifier,
                    ['@plate']   = props.plate:upper(),
                    ['@props'] = data,
                    ['@stored'] = 1,
                    ['@garage_id'] = garage,
                    ['@type'] = type
                }
                if Config.SaveJob and job ~= false then
                    query = 'INSERT INTO owned_vehicles (owner, plate, vehicle, `stored`, job, garage_id, `type`) VALUES (@owner, @plate, @props, @stored, @job, @garage_id, @type)'
                    var = {
                        ['@owner']   = xPlayer.identifier,
                        ['@plate']   = props.plate:upper(),
                        ['@props'] = data,
                        ['@stored'] = 1,
                        ['@job'] = job,
                        ['@garage_id'] = garage,
                        ['@type'] = type
                    }
                end
                if Config.Mysql == 'mysql-async' then
                    print("SAVING TO MYSQL ASYNC")
                    MySQL.Async.execute(query,var, function (rowsChanged)
                        MySQL.Sync.execute('UPDATE vehicles SET stock = @stock WHERE model = @model',
                        {
                            ['@stock'] = stock,
                            ['@model'] = model
                        })
                        print("BUY DONE")
                        fetchdone = true
                        bool = true
                    end)
                else
                    exports['ghmattimysql']:execute(query,var, function (rowsChanged)
                        print("USING GHMATTI SQL BUY")
                        exports['ghmattimysql']:execute('UPDATE vehicles SET stock = @stock WHERE model = @model', {
                            ['@stock'] = stock,
                            ['@model'] = model
                        })
                        print("BUY DONE GHMATTI")
                        fetchdone = true
                        bool = true
                    end)
                end
            else
                print("NOT ENOUGH MONEY")
                xPlayer.showNotification('Not Enough Money',1,0,110)
                fetchdone = true
                bool = false
            end
        else
            print("VEHICLE OUT OF STOCK")
            xPlayer.showNotification('Vehicle Out of stock',1,0,110)
            fetchdone = true
            bool = false
        end
    else
        print("VEHICLE NOT IN DATABASE or CONFIG")
        xPlayer.showNotification('Vehicle does not Exist',1,0,110)
        fetchdone = true
        bool = false
    end
    while not fetchdone do Wait(0) end
    print("SENDING TO CLIENT SUCCESS")
    return bool
end

function GetRandomLetter(length)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

function GenPlate()
    local plate = LetterRand()..' '..NumRand()
    if temp[plate] == nil then
        return plate
    end
    Wait(10)
    print(plate)
    return GenPlate()
end

function LetterRand()
    local emptyString = {}
    local randomLetter;
    while (#emptyString < 6) do
        randomLetter = GetRandomLetter(1)
        table.insert(emptyString,randomLetter)
        Wait(0)
    end
    local a = string.format("%s%s%s", table.unpack(emptyString)):upper()  -- "2 words"
    return a
end

function NumRand()
    local emptyString = {}
    local randomLetter;
    while (#emptyString < 6) do
        randomLetter = GetRandomNumber(1)
        table.insert(emptyString,randomLetter)
        Wait(0)
    end
    local a = string.format("%i%i%i", table.unpack(emptyString))  -- "2 words"
    return a
end

function GetRandomNumber(length)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end