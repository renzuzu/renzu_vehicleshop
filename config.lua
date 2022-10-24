Config = {}
Config.Locale = "en"
Config.Mysql = 'mysql-async' -- "ghmattisql", "mysql-async", "oxmysql"
Config.framework = 'ESX' -- ESX or QBCORE
Config.UseRayZone = false -- unrelease script https://github.com/renzuzu/renzu_rayzone
Config.UsePopUI = true -- Create a Thread for checking playercoords and Use POPUI to Trigger Event, set this to false if using rayzone. Popui is originaly built in to RayZone -- DOWNLOAD https://github.com/renzuzu/renzu_popui
Config.Quickpick = false -- if false system will create a garage shell and spawn every vehicle you preview
Config.EnableTestDrive = true
Config.PlateSpace = true -- enable / disable plate spaces (compatibility with esx 1.1?)
Config.SaveJob = true -- this config is to save the value to owned_vehicles.job column
Config.Licensed = true -- Enable Driver Licensed Checker
Config.DisplayCars = false -- enable display of cars
Config.Marker = true -- use draw marker and Iscontrollpress native , popui will not work if this is true

-- VEHICLE THUMBNAILS IMAGE
-- this is standalone
Config.CustomImg = false -- if true your Config.CustomImgColumn IMAGE url will be used for each vehicles else, the imgs/uploads/MODEL.jpg
Config.CustomImgColumn = 'imglink' -- db column name
-- this is standalone
-- Config.use_renzu_vehthumb -- Config.CustomImg must be false
Config.use_renzu_vehthumb = false -- use vehicle thumb generation script
Config.RgbColor = true -- your framework or garage must support custom colors ex. https://github.com/renzuzu/renzu_garage

-- CARKEYS -- -- you need to replace the event
Config.Carkeys = function(plate,source)
    print("Sending Keys")
    TriggerClientEvent('vehiclekeys:client:SetOwner',source,plate) -- THIS EVENT IS QBCORE CAR KEYS!, replace the event name to your carkeys event
end
-- CARKEYS --
--EXTRA
Config.UseArenaSpawn = false -- will use custom location for spawning vehicle in quickpick == false
-- MAIN
VehicleShop = {
    ['Premium Deluxe Motorsport'] = { -- same with name
        name = "Premium Deluxe Motorsport", --LEGION
        title = "Premium Deluxe Motorsport",
        icon = 'https://i.imgur.com/05SLYUP.png',
        type = 'car',
        job = 'all',
        default_garage = 'A',
        Dist = 4, -- distance (DEPRECATED)
        Blip = {color = 0, sprite = 669, scale = 0.7},
        shop_x = -35.469879150391,
        shop_y = -1100.3621826172,
        shop_z = 26.422359466553, -- coordinates for this garage
        spawn_x = -32.283363342285,
        spawn_y = -1091.0841064453,
        spawn_z = 25.749485015869,
        heading = 340.23065185547, -- Vehicle spawn location,
        displaycars = {
            [1] = {model = 'blista', value = 10000, coord = vector4(-47.427722930908,-1101.3747558594,25.714616775513,341.64694213867)},
            [2] = {model = 'blista', value = 10000, coord = vector4(-44.736125946045,-1094.1976318359,25.748092651367,158.2547454834)},
            [3] = {model = 'blista', value = 10000, coord = vector4(-40.32751083374,-1095.6105957031,26.009906768799,158.58676147461)},
            [4] = {model = 'blista', value = 10000, coord = vector4(-43.318450927734,-1102.1627197266,25.758722305298,340.29724121094)},
        }
    },

    ['Police Vehicle Shop'] = { -- same with name
        name = "LSPD - Sluzebni vozidla", --MRPD police shop
        title = "LSPD - Sluzebni vozidla",
        icon = 'https://i.imgur.com/t1OPuVL.png',
        job = 'police',
        type = 'carshop',
        default_garage = 'Police Garage',
        Dist = 3, -- distance (DEPRECATED)
        Blip = {color = 38, sprite = 56, scale = 0},
        shop_x = 456.89453125,
        shop_y = -1020.8922729492,
        shop_z = 28.290912628174, -- coordinates for this garage
        spawn_x = 449.27224731445,
        spawn_y = -1025.3255615234,
        spawn_z = 27.905115127563,
        heading = 2.6015937328339, -- Vehicle spawn location
        plateprefix = 'LSPD', -- carefull using this, maximum should be 4, recommended is 3, use this only for limited vehicles, if you use this parameter in other shop, you might have a limited plates available, ex. LSPD1234 (max char of plate is 8) it means you only have 9999 vehicles possible with this LSPD
        shop = { -- if not vehicle is setup in Database SQL, we will use this
			{shop='Police Vehicle Shop',category='MOTORKY',stock=50,price=1,model='policeb',name="Police Bike", grade = 3},			
            {shop='Police Vehicle Shop',category='POLICE',stock=50,price=1,model='police',name="Police Cruiser", grade = 1},
            {shop='Police Vehicle Shop',category='POLICE',stock=50,price=1,model='police3',name="Police Cruiser", grade = 1},
            {shop='Police Vehicle Shop',category='POLICE',stock=50,price=1,model='police2',name="Police Buffalo", grade = 3},
			{shop='Police Vehicle Shop',category='POLICE',stock=50,price=1,model='policet',name="Police Transporter", grade = 3},
			{shop='Police Vehicle Shop',category='POLICE',stock=50,price=1,model='riot',name="Riot", grade = 3},
			{shop='Police Vehicle Shop',category='POLICE',stock=50,price=1,model='riot2',name="Riot 2", grade = 3},
			{shop='Police Vehicle Shop',category='POLICE BUS',stock=50,price=1,model='pbus',name="Bus", grade = 3},		
            {shop='Police Vehicle Shop',category='UNMARKED',stock=50,price=1,model='police4',name="Unmarked Cruiser",grade = 4},
			{shop='Police Vehicle Shop',category='UNMARKED',stock=50,price=1,model='fbi',name="Unmarked Buffalo",grade = 4},
			{shop='Police Vehicle Shop',category='UNMARKED',stock=50,price=1,model='fbi2',name="Unmarked Grander",grade = 4},
        },
    },
	['Sheriff Vehicle Shop'] = { -- same with name
        name = "LSSD - Sluzebni vozidla", --MRPD police shop
        title = "LSSD - Sluzebni vozidla",
        icon = 'https://i.imgur.com/t1OPuVL.png',
        job = 'sheriff',
        type = 'carshop',
        default_garage = 'Sheriff Garage',
        Dist = 3, -- distance (DEPRECATED)
        Blip = {color = 71, sprite = 56, scale = 0},
        shop_x = 1861.89453125,
        shop_y = 3686.8922729492,
        shop_z = 34.290912628174, -- coordinates for this garage
        spawn_x = 1862.76,
        spawn_y = 3680.22,
        spawn_z = 33.29,
        heading = 211.0, -- Vehicle spawn location
        plateprefix = 'LSSD', -- carefull using this, maximum should be 4, recommended is 3, use this only for limited vehicles, if you use this parameter in other shop, you might have a limited plates available, ex. LSPD1234 (max char of plate is 8) it means you only have 9999 vehicles possible with this LSPD
        shop = { -- if not vehicle is setup in Database SQL, we will use this
            {shop='Sheriff Vehicle Shop',category='MOTORKY',stock=50,price=1,model='policeb',name="Sheriff Bike", grade = 3},			
            {shop='Sheriff Vehicle Shop',category='SHERIFF',stock=50,price=1,model='sheriff',name="Sheriff Cruiser", grade = 1},
            {shop='Sheriff Vehicle Shop',category='SHERIFF',stock=50,price=1,model='sheriff2',name="Sheriff SUV", grade = 1},
			{shop='Sheriff Vehicle Shop',category='SHERIFF',stock=50,price=1,model='riot',name="Riot", grade = 3},
			{shop='Sheriff Vehicle Shop',category='SHERIFF',stock=50,price=1,model='riot2',name="Riot 2", grade = 3},
			{shop='Sheriff Vehicle Shop',category='SHERIFF BUS',stock=50,price=1,model='pbus',name="Bus", grade = 3},		
            {shop='Sheriff Vehicle Shop',category='UNMARKED',stock=50,price=1,model='police4',name="Unmarked Cruiser",grade = 4},
			{shop='Sheriff Vehicle Shop',category='UNMARKED',stock=50,price=1,model='fbi',name="Unmarked Buffalo",grade = 4},
			{shop='Sheriff Vehicle Shop',category='UNMARKED',stock=50,price=1,model='fbi2',name="Unmarked Grander",grade = 4},
        },
    },
	
	['Ambulance Vehicle Shop'] = { -- same with name
        name = "EMS - Sluzebni vozidla", --MRPD police shop
        title = "EMS - Sluzebni vozidla",
        icon = 'https://i.imgur.com/t1OPuVL.png',
        job = 'ambulance',
        type = 'carshop',
        default_garage = 'Hospital Garage',
        Dist = 3, -- distance (DEPRECATED)
        Blip = {color = 1, sprite = 56, scale = 0},
        shop_x = 335.39,
        shop_y = -589.17,
        shop_z = 28.8, -- coordinates for this garage
        spawn_x = 337.25,
        spawn_y = -579.37,
        spawn_z = 28.57,
        heading = 340.98, -- Vehicle spawn location
        plateprefix = 'EMS', -- carefull using this, maximum should be 4, recommended is 3, use this only for limited vehicles, if you use this parameter in other shop, you might have a limited plates available, ex. LSPD1234 (max char of plate is 8) it means you only have 9999 vehicles possible with this LSPD
        shop = { -- if not vehicle is setup in Database SQL, we will use this
             {shop='Ambulance Vehicle Shop',category='AMBULANCE',stock=50,price=1,model='ambulance',name="Ambulance", grade = 0},	
        },
    },
	
    -- BOAT shop
    ['Yacht Club Boat Shop'] = { -- same with name
        name = "Yacht Club Obchod", --LEGION
        type = 'boat', -- type of shop
        title = "Yacht Club Obchod",
        icon = 'https://i.imgur.com/62bRdH6.png',
        job = 'all',
        default_garage = 'Boat Garage A',
        Dist = 7, -- distance (DEPRECATED)
        Blip = {color = 0, sprite = 780, scale = 0.7},
        shop_x = -757.31,
        shop_y = -1505.09,
        shop_z = 4.85, -- coordinates for this garage
        spawn_x = -811.75,
        spawn_y = -1508.63,
        spawn_z = 2.20,
        heading = 52.0, -- Vehicle spawn location
        shop = { -- if not vehicle is setup in Database SQL, we will use this 
            {shop='Yacht Club Boat Shop',category='Vodni Skutr',stock=50,price=12500,model='seashark',name="Seashark"},
            {shop='Yacht Club Boat Shop',category='Lod',stock=50,price=50000,model='dinghy',name="Dinghy"},
            {shop='Yacht Club Boat Shop',category='Lod',stock=50,price=100000,model='dinghy2',name="Dinghy2"},
            {shop='Yacht Club Boat Shop',category='Lod',stock=50,price=100000,model='dinghy3',name="Dinghy 3"},
            {shop='Yacht Club Boat Shop',category='Lod',stock=50,price=100000,model='dinghy4',name="Dinghy4"},
            {shop='Yacht Club Boat Shop',category='Lod',stock=50,price=100000,model='squalo',name="Squalo"},
            {shop='Yacht Club Boat Shop',category='Lod',stock=50,price=100000,model='suntrap',name="Suntrap"},
            {shop='Yacht Club Boat Shop',category='Lod',stock=50,price=100000,model='tropic',name="Tropic"},
            {shop='Yacht Club Boat Shop',category='Lod',stock=50,price=100000,model='jetmax',name="Jetmax"},
			{shop='Yacht Club Boat Shop',category='Lod',stock=50,price=300000,model='tug',name="Tug"},
            {shop='Yacht Club Boat Shop',category='Gold lode',stock=50,price=100000,model='toro',name="Toro"},
            {shop='Yacht Club Boat Shop',category='Gold lode',stock=50,price=100000,model='longfin',name="Longfin"},
            {shop='Yacht Club Boat Shop',category='Gold lode',stock=50,price=100000,model='speeder',name="Speeder"},
            {shop='Yacht Club Boat Shop',category='Yachta',stock=50,price=85000,model='marquis',name="Marquis"},
            {shop='Yacht Club Boat Shop',category='Submarine',stock=50,price=250000,model='avisa',name="Avisa"},
            {shop='Yacht Club Boat Shop',category='Submarine',stock=50,price=100000,model='submersible',name="Submersible"},
            {shop='Yacht Club Boat Shop',category='Submarine',stock=50,price=100000,model='submersible2',name="Submersible2"},
        },
    },
    -- PLANE SHOP
    ['DEVIN WESTON PLANE SHOP'] = { -- same with name
        name = "Airlines Obchod", --LEGION
        title = "Airlines Obchod",
        icon = 'https://i.imgur.com/12rKk6E.png',
        type = 'air', -- type of shop
        job = 'all',
        default_garage = 'Plane Hangar A',
        Dist = 7, -- distance (DEPRECATED)
        Blip = {color = 0, sprite = 572, scale = 0.8},
        shop_x = -916.04522705078,
        shop_y = -3025.2377929688,
        shop_z = 13.945063591003, -- coordinates for this garage
        spawn_x = -985.01806640625,
        spawn_y = -3005.4670410156,
        spawn_z = 14.783501625061,
        heading = 54.631553649902, -- Vehicle spawn location
        shop = { -- if not vehicle is setup in Database SQL, we will use this
            {shop='DEVIN WESTON PLANE SHOP',category='Helikoptery',stock=50,price=50000,model='maverick',name="Maverick"},
            {shop='DEVIN WESTON PLANE SHOP',category='Helikoptery',stock=50,price=100000,model='frogger',name="Frogger"},
            {shop='DEVIN WESTON PLANE SHOP',category='Helikoptery',stock=50,price=100000,model='swift',name="Swift"},
            {shop='DEVIN WESTON PLANE SHOP',category='Helikoptery',stock=50,price=100000,model='seasparrow',name="Sparrow"},
            {shop='DEVIN WESTON PLANE SHOP',category='Helikoptery',stock=50,price=100000,model='sparrow',name="Sparrow"},
            {shop='DEVIN WESTON PLANE SHOP',category='Helikoptery',stock=50,price=100000,model='supervolito',name="SuperVolito"},
            {shop='DEVIN WESTON PLANE SHOP',category='Helikoptery',stock=50,price=100000,model='volatus',name="Volatus"},
            {shop='DEVIN WESTON PLANE SHOP',category='Helikoptery',stock=50,price=100000,model='havok',name="Havok"},
            {shop='DEVIN WESTON PLANE SHOP',category='Helikoptery',stock=50,price=459000,model='conada',name="Conada"},
            {shop='DEVIN WESTON PLANE SHOP',category='Letadla',stock=50,price=100000,model='duster',name="Duster"},
            {shop='DEVIN WESTON PLANE SHOP',category='Letadla',stock=50,price=100000,model='cuban800',name="Cuban 800"},
            {shop='DEVIN WESTON PLANE SHOP',category='Letadla',stock=50,price=100000,model='mammatus',name="Mammatus"},
            {shop='DEVIN WESTON PLANE SHOP',category='Letadla',stock=50,price=100000,model='velum',name="Velum"},
            {shop='DEVIN WESTON PLANE SHOP',category='Letadla',stock=50,price=100000,model='dodo',name="Dodo"},
            {shop='DEVIN WESTON PLANE SHOP',category='Soukrome letadla',stock=50,price=100000,model='vestra',name="Vestra"},
            {shop='DEVIN WESTON PLANE SHOP',category='Soukrome letadla',stock=50,price=100000,model='seabreeze',name="Seabreeze"},
            {shop='DEVIN WESTON PLANE SHOP',category='Soukrome letadla',stock=50,price=100000,model='shamal',name="Shamal"},
            {shop='DEVIN WESTON PLANE SHOP',category='Soukrome letadla',stock=50,price=100000,model='luxor',name="Luxor"},
            {shop='DEVIN WESTON PLANE SHOP',category='Soukrome letadla',stock=50,price=100000,model='nimbus',name="Nimbus"},
            {shop='DEVIN WESTON PLANE SHOP',category='Soukrome letadla',stock=50,price=100000,model='luxor',name="Luxor"},
        },
    },
}

Config.EnableVehicleSelling = true -- allow your user to sell the vehicle and deletes it from database
Config.RefundPercent = 70 -- 70% (percentage from original value)
Refund = {
    ['pdm'] = { -- same with name
        name = "pdm", --LEGION
        job = 'all',
        Dist = 8, -- distance
        Blip = {color = 38, sprite = 219, scale = 0.6},
        shop_x = -45.59,
        shop_y = -1083.28,
        shop_z = 25.55, -- coordinates for selling / refunding the vehicle
    },
	
	['letadla'] = { -- same with name
        name = "letadla", --LEGION
        job = 'all',
        Dist = 8, -- distance
        Blip = {color = 38, sprite = 219, scale = 0.6},
        shop_x = -941.74,
        shop_y = -3034.62,
        shop_z = 13.95, -- coordinates for selling / refunding the vehicle
    },
	
    ['boats'] = { -- same with name
        name = "boats", --LEGION
        job = 'all',
        Dist = 8, -- distance
        Blip = {color = 38, sprite = 219, scale = 0.6},
        shop_x = -783.43,
        shop_y = -1511.99 ,
        shop_z = 0.31, -- coordinates for selling / refunding the vehicle
    },
}
