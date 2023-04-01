ESX = nil
QBCore = nil
vehicletable = 'owned_vehicles'
vehiclemod = 'vehicle'
owner = 'owner'
stored = 'stored'
garage_id = 'garage_id'
type_ = 'type'
Initialized()
local vehicles = {}
local shops = {}
Citizen.CreateThread(function()
    for k,v in pairs(VehicleShop) do
        local list, foundshop = GetVehiclesFromShop(k or 'pdm')
        if not shops[k] then shops[k] = {} end
        --TriggerClientEvent('table',-1,Owned_Vehicle)
        if v.shop then
            shops[k].list = v.shop
            shops[k].type = v.type
        else
            shops[k].list = list
            shops[k].type = v.type
        end
    end
    GlobalState.VehicleShops = shops
end)

function GetVehiclesFromShop(shop)
    local vehicles = {}
    local found = false
    for k,v in pairs(Config.Vehicles) do
        if v.shop == shop then
            vehicles[k] = v
            found = true
        end
    end
    return vehicles, found
end

local NumberCharset = {}
for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

function Deleteveh(plate,src)
    local plate = string.gsub(plate, '^%s*(.-)%s*$', '%1')
    if plate and type(plate) == 'string' then
        CustomsSQL(Config.Mysql,'execute','DELETE FROM '..vehicletable..' WHERE TRIM(UPPER(plate)) = @plate',{['@plate'] = plate})
    else
        print('error not string - Delete Vehicle')
    end
end



RegisterServerEvent('renzu_vehicleshop:sellvehicle')
AddEventHandler('renzu_vehicleshop:sellvehicle', function()
    local source = source
    local xPlayer = GetPlayerFromId(source)
    local price = 1000
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(source))
    local plate = GetVehicleNumberPlateText(vehicle)
    r = CustomsSQL(Config.Mysql,'fetchAll','SELECT * FROM '..vehicletable..' WHERE UPPER(TRIM(plate)) = @plate and '..owner..' = @'..owner..'',{['@plate'] = string.gsub(plate:upper(), '^%s*(.-)%s*$', '%1'), ['@'..owner..''] = xPlayer.identifier})
    if r and #r > 0 then
        local model = json.decode(r[1][vehiclemod]).model
        if model == GetEntityModel(vehicle) then
            result = Config.Vehicles
                if result then
                    for k,v in pairs(result) do
                        if model == GetHashKey(v.model) then
                            price = v.price * (Config.RefundPercent * 0.01)
                        end
                    end
                    Deleteveh(plate,xPlayer.source)
                    xPlayer.addMoney(price)
                    xPlayer.showNotification('Vehicle has been Sold for ^g '..price..'',1,0,110)
                    TriggerClientEvent('sellvehiclecallback',xPlayer.source)
                end
        else
            print("EXPLOIT")
            xPlayer.showNotification('Are you really sure this is the vehicle?',1,0,110)
        end
    else
        xPlayer.showNotification('You dont owned this vehicle',1,0,110)
    end
end)

local Charset = {}
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end
local temp = {}
CreateThread(function()
    Wait(1000)
    local vehicles = CustomsSQL(Config.Mysql,'fetchAll','SELECT * FROM '..vehicletable..'',{})
    for k,v in pairs(vehicles) do
        if v.plate ~= nil then
            temp[v.plate] = v
        end
    end
end)

RegisterServerCallBack_('renzu_vehicleshop:GenPlate', function (source, cb, prefix)
    cb(GenPlate(prefix))
end)

RegisterServerCallBack_('renzu_vehicleshop:buyvehicle', function (source, cb, model, props, payment, job, type, garage, notregister)
    local source = source
	local xPlayer = GetPlayerFromId(source)
    if not job and type == 'car' and not notregister then
        cb(Buy({[1] = Config.Vehicles[model]},xPlayer,model, props, payment, job, type , garage))
    elseif notregister then
        cb(Buy(true,xPlayer,model, props, payment or 'cash', job or 'civ', type or 'car' , garage or 'A' or false, notregister))
    else
        for k,v in pairs(VehicleShop) do
            local actualShop = v
            if v.job == job and v.shop then
                local result = {}
                for k,v in pairs(v.shop) do
                    if v.model:lower() == model:lower() then
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
                        if v.model:lower() == model:lower() then
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

local temp = {}

function Buy(result,xPlayer,model, props, payment, job, type, garage, notregister)
    fetchdone = false
    bool = false
    model = model
    if result then
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
        if money then
            if payment == 'cash' then
                xPlayer.removeMoney(tonumber(price))
            elseif payment == 'bank' then
                xPlayer.removeAccountMoney('bank', tonumber(price))
            else
                xPlayer.removeMoney(tonumber(price))
            end
            stock = stock - 1
            local data = json.encode(props)
            local query = 'INSERT INTO '..vehicletable..' ('..owner..', plate, '..vehiclemod..', job, `'..stored..'`, '..garage_id..', `'..type_..'`) VALUES (@'..owner..', @plate, @props, @job, @'..stored..', @'..garage_id..', @'..type_..')'
            local var = {
                ['@'..owner..'']   = xPlayer.identifier,
                ['@plate']   = props.plate:upper(),
                ['@props'] = data,
                ['@job'] = job,
                ['@'..stored..''] = 1,
                ['@'..garage_id..''] = garage,
                ['@'..type_..''] = type
            }
            if Config.framework == 'QBCORE' then
                query = 'INSERT INTO '..vehicletable..' ('..owner..', plate, '..vehiclemod..', `'..stored..'`, job, '..garage_id..', `'..type_..'`, `hash`, `citizenid`) VALUES (@'..owner..', @plate, @props, @'..stored..', @job, @'..garage_id..', @vehicle, @hash, @citizenid)'
                var = {
                    ['@'..owner..'']   = xPlayer.identifier,
                    ['@plate']   = props.plate:upper(),
                    ['@props'] = data,
                    ['@'..stored..''] = 1,
                    ['@job'] = job,
                    ['@'..garage_id..''] = 'pillboxgarage',
                    ['@vehicle'] = model,
                    ['@hash'] = tostring(GetHashKey(model)),
                    ['@citizenid'] = xPlayer.citizenid,
                }
            end
            CustomsSQL(Config.Mysql,'execute',query,var)
            fetchdone = true
            bool = true
            Config.Carkeys(props.plate,xPlayer.source)
            temp[props.plate] = true
            --TriggerClientEvent('mycarkeys:setowned',xPlayer.source,props.plate) -- sample
        else
            print("NOT ENOUGH MONEY")
            xPlayer.showNotification('Not Enough Money',1,0,110)
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
    return bool
end

local Charset = {}
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end
CreateThread(function()
    Wait(1000)
    local vehicles = CustomsSQL(Config.Mysql,'fetchAll','SELECT * FROM '..vehicletable..'',{})
    for k,v in pairs(vehicles) do
        if v.plate ~= nil then
            temp[v.plate] = v
        end
    end
end)

function GetRandomLetter(length)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

function GenPlate(prefix)
    local plate = LetterRand()..' '..NumRand()
    if prefix then plate = prefix..' '..NumRand() end
    if temp[plate] == nil then
        return plate
    end
    Wait(1)
    return GenPlate(prefix)
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
	math.randomseed(os.time()+math.random(19999,999999))
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

exports('GenPlate', function(plate)
    return GenPlate(plate)
end)

exports('VehiclesList', function()
    return Config.Vehicles
end)

exports('Deleteveh', function(plate)
    return Deleteveh(plate)
end)