
local LastVehicleFromGarage
local id = 'A'
local inGarage = false
local ingarage = false
local garage_coords = {}
local shell = nil
ESX = nil
local fetchdone = false
local PlayerData = {}
local playerLoaded = false
local jobcar = false
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end

	while PlayerData.job == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		PlayerData = ESX.GetPlayerData()
		Citizen.Wait(111)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    playerloaded = true
    for k, v in pairs (VehicleShop) do
        local blip = AddBlipForCoord(v.shop_x, v.shop_y, v.shop_z)
        SetBlipSprite (blip, v.Blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale  (blip, v.Blip.scale)
        SetBlipColour (blip, v.Blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName("Vehicle Shop: "..v.name.."")
        EndTextCommandSetBlipName(blip)
    end
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	playerjob = PlayerData.job.name
end)

local drawtext = false
local indist = false

function tostringplate(plate)
    if plate ~= nil then
        if not Config.PlateSpace then
            return string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1')
        else
            return tostring(plate)
        end
    else
        return 123454
    end
end

local neargarage = false
function PopUI(name,v)
    local table = {
        ['event'] = 'vehicleshop',
        ['title'] = 'Vehicle Shop',
        ['server_event'] = false,
        ['unpack_arg'] = false,
        ['invehicle_title'] = 'Sell Vehicle',
        ['confirm'] = '[ENTER]',
        ['reject'] = '[CLOSE]',
        ['custom_arg'] = {}, -- example: {1,2,3,4}
        ['use_cursor'] = false, -- USE MOUSE CURSOR INSTEAD OF INPUT (ENTER)
    }
    TriggerEvent('renzu_popui:showui',table)
    local dist = #(v - GetEntityCoords(PlayerPedId()))
    while dist < 5 and neargarage do
        dist = #(v - GetEntityCoords(PlayerPedId()))
        Wait(100)
    end
    TriggerEvent('renzu_popui:closeui')
end

CreateThread(function()
    if Config.UsePopUI then
        while true do
            for k,v in pairs(VehicleShop) do
                local vec = vector3(v.shop_x,v.shop_y,v.shop_z)
                local dist = #(vec - GetEntityCoords(PlayerPedId()))
                if dist < v.Dist then
                    neargarage = true
                    PopUI(v.name,vec)
                end
            end
            Wait(1000)
        end
    end
end)

RegisterNetEvent('vehicleshop')
AddEventHandler('vehicleshop', function()
    local sleep = 2000
    local ped = PlayerPedId()
    local vehiclenow = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    local jobgarage = false
    jobcar = false
    for k,v in pairs(VehicleShop) do
        if not v.property then
            local job = v.job == 'all' or PlayerData.job.name == v.job
            local dist = #(vector3(v.shop_x,v.shop_y,v.shop_z) - GetEntityCoords(ped))
            if not DoesEntityExist(vehiclenow) then
                if dist <= v.Dist and job then
                    if PlayerData.job.name == v.job then
                        jobcar = v.job
                    end
                    ESX.ShowNotification("Opening Shop...Please wait..")
                    TriggerServerEvent("renzu_vehicleshop:GetAvailableVehicle",v.name)
                    fetchdone = false
                    id = v.name
                    while not fetchdone do
                        Wait(0)
                    end
                    OpenShop(v.name)
                    break
                end
            end
            if dist > 11 or ingarage then
                indist = false
            end
        end
    end
end)

RegisterNetEvent('renzu_garage:notify')
AddEventHandler('renzu_garage:notify', function(type, message)    
    SendNUIMessage(
        {
            type = "notify",
            typenotify = type,
            message = message,
        }
    ) 
end)

local OwnedVehicles = {}

local VTable = {}

function GetPerformanceStats(vehicle)
    local data = {}
    data.brakes = GetVehicleModelMaxBraking(vehicle)
    local handling1 = GetVehicleModelMaxBraking(vehicle)
    local handling2 = GetVehicleModelMaxBrakingMaxMods(vehicle)
    local handling3 = GetVehicleModelMaxTraction(vehicle)
    data.handling = (handling1+handling2) * handling3
    return data
end

function SetVehicleProp(vehicle, props)
    if ESX == nil then
        if DoesEntityExist(vehicle) then
            local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
            local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
            SetVehicleModKit(vehicle, 0)
            if props.sound then ForceVehicleEngineAudio(vehicle, props.sound) end
            if props.plate then SetVehicleNumberPlateText(vehicle, props.plate) end
            if props.plateIndex then SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex) end
            if props.bodyHealth then SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0) end
            if props.engineHealth then SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0) end
            if props.tankHealth then SetVehiclePetrolTankHealth(vehicle, props.tankHealth + 0.0) end
            if props.fuelLevel then SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0) end
            if props.dirtLevel then SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0) end
            if props.rgb then SetVehicleCustomPrimaryColour(vehicle, props.rgb[1], props.rgb[2], props.rgb[3]) end
            if props.rgb2 then SetVehicleCustomSecondaryColour(vehicle, props.rgb[1], props.rgb[2], props.rgb[3]) end
            if props.color1 then SetVehicleColours(vehicle, props.color1, colorSecondary) end
            if props.color2 then SetVehicleColours(vehicle, props.color1 or colorPrimary, props.color2) end
            if props.pearlescentColor then SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor) end
            if props.wheelColor then SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor) end
            if props.wheels then SetVehicleWheelType(vehicle, props.wheels) end
            if props.windowTint then SetVehicleWindowTint(vehicle, props.windowTint) end
    
            if props.neonEnabled then
                SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
                SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
                SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
                SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
            end
    
            if props.extras then
                for extraId,enabled in pairs(props.extras) do
                    if enabled then
                        SetVehicleExtra(vehicle, tonumber(extraId), 0)
                    else
                        SetVehicleExtra(vehicle, tonumber(extraId), 1)
                    end
                end
            end
    
            if props.neonColor then SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3]) end
            if props.xenonColor then SetVehicleXenonLightsColour(vehicle, props.xenonColor) end
            if props.modSmokeEnabled then ToggleVehicleMod(vehicle, 20, true) end
            if props.tyreSmokeColor then SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3]) end
            if props.modSpoilers then SetVehicleMod(vehicle, 0, props.modSpoilers, false) end
            if props.modFrontBumper then SetVehicleMod(vehicle, 1, props.modFrontBumper, false) end
            if props.modRearBumper then SetVehicleMod(vehicle, 2, props.modRearBumper, false) end
            if props.modSideSkirt then SetVehicleMod(vehicle, 3, props.modSideSkirt, false) end
            if props.modExhaust then SetVehicleMod(vehicle, 4, props.modExhaust, false) end
            if props.modFrame then SetVehicleMod(vehicle, 5, props.modFrame, false) end
            if props.modGrille then SetVehicleMod(vehicle, 6, props.modGrille, false) end
            if props.modHood then SetVehicleMod(vehicle, 7, props.modHood, false) end
            if props.modFender then SetVehicleMod(vehicle, 8, props.modFender, false) end
            if props.modRightFender then SetVehicleMod(vehicle, 9, props.modRightFender, false) end
            if props.modRoof then SetVehicleMod(vehicle, 10, props.modRoof, false) end
            if props.modEngine then SetVehicleMod(vehicle, 11, props.modEngine, false) end
            if props.modBrakes then SetVehicleMod(vehicle, 12, props.modBrakes, false) end
            if props.modTransmission then SetVehicleMod(vehicle, 13, props.modTransmission, false) end
            if props.modHorns then SetVehicleMod(vehicle, 14, props.modHorns, false) end
            if props.modSuspension then SetVehicleMod(vehicle, 15, props.modSuspension, false) end
            if props.modArmor then SetVehicleMod(vehicle, 16, props.modArmor, false) end
            if props.modTurbo then ToggleVehicleMod(vehicle,  18, props.modTurbo) end
            if props.modXenon then ToggleVehicleMod(vehicle,  22, props.modXenon) end
            if props.modFrontWheels then SetVehicleMod(vehicle, 23, props.modFrontWheels, false) end
            if props.modBackWheels then SetVehicleMod(vehicle, 24, props.modBackWheels, false) end
            if props.modPlateHolder then SetVehicleMod(vehicle, 25, props.modPlateHolder, false) end
            if props.modVanityPlate then SetVehicleMod(vehicle, 26, props.modVanityPlate, false) end
            if props.modTrimA then SetVehicleMod(vehicle, 27, props.modTrimA, false) end
            if props.modOrnaments then SetVehicleMod(vehicle, 28, props.modOrnaments, false) end
            if props.modDashboard then SetVehicleMod(vehicle, 29, props.modDashboard, false) end
            if props.modDial then SetVehicleMod(vehicle, 30, props.modDial, false) end
            if props.modDoorSpeaker then SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false) end
            if props.modSeats then SetVehicleMod(vehicle, 32, props.modSeats, false) end
            if props.modSteeringWheel then SetVehicleMod(vehicle, 33, props.modSteeringWheel, false) end
            if props.modShifterLeavers then SetVehicleMod(vehicle, 34, props.modShifterLeavers, false) end
            if props.modAPlate then SetVehicleMod(vehicle, 35, props.modAPlate, false) end
            if props.modSpeakers then SetVehicleMod(vehicle, 36, props.modSpeakers, false) end
            if props.modTrunk then SetVehicleMod(vehicle, 37, props.modTrunk, false) end
            if props.modHydrolic then SetVehicleMod(vehicle, 38, props.modHydrolic, false) end
            if props.modEngineBlock then SetVehicleMod(vehicle, 39, props.modEngineBlock, false) end
            if props.modAirFilter then SetVehicleMod(vehicle, 40, props.modAirFilter, false) end
            if props.modStruts then SetVehicleMod(vehicle, 41, props.modStruts, false) end
            if props.modArchCover then SetVehicleMod(vehicle, 42, props.modArchCover, false) end
            if props.modAerials then SetVehicleMod(vehicle, 43, props.modAerials, false) end
            if props.modTrimB then SetVehicleMod(vehicle, 44, props.modTrimB, false) end
            if props.modTank then SetVehicleMod(vehicle, 45, props.modTank, false) end
            if props.modWindows then SetVehicleMod(vehicle, 46, props.modWindows, false) end
    
            if props.modLivery then
                SetVehicleMod(vehicle, 48, props.modLivery, false)
                SetVehicleLivery(vehicle, props.modLivery)
            end
        end
    else
        ESX.Game.SetVehicleProperties(vehicle, props)
    end
end

function GetVehicleProperties(vehicle)
    if DoesEntityExist(vehicle) then
        local props
        if ESX == nil then
            if DoesEntityExist(vehicle) then
                local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
                local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
                local extras = {}
        
                for extraId=0, 12 do
                    if DoesExtraExist(vehicle, extraId) then
                        local state = IsVehicleExtraTurnedOn(vehicle, extraId) == 1
                        extras[tostring(extraId)] = state
                    end
                end
        
                return {
                    model             = GetEntityModel(vehicle),
                    plate             = GetVehicleNumberPlateText(vehicle),
                    plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),
                    bodyHealth        = Round(GetVehicleBodyHealth(vehicle), 1),
                    engineHealth      = Round(GetVehicleEngineHealth(vehicle), 1),
                    tankHealth        = Round(GetVehiclePetrolTankHealth(vehicle), 1),
        
                    fuelLevel         = Round(GetVehicleFuelLevel(vehicle), 1),
                    dirtLevel         = Round(GetVehicleDirtLevel(vehicle), 1),
                    color1            = colorPrimary,
                    color2            = colorSecondary,
                    rgb				  = table.pack(GetVehicleCustomPrimaryColour(vehicle)),
                    rgb2				  = table.pack(GetVehicleCustomSecondaryColour(vehicle)),
                    pearlescentColor  = pearlescentColor,
                    wheelColor        = wheelColor,
        
                    wheels            = GetVehicleWheelType(vehicle),
                    windowTint        = GetVehicleWindowTint(vehicle),
                    xenonColor        = GetVehicleXenonLightsColour(vehicle),
                    neonEnabled       = {
                        IsVehicleNeonLightEnabled(vehicle, 0),
                        IsVehicleNeonLightEnabled(vehicle, 1),
                        IsVehicleNeonLightEnabled(vehicle, 2),
                        IsVehicleNeonLightEnabled(vehicle, 3)
                    },
                    neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),
                    extras            = extras,
                    tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),
                    modSpoilers       = GetVehicleMod(vehicle, 0),
                    modFrontBumper    = GetVehicleMod(vehicle, 1),
                    modRearBumper     = GetVehicleMod(vehicle, 2),
                    modSideSkirt      = GetVehicleMod(vehicle, 3),
                    modExhaust        = GetVehicleMod(vehicle, 4),
                    modFrame          = GetVehicleMod(vehicle, 5),
                    modGrille         = GetVehicleMod(vehicle, 6),
                    modHood           = GetVehicleMod(vehicle, 7),
                    modFender         = GetVehicleMod(vehicle, 8),
                    modRightFender    = GetVehicleMod(vehicle, 9),
                    modRoof           = GetVehicleMod(vehicle, 10),
                    modEngine         = GetVehicleMod(vehicle, 11),
                    modBrakes         = GetVehicleMod(vehicle, 12),
                    modTransmission   = GetVehicleMod(vehicle, 13),
                    modHorns          = GetVehicleMod(vehicle, 14),
                    modSuspension     = GetVehicleMod(vehicle, 15),
                    modArmor          = GetVehicleMod(vehicle, 16),
                    modTurbo          = IsToggleModOn(vehicle, 18),
                    modSmokeEnabled   = IsToggleModOn(vehicle, 20),
                    modXenon          = IsToggleModOn(vehicle, 22),
                    modFrontWheels    = GetVehicleMod(vehicle, 23),
                    modBackWheels     = GetVehicleMod(vehicle, 24),
                    modPlateHolder    = GetVehicleMod(vehicle, 25),
                    modVanityPlate    = GetVehicleMod(vehicle, 26),
                    modTrimA          = GetVehicleMod(vehicle, 27),
                    modOrnaments      = GetVehicleMod(vehicle, 28),
                    modDashboard      = GetVehicleMod(vehicle, 29),
                    modDial           = GetVehicleMod(vehicle, 30),
                    modDoorSpeaker    = GetVehicleMod(vehicle, 31),
                    modSeats          = GetVehicleMod(vehicle, 32),
                    modSteeringWheel  = GetVehicleMod(vehicle, 33),
                    modShifterLeavers = GetVehicleMod(vehicle, 34),
                    modAPlate         = GetVehicleMod(vehicle, 35),
                    modSpeakers       = GetVehicleMod(vehicle, 36),
                    modTrunk          = GetVehicleMod(vehicle, 37),
                    modHydrolic       = GetVehicleMod(vehicle, 38),
                    modEngineBlock    = GetVehicleMod(vehicle, 39),
                    modAirFilter      = GetVehicleMod(vehicle, 40),
                    modStruts         = GetVehicleMod(vehicle, 41),
                    modArchCover      = GetVehicleMod(vehicle, 42),
                    modAerials        = GetVehicleMod(vehicle, 43),
                    modTrimB          = GetVehicleMod(vehicle, 44),
                    modTank           = GetVehicleMod(vehicle, 45),
                    modWindows        = GetVehicleMod(vehicle, 46),
                    modLivery         = GetVehicleLivery(vehicle)
                }
            else
                return
            end
        else
            props = ESX.Game.GetVehicleProperties(vehicle)
            if not Config.PlateSpace then
                props.plate = string.gsub(tostring(props.plate), '^%s*(.-)%s*$', '%1')
            end
            return props
        end
    end
end

local owned_veh = {}

RegisterNUICallback("choosecategory", function(data, cb)
    local vehtable = {}
    vehtable[data.id] = {}
    local cars = 0
    for k,v2 in pairs(OwnedVehicles) do
        for k2,v in pairs(v2) do
            if data.category == v.category then
                cars = cars + 1
                if vehtable[v.name] == nil then
                    vehtable[v.name] = {}
                end
                veh = 
                {
                brand = v.brand,
                category = v.category,
                name = v.name,
                brake = v.brake,
                handling = v.handling,
                topspeed = v.topspeed,
                power = v.power,
                torque = v.torque,
                model = v.model,
                model2 = v.model2,
                name = v.name,
                price = v.price,
                shop = v.shop,
                }
                table.insert(vehtable[v.name], veh)
            end
        end
    end
    if cars > 0 then
        SendNUIMessage(
            {
                garage_id = id,
                data = vehtable,
                type = "display"
            }
        )

        SetNuiFocus(true, true)
        if not Config.Quickpick then
            RequestCollisionAtCoord(926.15, -959.06, 61.94-30.0)
            for k,v in pairs(VehicleShop) do
                local dist = #(vector3(v.shop_x,v.shop_y,v.shop_z) - GetEntityCoords(ped))
                if dist <= 40.0 and id == v.name then
                cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", v.shop_x-5.0, v.shop_y, v.shop_z-28.0, 360.00, 0.00, 0.00, 60.00, false, 0)
                PointCamAtCoord(cam, v.shop_x, v.shop_y, v.shop_z-30.0)
                SetCamActive(cam, true)
                RenderScriptCams(true, true, 1, true, true)
                SetFocusPosAndVel(v.shop_x, v.shop_y, v.shop_z-30.0, 0.0, 0.0, 0.0)
                DisplayHud(false)
                DisplayRadar(false)
                end
            end
            while inGarage do
                Citizen.Wait(111)
            end
        end

        if LastVehicleFromGarage ~= nil then
            ReqAndDelete(LastVehicleFromGarage)
        end
    else
        ESX.ShowNotification("You dont have any vehicle")
    end
end)
RegisterNetEvent('renzu_vehicleshop:receive_vehicles')
AddEventHandler('renzu_vehicleshop:receive_vehicles', function(tb)
    fetchdone = false
    OwnedVehicles = nil
    Wait(100)
    OwnedVehicles = {}
    tableVehicles = nil
    tableVehicles = tb
    cats = {}
    for _,value in pairs(tableVehicles) do
        OwnedVehicles[value.category] = {}
        cats[value.category] = value.shop
    end

    for _,value in pairs(tableVehicles) do
        --local props = json.decode(value.vehicle)
        local vehicleModel = GetHashKey(value.model)
        local label = nil
        if label == nil then
            label = 'Unknown'
        end

        local vehname = value.name
        -- for _,value in pairs(vehdata) do -- fetch vehicle names from vehicles sql table
        --     if tonumber(props.model) == GetHashKey(value.model) then
        --         vehname = value.name
        --     end
        -- end

        --local vehname = vehicle_data[GetDisplayNameFromVehicleModel(tonumber(props.model))]
        --print(value.model)
        if vehname == nil then
            vehname = GetDisplayNameFromVehicleModel(tonumber(props.model))
        end
        local VTable = {
            brand = GetVehicleClassnamemodel(GetHashKey(value.model)),
            name = vehname:upper(),
            brake = GetPerformanceStats(vehicleModel).brakes,
            handling = GetPerformanceStats(vehicleModel).handling,
            topspeed = math.ceil(GetVehicleModelEstimatedMaxSpeed(vehicleModel)*4.605936),
            power = math.ceil(GetVehicleModelAcceleration(vehicleModel)*1000),
            torque = math.ceil(GetVehicleModelAcceleration(vehicleModel)*800),
            model = value.model,
            category = value.category,
            model2 = GetHashKey(value.model),
            price = value.price,
            name = value.name,
            shop = value.shop
        }
        table.insert(OwnedVehicles[value.category], VTable)
    end
    SendNUIMessage({
        cats = cats,
        type = "categories"
    })
    fetchdone = true
end)

function OpenShop(id)
    inGarage = true
    local ped = PlayerPedId()
    if not Config.Quickpick then
        CreateGarageShell()
    end
    while not fetchdone do
    Citizen.Wait(333)
    end
    local vehtable = {}
    vehtable[id] = {}
    local cars = 0
    for k,v2 in pairs(OwnedVehicles) do
        for k2,v in pairs(v2) do
            --if id == v.garage_id or v.garage_id == 'impound' then
            if id == v.shop then
                cars = cars + 1
                if vehtable[v.name] == nil then
                    vehtable[v.name] = {}
                end
                veh = 
                {
                brand = v.brand,
                category = v.category,
                name = v.name,
                brake = v.brake,
                handling = v.handling,
                topspeed = v.topspeed,
                power = v.power,
                torque = v.torque,
                model = v.model,
                model2 = v.model2,
                name = v.name,
                price = v.price,
                shop = v.shop,
                }
                table.insert(vehtable[v.name], veh)
            end
        end
        break
    end
    if cars > 0 then
        SendNUIMessage(
            {
                garage_id = id,
                data = vehtable,
                type = "display"
            }
        )

        SetNuiFocus(true, true)
        if not Config.Quickpick then
            RequestCollisionAtCoord(926.15, -959.06, 61.94-30.0)
            for k,v in pairs(VehicleShop) do
                local dist = #(vector3(v.shop_x,v.shop_y,v.shop_z) - GetEntityCoords(ped))
                if dist <= 40.0 and id == v.name then
                cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", v.shop_x-5.0, v.shop_y, v.shop_z-28.0, 360.00, 0.00, 0.00, 60.00, false, 0)
                PointCamAtCoord(cam, v.shop_x, v.shop_y, v.shop_z-30.0)
                SetCamActive(cam, true)
                RenderScriptCams(true, true, 1, true, true)
                SetFocusPosAndVel(v.shop_x, v.shop_y, v.shop_z-30.0, 0.0, 0.0, 0.0)
                DisplayHud(false)
                DisplayRadar(false)
                end
            end
            while inGarage do
                Citizen.Wait(111)
            end
        end

        if LastVehicleFromGarage ~= nil then
            ReqAndDelete(LastVehicleFromGarage)
        end
    else
        ESX.ShowNotification("You dont have any vehicle")
    end
end

local inshell = false
function InGarageShell(bool)
    if bool == 'enter' then
        inshell = true
        while inshell do
        Citizen.Wait(0)
        NetworkOverrideClockTime(16, 00, 00)
        end
    elseif bool == 'exit' then
        inshell = false
    end
end

function GetVehicleLabel(vehicle)
    local vehicleLabel = string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
    if vehicleLabel ~= 'null' or vehicleLabel ~= 'carnotfound' or vehicleLabel ~= 'NULL'then
        local text = GetLabelText(vehicleLabel)
        if text == nil or text == 'null' or text == 'NULL' then
            vehicleLabel = vehicleLabel
        else
            vehicleLabel = text
        end
    end
    return vehicleLabel
end

function SetCoords(ped, x, y, z, h, freeze)
    RequestCollisionAtCoord(x, y, z)
    while not HasCollisionLoadedAroundEntity(ped) do
        RequestCollisionAtCoord(x, y, z)
        Citizen.Wait(1)
    end
    DoScreenFadeOut(950)
    Wait(1000)                            
    SetEntityCoords(ped, x, y, z)
    SetEntityHeading(ped, h)
    DoScreenFadeIn(3000)
end

local shell = nil
function CreateGarageShell()
    local ped = PlayerPedId()
    garage_coords = GetEntityCoords(ped)-vector3(0,0,30)
    local model = GetHashKey('garage')
    shell = CreateObject(model, garage_coords.x, garage_coords.y, garage_coords.z, false, false, false)
    while not DoesEntityExist(shell) do Wait(0) end
    FreezeEntityPosition(shell, true)
    SetEntityAsMissionEntity(shell, true, true)
    SetModelAsNoLongerNeeded(model)
    shell_door_coords = vector3(garage_coords.x+7, garage_coords.y-19, garage_coords.z)
    SetCoords(ped, shell_door_coords.x, shell_door_coords.y, shell_door_coords.z, 82.0, true)
    SetPlayerInvisibleLocally(ped, true)
end

local spawnedgarage = {}

function GetVehicleUpgrades(vehicle)
    local stats = {}
    props = ESX.Game.GetVehicleProperties(vehicle)
    stats.engine = props.modEngine+1
    stats.brakes = props.modBrakes+1
    stats.transmission = props.modTransmission+1
    stats.suspension = props.modSuspension+1
    if props.modTurbo == 1 then
        stats.turbo = 1
    elseif props.modTurbo == false then
        stats.turbo = 0
    end
    return stats
end

function GetVehicleStats(vehicle)
    local data = {}
    data.acceleration = GetVehicleModelAcceleration(GetEntityModel(vehicle))
    data.brakes = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fBrakeForce')
    local fInitialDriveMaxFlatVel = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fInitialDriveMaxFlatVel')
    data.topspeed = math.ceil(fInitialDriveMaxFlatVel * 1.3)
    local fTractionBiasFront = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fTractionBiasFront')
    local fTractionCurveMax = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fTractionCurveMax')
    local fTractionCurveMin = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fTractionCurveMin')
    data.handling = (fTractionBiasFront + fTractionCurveMax * fTractionCurveMin)
    return data
end

function classlist(class)
    if class == '0' then
        name = 'Compacts'
    elseif class == '1' then
        name = 'Sedans'
    elseif class == '2' then
        name = 'SUV'
    elseif class == '3' then
        name = 'Coupes'
    elseif class == '4' then
        name = 'Muscle'
    elseif class == '5' then
        name = 'Sports Classic'
    elseif class == '6' then
        name = 'Sports'
    elseif class == '7' then
        name = 'Super'
    elseif class == '8' then
        name = 'Motorcycles'
    elseif class == '9' then
        name = 'Offroad'
    elseif class == '10' then
        name = 'Industrial'
    elseif class == '11' then
        name = 'Utility'
    elseif class == '12' then
        name = 'Vans'
    elseif class == '13' then
        name = 'Cycles'
    elseif class == '14' then
        name = 'Boats'
    elseif class == '15' then
        name = 'Helicopters'
    elseif class == '16' then
        name = 'Planes'
    elseif class == '17' then
        name = 'Service'
    elseif class == '18' then
        name = 'Emergency'
    elseif class == '19' then
        name = 'Military'
    elseif class == '20' then
        name = 'Commercial'
    elseif class == '21' then
        name = 'Trains'
    else
        name = 'CAR'
    end
    return name
end

function GetVehicleClassnamemodel(vehicle)
    local class = tostring(GetVehicleClassFromName(vehicle))
    return classlist(class)
end

function GetVehicleClassname(vehicle)
    local class = tostring(GetVehicleClass(vehicle))
    return classlist(class)
end

local i = 0

local vehtable = {}
local garage_id = 'A'



local min = 0
local max = 10
local plus = 0

function GetAllVehicleFromPool()
    local list = {}
    for k,vehicle in pairs(GetGamePool('CVehicle')) do
        table.insert(list, vehicle)
    end
    return list
end

function DeleteGarage()
    ingarage = false
    ReqAndDelete(shell)
    SetPlayerInvisibleLocally(GetPlayerPed(-1), false)
    shell = nil
    i = 0
    min = 0
    max = 10
    plus = 0
    for i = 1, #spawnedgarage do
        ReqAndDelete(spawnedgarage[i])
        spawnedgarage[i] = nil
        Citizen.Wait(0)
    end
    TriggerEvent('EndScaleformMovie','mp_car_stats_01')
    TriggerEvent('EndScaleformMovie','mp_car_stats_02')
end

function SpawnVehicleLocal(model)
    local ped = PlayerPedId()

    SetNuiFocus(true, true)
    if LastVehicleFromGarage ~= nil then
        ReqAndDelete(LastVehicleFromGarage)
        SetModelAsNoLongerNeeded(hash)
    end

    for k,v in pairs(VehicleShop) do
        local dist = #(vector3(v.shop_x,v.shop_y,v.shop_z) - GetEntityCoords(ped))
        if dist <= 40.0 and id == v.name then
            local zaxis = v.shop_z
            local hash = tonumber(model)
            local count = 0
            if not HasModelLoaded(hash) then
                RequestModel(hash)
                while not HasModelLoaded(hash) and count < 1111 do
                    count = count + 10
                    Citizen.Wait(10)
                    if count > 9999 then
                    return
                    end
                end
            end
            LastVehicleFromGarage = CreateVehicle(hash, v.shop_x,v.shop_y,zaxis - 30, 42.0, 0, 1)
            SetEntityHeading(LastVehicleFromGarage, 50.117)
            FreezeEntityPosition(LastVehicleFromGarage, true)
            SetEntityCollision(LastVehicleFromGarage,false)
            --SetVehicleProp(LastVehicleFromGarage, props)
            currentcar = LastVehicleFromGarage
            if currentcar ~= LastVehicleFromGarage then
                ReqAndDelete(LastVehicleFromGarage)
                SetModelAsNoLongerNeeded(hash)
            end
            TaskWarpPedIntoVehicle(PlayerPedId(), LastVehicleFromGarage, -1)
            --InGarageShell('enter')
        end
    end
end

RegisterNUICallback("SpawnVehicle",function(data, cb)
    if not Config.Quickpick then
        SpawnVehicleLocal(data.modelcar)
    end
end)

RegisterNUICallback(
    "BuyVehicleCallback",
    function(data, cb)
        local ped = PlayerPedId()
        local props = nil
        local veh = nil
        local v = nil
        local hash = tonumber(data.modelcar)
        local count = 0
        ReqAndDelete(LastVehicleFromGarage)
        if not HasModelLoaded(hash) then
            RequestModel(hash)
            while not HasModelLoaded(hash) and count < 555 do
                count = count + 10
                Citizen.Wait(1)
                if count > 9999 then
                return
                end
            end
        end
        ESX.TriggerServerCallback("renzu_vehicleshop:GenPlate",function(plate)
            v = CreateVehicle(tonumber(data.modelcar), VehicleShop[data.shop].spawn_x,VehicleShop[data.shop].spawn_y,VehicleShop[data.shop].spawn_z, VehicleShop[data.shop].heading, 1, 1)
            veh = v
            while not DoesEntityExist(veh) do Wait(10) end
            SetVehicleNumberPlateText(v,tostring(plate))
            props = GetVehicleProperties(v)
            props.plate = tostring(plate)
            SetEntityAlpha(v, 51, false)
            TaskWarpPedIntoVehicle(PlayerPedId(), v, -1)
            ESX.TriggerServerCallback("renzu_vehicleshop:buyvehicle",function(canbuy)
                if canbuy then
                    for k,v in pairs(VehicleShop) do
                        local dist = #(vector3(v.spawn_x,v.spawn_y,v.spawn_z) - GetEntityCoords(PlayerPedId()))
                        if dist <= 70.0 and id == v.name then
                            DoScreenFadeOut(333)
                            ReqAndDelete(LastVehicleFromGarage)
                            Citizen.Wait(333)
                            SetEntityCoords(PlayerPedId(), v.shop_x,v.shop_y,v.shop_z, false, false, false, true)
                            --v = CreateVehicle(tonumber(props.model), v.spawn_x,v.spawn_y,v.spawn_z, v.heading, 1, 1)
                            SetVehicleProp(veh, props)
                            --Spawn_Vehicle_Forward(v, vector3(v.spawn_x,v.spawn_y,v.spawn_z))
                            DoScreenFadeIn(111)
                            while veh == nil do
                                Citizen.Wait(101)
                            end
                            NetworkFadeInEntity(veh,1)
                            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                        end
                    end

                    while veh == nil do
                        Citizen.Wait(10)
                    end
                    --TriggerServerEvent("renzu_garage:changestate", props.plate, 0, id, props.model, props)
                    LastVehicleFromGarage = nil
                    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                    CloseNui()
                    ESX.ShowNotification("Purchase Success: Plate: "..props.plate.."")
                    SetEntityAlpha(v, 255, false)
                    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                    --SetVehicleEngineHealth(v,props.engineHealth)
                    --Wait(100)
                    --SetVehicleStatus(GetVehiclePedIsIn(PlayerPedId()))
                    i = 0
                    min = 0
                    max = 10
                    plus = 0
                    drawtext = false
                    indist = false
                    SendNUIMessage(
                    {
                    type = "cleanup"
                    })
                else
                    CloseNui()
                    --ESX.ShowNotification("Not Enough money cabron")
                    ReqAndDelete(v)
                end
            end, data.model, props, data.payment, jobcar)
        end)
    end
)

RegisterNUICallback(
    "TestDriveCallback",
    function(data, cb)
        local ped = PlayerPedId()
        local props = nil
        local veh = nil
        local v = nil
        local hash = tonumber(data.modelcar)
        local count = 0
        if Config.EnableTestDrive then
            ReqAndDelete(LastVehicleFromGarage)
            if not HasModelLoaded(hash) then
                RequestModel(hash)
                while not HasModelLoaded(hash) and count < 555 do
                    count = count + 10
                    Citizen.Wait(1)
                    if count > 9999 then
                    return
                    end
                end
            end
            ESX.TriggerServerCallback("renzu_vehicleshop:GenPlate",function(plate)
                v = CreateVehicle(tonumber(data.modelcar), VehicleShop[data.shop].spawn_x,VehicleShop[data.shop].spawn_y,VehicleShop[data.shop].spawn_z, VehicleShop[data.shop].heading, 1, 1)
                veh = v
                SetVehicleNumberPlateText(v,plate)
                props = GetVehicleProperties(v)
                props.plate = plate
                SetEntityAlpha(v, 51, false)
                LastVehicleFromGarage = nil
                TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
                CloseNui()
                ESX.ShowNotification("Test Drive: Start")
                SetEntityAlpha(v, 255, false)
                TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
                --SetVehicleEngineHealth(v,props.engineHealth)
                --Wait(100)
                --SetVehicleStatus(GetVehiclePedIsIn(PlayerPedId()))
                i = 0
                min = 0
                max = 10
                plus = 0
                drawtext = false
                oldcoord = vector3(VehicleShop[data.shop].spawn_x,VehicleShop[data.shop].spawn_y,VehicleShop[data.shop].spawn_z)
                indist = false
                SendNUIMessage(
                {
                type = "cleanup"
                })
                local count = 30000
                local function Draw2DText(x, y, text, scale)
                    -- Draw text on screen
                    SetTextFont(4)
                    SetTextProportional(7)
                    SetTextScale(scale, scale)
                    SetTextColour(255, 255, 255, 255)
                    SetTextDropShadow(0, 0, 0, 0,255)
                    SetTextDropShadow()
                    SetTextEdge(4, 0, 0, 0, 255)
                    SetTextOutline()
                    SetTextEntry("STRING")
                    AddTextComponentString(text)
                    DrawText(x, y)
                end
                Wait(1000)
                while count > 1 and IsPedInAnyVehicle(PlayerPedId()) do
                    count = count - 1
                    --ESX.ShowNotification("Seconds Left: "..count)
                    local timeSeconds = count/100
                    local timeMinutes = math.floor(timeSeconds/60.0)
                    timeSeconds = timeSeconds - 60.0*timeMinutes
                    Draw2DText(0.015, 0.725, ("~y~%02d:%06.3f"):format(timeMinutes, timeSeconds), 0.7)
                    Wait(1)
                end
                while DoesEntityExist(veh) do
                    Wait(0)
                    ReqAndDelete(veh)
                end
                SetEntityCoords(PlayerPedId(),oldcoord)
            end)
        else
            ESX.ShowNotification("Test Driving is Disable")
        end
    end
)


RegisterNUICallback("Close",function(data, cb)
    DoScreenFadeOut(111)
    local ped = GetPlayerPed(-1)
    CloseNui()
    for k,v in pairs(VehicleShop) do
        local actualShop = v
        if v.shop_x ~= nil then
            local dist = #(vector3(v.shop_x,v.shop_y,v.shop_z) - GetEntityCoords(ped))
            if dist <= 40.0 and id == v.name then
                SetEntityCoords(ped, v.shop_x,v.shop_y,v.shop_z, 0, 0, 0, false)  
            end
        end
    end
    DoScreenFadeIn(1000)
    DeleteGarage()
end)

function CloseNui()
    SendNUIMessage(
        {
            type = "hide"
        }
    )
    neargarage = false
    SetNuiFocus(false, false)
    InGarageShell('exit')
    if inGarage then
        if LastVehicleFromGarage ~= nil then
            ReqAndDelete(LastVehicleFromGarage)
        end

        local ped = PlayerPedId()     
        RenderScriptCams(false)
        DestroyAllCams(true)
        ClearFocus()
        DisplayHud(true)
    end

    inGarage = false
    DeleteGarage()
    drawtext = false
    indist = false
end

function ReqAndDelete(object, detach)
	if DoesEntityExist(object) then
		NetworkRequestControlOfEntity(object)
		local attempt = 0
		while not NetworkHasControlOfEntity(object) and attempt < 100 and DoesEntityExist(object) do
			NetworkRequestControlOfEntity(object)
			Citizen.Wait(11)
			attempt = attempt + 1
		end
		--if detach then
			DetachEntity(object, 0, false)
		--end
		SetEntityCollision(object, false, false)
		SetEntityAlpha(object, 0.0, true)
		SetEntityAsMissionEntity(object, true, true)
		SetEntityAsNoLongerNeeded(object)
		DeleteEntity(object)
	end
end

function CheckWanderingVehicle(plate)
    local result = nil
    local gameVehicles = GetAllVehicleFromPool()
    for i = 1, #gameVehicles do
        local vehicle = gameVehicles[i]
        if DoesEntityExist(vehicle) then
            if string.gsub(tostring(GetVehicleNumberPlateText(vehicle)), '^%s*(.-)%s*$', '%1') == string.gsub(tostring(GetVehicleNumberPlateText(plate)), '^%s*(.-)%s*$', '%1') then
                ReqAndDelete(vehicle)
                break
            end
        end
    end
end

AddEventHandler("onResourceStop",function(resourceName)
    if resourceName == GetCurrentResourceName() then
        CloseNui()
    end
end)

function GetNearestVehicleinPool(coords)
    local data = {}
    data.dist = -1
    data.state = false
    for k,vehicle in pairs(GetGamePool('CVehicle')) do
        local vehcoords = GetEntityCoords(vehicle,false)
        local dist = #(coords-vehcoords)
        if data.dist == -1 or dist < data.dist then
            data.dist = dist
            data.vehicle = vehicle
            data.coords = vehcoords
            data.state = true
        end
    end
    return data
end

function GerNearVehicle(coords, distance, myveh)
    local vehicles = GetAllVehicleFromPool()
    for i=1, #vehicles, 1 do
        local vehicleCoords = GetEntityCoords(vehicles[i])
        local dist = #(coords-vehicleCoords)
        if dist < distance and vehicles[i] ~= myveh then
            return true
        end
    end
    return false
end

function Spawn_Vehicle_Forward(veh, coords)
    Wait(10)
    local move_coords = coords
    local vehicle = GerNearVehicle(move_coords, 3, veh)
    if vehicle then
        move_coords = move_coords + GetEntityForwardVector(veh) * 6.0
        SetEntityCoords(veh, move_coords.x, move_coords.y, move_coords.z)
    else return end
    Spawn_Vehicle_Forward(veh, move_coords)
end