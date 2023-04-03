
local LastVehicleFromGarage
local id = 'A'
local garage = 'A'
local inGarage = false
local ingarage = false
local garage_coords = {}
local shell = nil
ESX = nil
QBCore = nil
fetchdone = false
PlayerData = {}
playerLoaded = false
jobcar = false
local type = 'car'
local vehiclesdb = {}
presetprimarycolor = {}
presetsecondarycolor = {}
livery = nil
shopcoords = {}
brand = nil
shoptype = nil
Citizen.CreateThread(function()
    Framework()
    Playerloaded()
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

RegisterNetEvent('renzu_vehicleshop:manage')
AddEventHandler('renzu_vehicleshop:manage', function(xPlayer)
    SendNUIMessage(
        {
            container = "dashboard",
        }
    )
    SetNuiFocus(true, true)
end)

SetJob()

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
function PopUI(name,v,event,text,server,shopname)
    local text = text or ''
    local table = {
        ['event'] = event,
        ['title'] = name,
        ['server_event'] = server,
        ['unpack_arg'] = false,
        ['invehicle_title'] = 'Sell Vehicle '..text..'%',
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

function ShowFloatingHelpNotification(msg, coords,r)
    AddTextEntry('FloatingHelpNotification'..'_'..r, msg)
    SetFloatingHelpTextWorldPosition(1, coords.x,coords.y,coords.z)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('FloatingHelpNotification'..'_'..r)
    EndTextCommandDisplayHelp(2, false, false, -1)
end

function Marker(vec,msg,event,server,dist)
    local r = math.random(1,999)
    while #(vec - GetEntityCoords(PlayerPedId())) < dist and neargarage do
        Wait(0)
        DrawMarker(36, vec ,0,0,0,0,0,2.0,2.0,2.0,1.0,255, 255, 220,200,0,0,0,1)
        ShowFloatingHelpNotification("Press [E] "..msg,vec,r)
        if IsControlJustReleased(0,38) then
            if not server then
                TriggerEvent(event)
            else
                TriggerServerEvent(event)
            end
            Wait(100)
            while neargarage and #(vec - GetEntityCoords(PlayerPedId())) < dist do Wait(100) end
            break
        end
    end
end

local garageped = nil
local targetid = nil
AddTarget = function(data)
	function onEnter(self)
		local model = `cs_jimmydisanto`
		lib.requestModel(model)
		garageped = CreatePed(4,model,self.coords.x,self.coords.y,self.coords.z,0.0,false,true)
		while not DoesEntityExist(garageped) do Wait(0) end
		SetPedConfigFlag(garageped,17,true)
		TaskTurnPedToFaceEntity(garageped,cache.ped,-1)
		local options = {
			{
				name = data.id,
				onSelect = function()
					TriggerEvent(data.event)
				end,
				icon = 'fas fa-warehouse',
				label = data.label,
			}
		}
        targetid = exports.ox_target:addLocalEntity(garageped, options)
	end
	
	function onExit(self)
		DeleteEntity(garageped)
		if targetid then
			exports.ox_target:removeZone(targetid)
		end
	end
	
	function inside(self)
        local coord = GetEntityCoords(garageped)
		DrawMarker(1, coord.x, coord.y, coord.z-0.4, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 200, 255, 255, 50, false, true, 2, nil, nil, false)
	end
	lib.zones.box({
		coords = vec3(data.coord.x,data.coord.y,data.coord.z),
		size = vec3(9, 9, 9),
		rotation = 45,
		debug = false,
		inside = inside,
		onEnter = onEnter,
		onExit = onExit
	})
end

CreateThread(function()
    TryOxLib('init')
    local hastarget = false
    for k,v in pairs(VehicleShop) do
        local vec = vector3(v.shop_x,v.shop_y,v.shop_z)
        local inveh = IsPedInAnyVehicle(PlayerPedId())
        local dist = #(vec - GetEntityCoords(PlayerPedId()))
        if GetResourceState('ox_target') == 'started' and GetResourceState('ox_lib') == 'started' then
            AddTarget({coord = vec, id = 'vehicleshop:'..k, label = v.title, event = 'vehicleshop'})
            hastarget = true
        end
    end
    while not hastarget do
        neargarage = false
        for k,v in pairs(VehicleShop) do
            local vec = vector3(v.shop_x,v.shop_y,v.shop_z)
            local inveh = IsPedInAnyVehicle(PlayerPedId())
            local dist = #(vec - GetEntityCoords(PlayerPedId()))
            if dist < v.Dist and not inveh then
                neargarage = true
                if Config.Marker then
                    Marker(vec,v.title,'vehicleshop',false,v.Dist)
                elseif Config.UsePopUI then
                    PopUI(v.title or v.name,vec,"vehicleshop")
                end
            end
        end

        for k,v in pairs(Refund) do
            local vec = vector3(v.shop_x,v.shop_y,v.shop_z)
            local dist = #(vec - GetEntityCoords(PlayerPedId()))
            local inveh = IsPedInAnyVehicle(PlayerPedId())
            while dist < v.Dist * 2 and inveh do
                dist = #(vec - GetEntityCoords(PlayerPedId()))
                DrawMarker(1, vec ,0,0,0,0,0,2.0,2.0,2.0,1.0,255, 102, 0,200,0,0,0,1)
                if dist < v.Dist and inveh then
                    neargarage = true
                    if Config.Marker then
                        Marker(vec,"Sell Vehicle",'renzu_vehicleshop:sellvehicle',true,3)
                    elseif Config.UsePopUI then
                        PopUI(v.title or v.name,vec,"renzu_vehicleshop:sellvehicle",Config.RefundPercent,true)
                    end
                    break
                end
                Wait(0)
            end
        end
        Wait(1000)
    end
end)

function GetVehicleUpgrades(vehicle)
    local stats = {}
    props = GetVehicleProperties(vehicle)
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

function GetMaxMod(vehicle,index)
    local max = GetNumVehicleMods(vehicle, tonumber(index))
    return max
end

function GetVehicleInfo(vehicle,name)
    local val = GetVehicleHandlingFloat(vehicle, 'CHandlingData', name)
    return val
end

function GetVehicleDriveTrain(vehicle)
    local val = GetVehicleInfo(vehicle,'fDriveBiasFront')
    local drivetrain = 'FWD'
    if val >= 0.5 then
        drivetrain = 'AWD'
    end
    if val == 0.0 then
        drivetrain = 'RWD'
    end
    return drivetrain
end

function GetNumSeat(vehicle)
    local c = 0
    for i=0-1, 7 do
        if IsVehicleSeatFree(vehicle,i) then
            c = c + 1
        end
    end
    return c
end

local displaycars = {}
function numWithCommas(n)
    return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,")
                                  :gsub(",(%-?)$","%1"):reverse()
end
CreateThread(function()
    Wait(2000)
    if Config.DisplayCars then
        local stats_show = nil
        local cleared = false
        while true do
            for shop,v in pairs(VehicleShop) do
                local vec = vector3(v.shop_x,v.shop_y,v.shop_z)
                local inveh = IsPedInAnyVehicle(PlayerPedId())
                local dist = #(vec - GetEntityCoords(PlayerPedId()))
                if dist < 50 and not inveh and v.displaycars then
                    neargarage = true
                    if not cleared then
                        ClearAreaOfVehicles(v.shop_x,v.shop_y,v.shop_z, 100, false, false, false, false, false)
                    end
                    cleared = true
                    for k,v in pairs(v.displaycars) do
                        local k = tostring(k)
                        if displaycars[k] == nil then
                            local hash = tonumber(GetHashKey(v.model))
                            local count = 0
                            if not HasModelLoaded(hash) then
                                RequestModel(hash)
                                while not HasModelLoaded(hash) do
                                    RequestModel(hash)
                                    Citizen.Wait(10)
                                end
                            end
                            --local posZ = coord.z + 999.0
                            --_,posZ = GetGroundZFor_3dCoord(coord.x,coord.y+.0,coord.z,1)
                            displaycars[k] = CreateVehicle(hash, v.coord.x,v.coord.y,v.coord.z, 42.0, 0, true)
                            SetEntityHeading(displaycars[k], v.coord.w)
                            SetVehicleDoorsLocked(displaycars[k],2)
                            NetworkFadeInEntity(displaycars[k],1)
                            SetVehicleOnGroundProperly(displaycars[k])
                            FreezeEntityPosition(displaycars[k], true)
                        end
                    end
                    for k,v in pairs(v.displaycars) do
                        if #(vector3(v.coord.x,v.coord.y,v.coord.z) - GetEntityCoords(PlayerPedId())) < 3 then
                            local nearveh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 2.000, 0, 70)
                            if nearveh ~= 0 then
                                local name = 'not found'
                                for k,v in pairs(vehiclesdb) do
                                    if GetEntityModel(nearveh) == GetHashKey(v.model) then
                                        name = v.name
                                    end
                                end
                                if name == 'not found' then
                                    name = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(nearveh)))
                                end
                                local vehstats = GetVehicleStats(nearveh)
                                local upgrades = GetVehicleUpgrades(nearveh)
                                local stats = {
                                    class = GetVehicleClassnamemodel(nearveh),
                                    topspeed = vehstats.topspeed / 300 * 100,
                                    acceleration = vehstats.acceleration * 150,
                                    brakes = vehstats.brakes * 80,
                                    traction = vehstats.handling * 10,
                                    name = name,
                                    weight = GetVehicleInfo(nearveh,'fMass'),
                                    seat = GetNumSeat(nearveh),
                                    drivetrain = GetVehicleDriveTrain(nearveh),
                                    gear = GetVehicleInfo(nearveh,'nInitialDriveGears'),
                                    turbo = numWithCommas(v.value),
                                }
                                if stats_show == nil or stats_show ~= nearveh then
                                    stats_show = nearveh
                                    SendNUIMessage({
                                        type = "stats",
                                        perf = stats,
                                        public = false,
                                        show = true,
                                    })
                                    CreateThread(function()
                                        while nearveh ~= 0 do
                                            Wait(200)
                                            nearveh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 3.000, 0, 70)
                                        end
                                    end)
                                    while nearveh ~= 0 do 
                                        if IsControlJustReleased(0,38) then
                                            local t = {
                                                ['event'] = 'renzu_vehicleshop:buyvehicle',
                                                ['title'] = 'Confirm Purchase:',
                                                ['server_event'] = false,
                                                ['unpack_arg'] = true,
                                                ['confirm'] = '[Enter]',
                                                ['reject'] = '[CLOSE]',
                                                ['custom_arg'] = {v.model,shop,'cash',v}, -- example: {1,2,3,4}
                                                ['use_cursor'] = false, -- USE MOUSE CURSOR INSTEAD OF INPUT (ENTER)
                                            }
                                            TriggerEvent('renzu_popui:showui',t)
                                        end
                                        Wait(1)
                                    end
                                end
                                while nearveh ~= 0 do
                                    nearveh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 3.000, 0, 70)
                                    Wait(200)
                                end
                                SendNUIMessage({
                                    type = "stats",
                                    perf = false,
                                    public = false,
                                    show = false,
                                })
                            end
                        end
                    end
                elseif dist > 50 and #displaycars > 0 then
                    for k,v in pairs(displaycars) do
                        ReqAndDelete(v)
                    end
                    displaycars = {}
                end
            end
            Wait(1000)
        end
    end
end)

RegisterNetEvent('sellvehiclecallback')
AddEventHandler('sellvehiclecallback', function()
    ReqAndDelete(GetVehiclePedIsIn(PlayerPedId()))
end)

RegisterNetEvent('table2')
AddEventHandler('table2', function(data)
    local t = {}
    for k,v in pairs(data) do
        t[v.model] = {
            ['name'] = v.name,
            ['brand'] = v.category,
            ['model'] = v.model,
            ['price'] = v.price,
            ['category'] = classlist(tostring(GetVehicleClassFromName(v.model))):lower(),
            ['hash'] = GetHashKey(v.model),
            ['shop'] = 'pdm',
        }
    end
    TriggerEvent('table',t)
end)

RegisterNetEvent('vehicleshop')
AddEventHandler('vehicleshop', function()
    local sleep = 2000
    local ped = PlayerPedId()
    local vehiclenow = GetVehiclePedIsIn(PlayerPedId(), false)
    local jobgarage = false
    jobcar = false
    for k,v in pairs(VehicleShop) do
        local job = true
        if PlayerData?.job?.name ~= v.job and v.job ~= 'all' then
            job = false
        end
        local dist = #(vector3(v.shop_x,v.shop_y,v.shop_z) - GetEntityCoords(ped))
        if not DoesEntityExist(vehiclenow) then
            if dist <= v.Dist and job then
                if Config.Licensed and not Config.framework == 'QBCORE' then
                    TriggerServerCallback_('esx_license:checkLicense', function(cb)
                        if cb then
                            if PlayerData.job.name == v.job then
                                jobcar = v.job
                            end
                            type = v.type
                            fetchdone = false
                            id = k
                            garage = v.default_garage or 'A'
                            shopcoords = vector3(v.shop_x,v.shop_y,v.shop_z)
                            OpenShop(k)
                        else
                            ShowNotification("You Dont have a drivers licensed")
                        end
                    end, GetPlayerServerId(PlayerId()), 'drive')
                else
                    if PlayerData.job.name == v.job then
                        jobcar = v.job
                    end
                    type = v.type
                    fetchdone = false
                    id = k
                    garage = v.default_garage or 'A'

                    shopcoords = vector3(v.shop_x,v.shop_y,v.shop_z)
                    OpenShop(k)
                    break
                end
            end
        end
        if dist > 11 or ingarage then
            indist = false
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

local Vehicles = {}

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
    -- https://github.com/esx-framework/es_extended/tree/v1-final COPYRIGHT
    if DoesEntityExist(vehicle) then
		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleModKit(vehicle, 0)
		if props.plate then SetVehicleNumberPlateText(vehicle, props.plate) end
		if props.plateIndex then SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex) end
		if props.bodyHealth then SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0) end
		if props.engineHealth then SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0) end
		if props.tankHealth then SetVehiclePetrolTankHealth(vehicle, props.tankHealth + 0.0) end
		if props.dirtLevel then SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0) end
		if props.rgb then SetVehicleCustomPrimaryColour(vehicle, props.rgb[1], props.rgb[2], props.rgb[3]) end
		if props.rgb2 then SetVehicleCustomSecondaryColour(vehicle, props.rgb2[1], props.rgb2[2], props.rgb2[3]) end
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
		if props.modSmokeEnabled then ToggleVehicleMod(vehicle, 20, true) else ToggleVehicleMod(vehicle, 20, false) end
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
		if props.modTurbo then ToggleVehicleMod(vehicle,  18, props.modTurbo) else ToggleVehicleMod(vehicle,  18, false) end
		if props.modXenon then ToggleVehicleMod(vehicle,  22, props.modXenon) else ToggleVehicleMod(vehicle,  22, false) end
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
        if props.fuelLevel then SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0) if DecorGetFloat(vehicle,'_FUEL_LEVEL') then DecorSetFloat(vehicle,'_FUEL_LEVEL',props.fuelLevel + 0.0) end end
	end
end

MathRound = function(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10^numDecimalPlaces
		return math.floor((value * power) + 0.5) / (power)
	else
		return math.floor(value + 0.5)
	end
end

function GetVehicleProperties(vehicle)
    -- https://github.com/esx-framework/es_extended/tree/v1-final COPYRIGHT
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
        local plate = GetVehicleNumberPlateText(vehicle)
        local modlivery = GetVehicleLivery(vehicle)
        if modlivery == -1 then
            modlivery = GetVehicleMod(vehicle, 48)
        end
        return {
            model             = GetEntityModel(vehicle),
            plate             = plate,
            plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),

            bodyHealth        = MathRound(GetVehicleBodyHealth(vehicle), 1),
            engineHealth      = MathRound(GetVehicleEngineHealth(vehicle), 1),
            tankHealth        = MathRound(GetVehiclePetrolTankHealth(vehicle), 1),

            fuelLevel         = MathRound(GetVehicleFuelLevel(vehicle), 1),
            dirtLevel         = MathRound(GetVehicleDirtLevel(vehicle), 1),
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
            modLivery         = modlivery
        }
    else
        return
    end
end

local owned_veh = {}
colortype = 'primary'
RegisterNUICallback("selectcolortype", function(data, cb)
    colortype = data.type
end)

RegisterNUICallback("choosecolor", function(data, cb)
    if colortype == 'primary' then
        presetprimarycolor = {r = data.r, g = data.g, b = data.b}
        if LastVehicleFromGarage then
            SetVehicleCustomPrimaryColour(LastVehicleFromGarage,tonumber(presetprimarycolor.r),tonumber(presetprimarycolor.g),tonumber(presetprimarycolor.b))
        end
    else
        presetsecondarycolor = {r = data.r, g = data.g, b = data.b}
        if LastVehicleFromGarage then
            SetVehicleCustomSecondaryColour(LastVehicleFromGarage,tonumber(presetsecondarycolor.r),tonumber(presetsecondarycolor.g),tonumber(presetsecondarycolor.b))
        end
    end
end)

RegisterNUICallback("setlivery", function(data, cb)
    local vehicle = LastVehicleFromGarage
    SetVehicleModKit(vehicle,0)
    if GetVehicleLiveryCount(vehicle) ~= -1 then
        if data.next then
            SetVehicleLivery(vehicle,GetVehicleLivery(vehicle) + 1)
        elseif GetVehicleLivery(vehicle) ~= -1 then
            SetVehicleLivery(vehicle,GetVehicleLivery(vehicle) - 1)
        end
        livery = GetVehicleLivery(vehicle)
    else
        if data.next then
            SetVehicleMod(vehicle, 48, GetVehicleMod(vehicle,48) + 1, false)
        elseif GetVehicleMod(vehicle,48) ~= -1 then
            SetVehicleMod(vehicle, 48, GetVehicleMod(vehicle,48) - 1, false)
        end
        livery = GetVehicleMod(vehicle,48)
    end
end)

RegisterNUICallback("choosebrands", function(data, cb)
    local vehtable = {}
    vehtable[data.id] = {}
    local cars = 0
    brand = data.brand
    local cats = {}
    for k,v2 in pairs(Vehicles) do
        for k2,v in pairs(v2) do
            if data.brand == v.brand and IsModelInCdimage(GetHashKey(v.model)) then
                cars = cars + 1
                cats[v.brand] = true
                if vehtable[v.name] == nil then
                    vehtable[v.name] = {}
                end
                veh = {
                    brand = v.brand,
                    category = v.category,
                    image = v.image,
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
        SendNUIMessage({
            cats = cats,
            type = "categories"
        })
        Wait(100)
        SendNUIMessage(
            {
                garage_id = id,
                data = vehtable,
                type = "display"
            }
        )

        SetNuiFocus(true, true)
        if not Config.Quickpick and type == 'car' then
            RequestCollisionAtCoord(926.15, -959.06, 61.94-30.0)
            for k,v in pairs(VehicleShop) do
                local dist = #(vector3(v.shop_x,v.shop_y,v.shop_z) - GetEntityCoords(ped))
                if Config.UseArenaSpawn then
                    if dist <= 40.0 and id == v.name then
                        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 2800.5966796875-5.5,-3799.7370605469,122.41514587402, 360.00, 0.00, 0.00, 60.00, false, 0)
                        PointCamAtCoord(cam, 2800.5966796875,-3799.7370605469,122.41514587402)
                        SetCamActive(cam, true)
                        SetCamFov(cam, 45.0)
                        SetCamRot(cam, -15.0, 0.0, 252.063)
                        RenderScriptCams(true, true, 1, true, true)
                        SetFocusPosAndVel(2800.5966796875,-3799.7370605469,134.41514587402, 0.0, 0.0, 0.0)
                        DisplayHud(false)
                        DisplayRadar(false)
                    end
                else
                    if dist <= 40.0 and id == v.name then
                        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", v.shop_x-5.0, v.shop_y-3.0, v.shop_z-28.5, 360.00, 0.00, 0.00, 60.00, false, 0)
                        PointCamAtCoord(cam, v.shop_x, v.shop_y, v.shop_z-30.0)
                        SetCamActive(cam, true)
                        SetCamFov(cam, 45.0)
                        SetCamRot(cam, -15.0, 0.0, 252.063)
                        RenderScriptCams(true, true, 1, true, true)
                        SetFocusPosAndVel(v.shop_x, v.shop_y, v.shop_z-30.0, 0.0, 0.0, 0.0)
                        DisplayHud(false)
                        DisplayRadar(false)
                    end
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
        ShowNotification("No Vehicle is Available")
    end
end)

RegisterNUICallback("choosecategory", function(data, cb)
    local vehtable = {}
    vehtable[data.id] = {}
    if brand == nil then
        brand = 'sports'
    end
    local cars = 0
    local cats = {}
    for k,v2 in pairs(Vehicles) do
        for k2,v in pairs(v2) do
            if shoptype == 'car' and brand == v.brand and data.category == v.category and IsModelInCdimage(GetHashKey(v.model))
            or shoptype ~= 'car' and data.category == v.category and IsModelInCdimage(GetHashKey(v.model)) then
                cars = cars + 1
                cats[v.category] = true
                if vehtable[v.name] == nil then
                    vehtable[v.name] = {}
                end
                veh = 
                {
                brand = v.brand,
                category = v.category,
                image = v.image,
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
        if not Config.Quickpick and type == 'car' then
            RequestCollisionAtCoord(926.15, -959.06, 61.94-30.0)
            for k,v in pairs(VehicleShop) do
                local dist = #(vector3(v.shop_x,v.shop_y,v.shop_z) - GetEntityCoords(ped))
                if Config.UseArenaSpawn then
                    if dist <= 40.0 and id == v.name then
                        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 2800.5966796875-5.5,-3799.7370605469,122.41514587402, 360.00, 0.00, 0.00, 60.00, false, 0)
                        PointCamAtCoord(cam, 2800.5966796875,-3799.7370605469,122.41514587402)
                        SetCamActive(cam, true)
                        SetCamFov(cam, 45.0)
                        SetCamRot(cam, -15.0, 0.0, 252.063)
                        RenderScriptCams(true, true, 1, true, true)
                        SetFocusPosAndVel(2800.5966796875,-3799.7370605469,134.41514587402, 0.0, 0.0, 0.0)
                        DisplayHud(false)
                        DisplayRadar(false)
                    end
                else
                    if dist <= 40.0 and id == v.name then
                        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", v.shop_x-5.0, v.shop_y-3.0, v.shop_z-28.5, 360.00, 0.00, 0.00, 60.00, false, 0)
                        PointCamAtCoord(cam, v.shop_x, v.shop_y, v.shop_z-30.0)
                        SetCamActive(cam, true)
                        SetCamFov(cam, 45.0)
                        SetCamRot(cam, -15.0, 0.0, 252.063)
                        RenderScriptCams(true, true, 1, true, true)
                        SetFocusPosAndVel(v.shop_x, v.shop_y, v.shop_z-30.0, 0.0, 0.0, 0.0)
                        DisplayHud(false)
                        DisplayRadar(false)
                    end
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
        ShowNotification("No Vehicle is Available")
    end
end)

PopulateVehicleshop = function(k)
    shoptype = GlobalState.VehicleShops[k].type
    local tb = GlobalState.VehicleShops[k].list
    fetchdone = false
    Vehicles = {}
    cats = {}
    brands = {}
    vehiclesdb = tb
    local gstate = GlobalState and GlobalState.VehicleImages
    for _,value in pairs(tb) do
        --local props = json.decode(value.vehicle)
        local vehicleModel = joaat(value.model)
        if IsModelInCdimage(vehicleModel) then
            if not Vehicles[value.brand] then Vehicles[value.brand] = {} end
            if shoptype ~= 'car' then
                cats[value.brand] = value.shop
            end
            if shoptype == 'car' and value.brand ~= nil then
                brands[value.brand] = value.shop
            end
            local label = nil
            if label == nil then
                label = 'Unknown'
            end

            local vehname = value.name
            if vehname == nil then
                vehname = GetDisplayNameFromVehicleModel(value.name)
            end
            local pmult, tmult, handling, brake = 1000,800,GetPerformanceStats(vehicleModel).handling,GetPerformanceStats(vehicleModel).brakes
            if shoptype == 'boat' or shoptype == 'plane' then
                pmult,tmult,handling, brake = 10,8,GetPerformanceStats(vehicleModel).handling * 0.1, GetPerformanceStats(vehicleModel).brakes * 0.1
            end
            local img = 'https://cfx-nui-renzu_vehicleshop/imgs/uploads/'..value.model..'.jpg'
            local hashmodel = joaat(value.model)
            if Config.CustomImg and not Config.use_renzu_vehthumb then
                img = value[Config.CustomImgColumn]
            elseif Config.use_renzu_vehthumb and gstate[tostring(hashmodel)] then
                img = gstate[tostring(hashmodel)]
            end
            local VTable = {
                brand = value.brand,
                name = vehname:upper(),
                brake = brake,
                handling = handling,
                topspeed = math.ceil(GetVehicleModelEstimatedMaxSpeed(vehicleModel)*4.605936),
                power = math.ceil(GetVehicleModelAcceleration(vehicleModel)*pmult),
                torque = math.ceil(GetVehicleModelAcceleration(vehicleModel)*tmult),
                model = value.model,
                category = value.category,
                image = img,
                model2 = GetHashKey(value.model),
                price = value.price,
                name = value.name,
                shop = value.shop
            }
            table.insert(Vehicles[value.brand], VTable)
        end
    end
    SendNUIMessage(
        {
            container = "shop"
        }
    )
    Wait(1000)
    -- SendNUIMessage({
    --     cats = cats,
    --     type = "categories",
    --     shoptype = shoptype
    -- })
    SendNUIMessage({
        brands = brands,
        type = "brands",
        shoptype = shoptype
    })
    fetchdone = true
end

DoScreenFadeIn(1)
function OpenShop(id)
    PopulateVehicleshop(id)
    inGarage = true
    local ped = PlayerPedId()
    FreezeEntityPosition(PlayerPedId(),true)
    if not Config.Quickpick and type == 'car' then
        CreateGarageShell()
    end
    while not fetchdone do
    Citizen.Wait(333)
    end
    local vehtable = {}
    vehtable[id] = {}
    local cars = 0
    if not Config.Quickpick and type == 'car' then
        DoScreenFadeOut(0)
    end
    while Config.UseArenaSpawn and type == 'car' and not IsIplActive("xs_arena_interior") do Wait(0) end
    while not HasCollisionLoadedAroundEntity(ped) do Wait(0) DoScreenFadeOut(0) end
    Wait(1000)
    DoScreenFadeIn(3000)
    for k,v2 in pairs(Vehicles) do
        for k2,v in pairs(v2) do
            if id == v.shop and IsModelInCdimage(GetHashKey(v.model)) then
                cars = cars + 1
                if vehtable[v.name] == nil then
                    vehtable[v.name] = {}
                end
                veh = 
                {
                brand = v.brand,
                category = v.category,
                image = v.image,
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
        local quick = Config.Quickpick
        if type ~= 'car' then
            quick = true
        end
        SendNUIMessage(
            {
                garage_id = id,
                data = vehtable,
                type = "display",
                shop = {icon = VehicleShop[id].icon, shop = VehicleShop[id].title},
                quickpick = quick,
            }
        )

        SetNuiFocus(true, true)
        if not Config.Quickpick and type == 'car' then
            RequestCollisionAtCoord(2800.5966796875,-3799.7370605469,139.41514587402)
            for k,v in pairs(VehicleShop) do
                local dist = #(vector3(v.shop_x,v.shop_y,v.shop_z) - GetEntityCoords(ped))
                if Config.UseArenaSpawn then
                    vec = vector3(2800.5966796875,-3799.7370605469,139.41514587402)
                    dist = #(vec - GetEntityCoords(ped))
                    if dist <= 40.0 and id == v.name then
                        shopcoords = vector3(v.shop_x,v.shop_y,v.shop_z)
                        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 2800.5966796875-4.0,-3799.7370605469-3.0,140.4514587402, 360.00, 0.00, 0.00, 60.00, false, 0)
                        PointCamAtCoord(cam, 2800.5966796875,-3799.7370605469,139.51514587402)
                        SetCamActive(cam, true)
                        SetCamFov(cam, 55.0)
                        SetCamRot(cam, -15.0, 0.0, 252.063)
                        RenderScriptCams(true, true, 1, true, true)
                        SetFocusPosAndVel(2800.5966796875,-3799.7370605469,139.41514587402, 0.0, 0.0, 0.0)
                        DisplayHud(false)
                        DisplayRadar(false)
                        break
                    end
                else
                    if dist <= 40.0 and id == v.name then
                        shopcoords = vector3(v.shop_x,v.shop_y,v.shop_z)
                        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", v.shop_x-5.0, v.shop_y-3.0, v.shop_z-28.5, 360.00, 0.00, 0.00, 60.00, false, 0)
                        PointCamAtCoord(cam, v.shop_x, v.shop_y, v.shop_z-30.0)
                        SetCamActive(cam, true)
                        SetCamFov(cam, 45.0)
                        SetCamRot(cam, -15.0, 0.0, 252.063)
                        RenderScriptCams(true, true, 1, true, true)
                        SetFocusPosAndVel(v.shop_x, v.shop_y, v.shop_z-30.0, 0.0, 0.0, 0.0)
                        DisplayHud(false)
                        DisplayRadar(false)
                        break
                    end
                end
            end
            Citizen.CreateThread(function()
                local coord = vector3(2800.5966796875,-3799.7370605469,139.41514587402)
                --SetEntityAlpha(PlayerPedId(),1,true)
                while inGarage do
                    Citizen.Wait(0)
                    if LastVehicleFromGarage ~= nil then
                        SetEntityHeading(LastVehicleFromGarage, GetEntityHeading(LastVehicleFromGarage) - 0.1)
                    end
                    DrawLightWithRange(coord.x-4.0, coord.y-3.0, coord.z+ 0.3, 255,255,255, 40.0, 15.0)
                    DrawSpotLight(coord.x-4.0, coord.y+5.0, coord.z, coord, 255, 255, 255, 20.0, 1.0, 1.0, 20.0, 0.95)

                    if not Config.UseArenaSpawn then
                        NetworkOverrideClockTime(18, 0, 0)
                    end
                end
            end)
            while inGarage do
                --SetEntityAlpha(PlayerPedId(),1,true)
                Citizen.Wait(111)
            end
        end

        if LastVehicleFromGarage ~= nil then
            ReqAndDelete(LastVehicleFromGarage)
        end
    else
        FreezeEntityPosition(PlayerPedId(),true)
        SetEntityCoords(PlayerPedId(),shopcoords)
        while not HasCollisionLoadedAroundEntity(PlayerPedId()) do Wait(0) end
        FreezeEntityPosition(PlayerPedId(),false)
        ShowNotification("No Vehicle is Available 2")
    end
end

local inshell = false
function inShowRoom(bool)
    if bool == 'enter' then
        inshell = true
        while inshell do
            Citizen.Wait(0)
            NetworkOverrideClockTime(22, 00, 00)
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

function SetCoords(ped, xx, yy, zz, hh, freeze)
    local xx, yy, zz = xx, yy, zz
    RequestCollisionAtCoord(xx, yy, zz)
    while not HasCollisionLoadedAroundEntity(ped) do
        RequestCollisionAtCoord(xx, yy, zz)
        Citizen.Wait(1)
    end
    DoScreenFadeOut(950)
    Wait(1000)                            
    SetEntityCoordsNoOffset(ped, xx, yy, zz,true,false,false)
    SetEntityHeading(ped, hh)
    DoScreenFadeIn(3000)
end

local shell = nil
local arenacoord = vector4(2800.55,-3799.73,139.41,244.54)
function CreateGarageShell()
    local ped = PlayerPedId()
    garage_coords = GetEntityCoords(ped)-vector3(0,0,30.0)
    local model = GetHashKey('garage')
    if Config.UseArenaSpawn then
        LoadArena()
        SetCoords(ped, 2805.55,-3793.73,133.41,244.54, true)
    else
        shell = CreateObject(model, garage_coords.x, garage_coords.y, garage_coords.z, false, false, false)
        while not DoesEntityExist(shell) do Wait(0) end
        FreezeEntityPosition(shell, true)
        SetEntityAsMissionEntity(shell, true, true)
        SetModelAsNoLongerNeeded(model)
        shell_door_coords = vector3(garage_coords.x+7.0, garage_coords.y-19.0, garage_coords.z)
        SetCoords(ped, shell_door_coords.x, shell_door_coords.y, shell_door_coords.z, 82.0, true)
    end
end

local spawnedgarage = {}

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

local loading = false
downloading = false

GetClosestVehicle = function(coord,distance)
    local entity = 0
    local nearest = -1
    for k,vehicle in pairs(GetGamePool('CVehicle')) do
        local dist = #(GetEntityCoords(vehicle) - coord)
        if dist < distance and nearest == -1 or nearest > dist then
            nearest = dist
            entity = vehicle
        end
    end
    return entity
end

function SpawnVehicleLocal(model)
    if downloading or not IsModelInCdimage(model) then return end
    local ped = PlayerPedId()
    SetNuiFocus(true, true)
    if LastVehicleFromGarage ~= nil then
        ReqAndDelete(LastVehicleFromGarage)
        SetModelAsNoLongerNeeded(hash)
    end
    for i = 1, 2 do
        local nearveh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 2.000, 0, 70)
        if DoesEntityExist(nearveh) then
            ReqAndDelete(nearveh)
        end
        while DoesEntityExist((nearveh)) do ReqAndDelete(nearveh) Wait(100) end
    end

    for k,v in pairs(VehicleShop) do
        local dist = #(vector3(v.shop_x,v.shop_y,v.shop_z) - GetEntityCoords(ped))
        if Config.UseArenaSpawn then
            vec = vector3(2800.5966796875,-3799.7370605469,139.41514587402)
            dist = #(vec - GetEntityCoords(ped))
        end
        if dist <= 40.0 and id == v.name then
            local zaxis = v.shop_z
            local hash = tonumber(model)
            local count = 0
            if not HasModelLoaded(hash) then
                RequestModel(hash)
                SetNuiFocus(false, false)
                BusyspinnerOff()
                Wait(10)
                AddTextEntry("CUSTOMLOADSTR", 'Downloading Vehicle Assets..')
                BeginTextCommandBusyspinnerOn("CUSTOMLOADSTR")
                EndTextCommandBusyspinnerOn(4)
                downloading = true
                local c = 0
                while not HasModelLoaded(hash) do
                    c = c + 1
                    if IsControlPressed(0,202) then
                        BusyspinnerOff()
                        CloseNui()
                        break
                    end
                    if c > 20000 then
                        BusyspinnerOff()
                        Wait(10)
                        AddTextEntry("CUSTOMLOADSTR", 'Vehicle Download Taking too long, ask server admin..')
                        BeginTextCommandBusyspinnerOn("CUSTOMLOADSTR")
                        EndTextCommandBusyspinnerOn(4)
                        Wait(2000)
                        break
                    end
                    Citizen.Wait(0)
                end
                BusyspinnerOff()
                SetNuiFocus(true, true)
                loading = true
                downloading = false
            end
            loading = false
            if Config.UseArenaSpawn then
                vec = vector3(2800.5966796875,-3799.7370605469,139.41514587402)
            else
                vec = vector3(v.shop_x,v.shop_y,zaxis - 30.0)
            end
            LastVehicleFromGarage = CreateVehicle(hash, vec.x,vec.y,vec.z, 90.0, false, true)
            while not DoesEntityExist(LastVehicleFromGarage) do Wait(0) end
            SetEntityHeading(LastVehicleFromGarage, 90.117)
            FreezeEntityPosition(LastVehicleFromGarage, true)
            SetEntityCollision(LastVehicleFromGarage,false)
            SetVehicleDirtLevel(LastVehicleFromGarage, 0.0)
            --SetVehicleProp(LastVehicleFromGarage, props)
            currentcar = LastVehicleFromGarage
            if currentcar ~= LastVehicleFromGarage then
                ReqAndDelete(LastVehicleFromGarage)
            end
            SetModelAsNoLongerNeeded(hash)
            --SetEntityAlpha(PlayerPedId(),1,true)
            SetVehicleEngineOn(LastVehicleFromGarage,true,true,false)
            --TaskWarpPedIntoVehicle(PlayerPedId(), LastVehicleFromGarage, -1)
            inShowRoom('enter')
        end
    end
end

RegisterNUICallback("SpawnVehicle",function(data, cb)
    if not Config.Quickpick and type == 'car' then
        SpawnVehicleLocal(data.modelcar)
    end
end)

RegisterNetEvent('renzu_vehicleshop:buyvehicle')
AddEventHandler('renzu_vehicleshop:buyvehicle', function(model,shop,payment,notregister)
    local data = {
        modelcar = GetHashKey(model),
        model = model,
        payment = 'cash',
        shop = shop
    }
    BuyVehicle(data,notregister)
end)

function BuyVehicle(data,notregister)
    local ped = PlayerPedId()
    local props = nil
    local veh = nil
    local v = nil
    local hash = tonumber(data.modelcar)
    local count = 0
    ReqAndDelete(LastVehicleFromGarage)
    DoScreenFadeOut(100)
    TriggerServerCallback_("renzu_vehicleshop:GenPlate",function(plate)
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            RequestModel(hash)
            Citizen.Wait(1)
        end
        SetEntityCoords(PlayerPedId(), VehicleShop[data.shop].shop_x,VehicleShop[data.shop].shop_y,VehicleShop[data.shop].shop_z, false, false, false, true)
        Wait(0)
        v = CreateVehicle(hash, VehicleShop[data.shop].spawn_x,VehicleShop[data.shop].spawn_y,VehicleShop[data.shop].spawn_z, VehicleShop[data.shop].heading, 1, 1)
        veh = v
        while not DoesEntityExist(veh) do Wait(10) end
        SetVehicleNumberPlateText(v,string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'))
        if presetprimarycolor ~= nil and presetprimarycolor.r ~= nil then
            SetVehicleCustomPrimaryColour(v,tonumber(presetprimarycolor.r),tonumber(presetprimarycolor.g),tonumber(presetprimarycolor.b))
        end
        if presetsecondarycolor ~= nil and presetsecondarycolor.r ~= nil then
            SetVehicleCustomSecondaryColour(v,tonumber(presetsecondarycolor.r),tonumber(presetsecondarycolor.g),tonumber(presetsecondarycolor.b))
        end
        if GetVehicleLiveryCount(vehicle) ~= -1 and livery ~= nil then
            SetVehicleLivery(v,livery)
        elseif livery ~= nil then
            SetVehicleMod(v, 48, livery, false)
        end
        props = GetVehicleProperties(v)
        props.plate = tostring(plate)
        SetEntityAlpha(v, 51, false)
        TaskWarpPedIntoVehicle(PlayerPedId(), v, -1)
        local successbuy = false
        TriggerServerCallback_("renzu_vehicleshop:buyvehicle",function(canbuy)
            if canbuy then
                successbuy = canbuy
                for k,v in pairs(VehicleShop) do
                    local dist = #(vector3(v.spawn_x,v.spawn_y,v.spawn_z) - GetEntityCoords(PlayerPedId()))
                    if dist <= 70.0 and id == k then
                        DoScreenFadeOut(333)
                        ReqAndDelete(LastVehicleFromGarage)
                        Citizen.Wait(333)
                        SetEntityCoords(PlayerPedId(), v.shop_x,v.shop_y,v.shop_z, false, false, false, true)
                        SetVehicleProp(veh, props)
                        DoScreenFadeIn(111)
                        NetworkFadeInEntity(veh,1)
                    end
                end

                LastVehicleFromGarage = nil
                CloseNui()
                ShowNotification("Purchase Success: Plate: "..props.plate.."")
                SetEntityAlpha(v, 255, false)
                TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
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
                presetsecondarycolor = {}
                presetprimarycolor = {}
                livery = nil
                SetVehicleDirtLevel(veh, 0.0)
            else
                CloseNui()
                ReqAndDelete(v)
            end
        end, data.model, props, data.payment, jobcar, type, garage, notregister)
        local counter = 0
        while not successbuy and counter < 5 do counter = counter + 1 Wait (1000) end
        if not successbuy then
            CloseNui()
            ReqAndDelete(v)
        end
        DoScreenFadeIn(1000)
    end,VehicleShop[data.shop].plateprefix or false)
    Wait(3000)
    DoScreenFadeIn(1000)
end

RegisterNUICallback(
    "BuyVehicleCallback",
    function(data, cb)
        BuyVehicle(data)
    end
)

local testdrive = false
RegisterNUICallback(
    "TestDriveCallback",
    function(data, cb)
        local ped = PlayerPedId()
        local props = nil
        local veh = nil
        local v = nil
        local hash = tonumber(data.modelcar)
        local count = 0
        if Config.EnableTestDrive and type ~= 'plane' then
            testdrive = true
            if Config.UseArenaSpawn and type == 'car' then
                CloseNui()
                LoadArena()
                DoScreenFadeOut(0)
                while Config.UseArenaSpawn and not IsIplActive("xs_arena_interior") do Wait(0) end
                while not HasCollisionLoadedAroundEntity(ped) do Wait(0) DoScreenFadeOut(0) end
                Wait(1000)
            else
                while not HasCollisionLoadedAroundEntity(ped) do Wait(0) end
            end
            ReqAndDelete(LastVehicleFromGarage)
            RequestModel(hash)
            if not HasModelLoaded(hash) then
                RequestModel(hash)
                while not HasModelLoaded(hash) do
                    Citizen.Wait(1)
                end
            end
            TriggerServerCallback_("renzu_vehicleshop:GenPlate",function(plate)
                local vec = {}
                if Config.UseArenaSpawn and type == 'car' then
                    vec = vector4(2954.2451171875,-3730.5334472656,140.69311523438,47.894153594971)
                else
                    vec = vector4(VehicleShop[data.shop].spawn_x,VehicleShop[data.shop].spawn_y,VehicleShop[data.shop].spawn_z,VehicleShop[data.shop].heading)
                end
                v = CreateVehicle(tonumber(data.modelcar), vec.x,vec.y,vec.z, vec.w, 1, 1)
                veh = v
                while not DoesEntityExist(v) do Wait(1) end
                if presetprimarycolor ~= nil and presetprimarycolor.r ~= nil then
                    SetVehicleCustomPrimaryColour(v,tonumber(presetprimarycolor.r),tonumber(presetprimarycolor.g),tonumber(presetprimarycolor.b))
                end
                if presetsecondarycolor ~= nil and presetsecondarycolor.r ~= nil then
                    SetVehicleCustomSecondaryColour(v,tonumber(presetsecondarycolor.r),tonumber(presetsecondarycolor.g),tonumber(presetsecondarycolor.b))
                end
                if GetVehicleLiveryCount(vehicle) ~= -1 and livery ~= nil then
                    SetVehicleLivery(v,livery)
                elseif livery ~= nil then
                    SetVehicleMod(v, 48, livery, false)
                end
                SetVehicleNumberPlateText(v,plate)
                props = GetVehicleProperties(v)
                props.plate = plate
                SetEntityAlpha(v, 51, false)
                LastVehicleFromGarage = nil
                TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
                DoScreenFadeIn(3000)
                ShowNotification("Test Drive: Start")
                SetEntityAlpha(v, 255, false)
                SetVehicleProp(v,props)
                FreezeEntityPosition(PlayerPedId(),false)
                TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
                SetVehicleDirtLevel(veh, 0.0)
                --SetVehicleEngineHealth(v,props.engineHealth)
                --Wait(100)
                --SetVehicleStatus(GetVehiclePedIsIn(PlayerPedId()))
                i = 0
                min = 0
                max = 10
                plus = 0
                drawtext = false
                oldcoord = vector3(VehicleShop[data.shop].shop_x,VehicleShop[data.shop].shop_y,VehicleShop[data.shop].shop_z)
                indist = false
                if not Config.UseArenaSpawn or Config.UseArenaSpawn and type ~= 'car' then CloseNui() end
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
                    --ShowNotification("Seconds Left: "..count)
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
                if Config.UseArenaSpawn then UnloadArena() end
                SetEntityCoords(PlayerPedId(),oldcoord)
                while not HasCollisionLoadedAroundEntity(PlayerPedId()) do Wait(0) end
                FreezeEntityPosition(PlayerPedId(),false)
                testdrive = false
                presetsecondarycolor = {}
                presetprimarycolor = {}
                livery = nil
            end)
        else
            SendNUIMessage(
            {
                type = "notify",
                typenotify = 'error',
                message = "Test Driving is Disable",
                }
            ) 
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
            if id == v.name then
                FreezeEntityPosition(PlayerPedId(),true)
                SetEntityCoords(ped, v.shop_x,v.shop_y,v.shop_z, 0, 0, 0, false)  
                while not HasCollisionLoadedAroundEntity(PlayerPedId()) do Wait(0) end
                FreezeEntityPosition(PlayerPedId(),false)
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
    inShowRoom('exit')
    if inGarage then
        if LastVehicleFromGarage ~= nil then
            ReqAndDelete(LastVehicleFromGarage)
        end

        local ped = PlayerPedId()     
        RenderScriptCams(false)
        DestroyAllCams(true)
        ClearFocus()
        DisplayHud(true)
        DisplayRadar(true)
    end
    if Config.UseArenaSpawn then
        UnloadArena()
    end

    inGarage = false
    DeleteGarage()
    drawtext = false
    indist = false
    FreezeEntityPosition(PlayerPedId(),false)
    if not testdrive then
        presetsecondarycolor = {}
        presetprimarycolor = {}
        livery = nil
    end
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

AddEventHandler("onResourceStop",function(resourceName)
    if resourceName == GetCurrentResourceName() then
        CloseNui()
    end
end)

Citizen.CreateThread(function() --load IPL for Vehicleshop
    Wait(1000)
    CloseNui()
	RequestIpl('shr_int')

	local interiorID = 7170
	LoadInterior(interiorID)
	EnableInteriorProp(interiorID, 'csr_beforeMission')
	RefreshInterior(interiorID)
end)






---------------------------------------------------------------------------------------
--            Arena Resource by Titch2000 You may edit but please keep credit.
---------------------------------------------------------------------------------------
-- config
local map = 9
local scene = "scifi"


--         NO TOUCHING BELOW THIS POINT, NO HELP WILL BE OFFERED IF YOU DO.
---------------------------------------------------------------------------------------
local maps = {
    ["dystopian"] = {
        "Set_Dystopian_01",
        "Set_Dystopian_02",
        "Set_Dystopian_03",
        "Set_Dystopian_04",
        "Set_Dystopian_05",
        "Set_Dystopian_06",
        "Set_Dystopian_07",
        "Set_Dystopian_08",
        "Set_Dystopian_09",
        "Set_Dystopian_10",
        "Set_Dystopian_11",
        "Set_Dystopian_12",
        "Set_Dystopian_13",
        "Set_Dystopian_14",
        "Set_Dystopian_15",
        "Set_Dystopian_16",
        "Set_Dystopian_17"
    },

    ["scifi"] = {
        "Set_Scifi_01",
        "Set_Scifi_02",
        "Set_Scifi_03",
        "Set_Scifi_04",
        "Set_Scifi_05",
        "Set_Scifi_06",
        "Set_Scifi_07",
        "Set_Scifi_08",
        "Set_Scifi_09",
        "Set_Scifi_10"
    },

    ["wasteland"] = {
        "Set_Wasteland_01",
        "Set_Wasteland_02",
        "Set_Wasteland_03",
        "Set_Wasteland_04",
        "Set_Wasteland_05",
        "Set_Wasteland_06",
        "Set_Wasteland_07",
        "Set_Wasteland_08",
        "Set_Wasteland_09",
        "Set_Wasteland_10"
    }
}


function UnloadArena()
    RemoveIpl('xs_arena_interior')
end

function LoadArena()
        -- New Arena : 2800.00, -3800.00, 100.00
        RequestIpl("xs_arena_interior")

        -- The below are additional interiors / maps relating to this DLC play around with them at your own risk and want.
        --RequestIpl("xs_arena_interior_mod")
        --RequestIpl("xs_arena_interior_mod_2")
        RequestIpl("xs_arena_interior_vip") -- This is the interior bar for VIP's
        --RequestIpl("xs_int_placement_xs")
        RequestIpl("xs_arena_banners_ipl")
        --RequestIpl("xs_mpchristmasbanners")
        --RequestIpl("xs_mpchristmasbanners_strm_0")

        -- Lets get and save our interior ID for use later
        local interiorID = GetInteriorAtCoords(2800.000, -3800.000, 100.000)

        -- now lets check the interior is ready if not lets just wait a moment
        if (not IsInteriorReady(interiorID)) then
            Wait(1)
        end
        -- We need to add the crowds as who does stuff on their own for nobody?
        EnableInteriorProp(interiorID, "Set_Crowd_A")
        EnableInteriorProp(interiorID, "Set_Crowd_B")
        EnableInteriorProp(interiorID, "Set_Crowd_C")
        EnableInteriorProp(interiorID, "Set_Crowd_D")

        -- now lets set our map type and scene.
        if (scene == "dystopian") then
            EnableInteriorProp(interiorID, "Set_Dystopian_Scene")
            EnableInteriorProp(interiorID, maps[scene][map])
        end
        if (scene == "scifi") then
            EnableInteriorProp(interiorID, "Set_Scifi_Scene")
            EnableInteriorProp(interiorID, maps[scene][map])
        end
        if (scene == "wasteland") then
            EnableInteriorProp(interiorID, "Set_Wasteland_Scene")
            EnableInteriorProp(interiorID, maps[scene][map])
        end
end