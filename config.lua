Config = {}
Config.Locale = "en"
Config.Mysql = 'oxmysql' -- "ghmattisql", "mysql-async", "oxmysql"
Config.framework = 'ESX' -- ESX or QBCORE
Config.UsePopUI = true -- Create a Thread for checking playercoords and Use POPUI to Trigger Event, set this to false if using rayzone. Popui is originaly built in to RayZone -- DOWNLOAD https://github.com/renzuzu/renzu_popui
Config.Quickpick = false -- if false system will create a garage shell and spawn every vehicle you preview
Config.EnableTestDrive = true
Config.PlateSpace = true -- enable / disable plate spaces (compatibility with esx 1.1?)
Config.SaveJob = true -- this config is to save the value to owned_vehicles.job column
Config.Licensed = false -- Enable Driver Licensed Checker
Config.DisplayCars = true -- enable display of cars
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
Config.UseArenaSpawn = true -- will use custom location for spawning vehicle in quickpick == false
-- MAIN
VehicleShop = {
    ['pdm'] = { -- same with name
        name = "pdm", --LEGION
        title = "PDM Vehicle Shop",
        icon = 'https://i.imgur.com/05SLYUP.png',
        type = 'car',
        job = 'all',
        default_garage = 'A',
        Dist = 4, -- distance (DEPRECATED)
        Blip = {color = 38, sprite = 595, scale = 0.9},
        shop_x = -35.469879150391,
        shop_y = -1100.3621826172,
        shop_z = 26.422359466553, -- coordinates for this garage
        spawn_x = -32.283363342285,
        spawn_y = -1091.0841064453,
        spawn_z = 25.749485015869,
        heading = 340.23065185547, -- Vehicle spawn location,
        displaycars = {
            [1] = {model = 'jester3', value = 100000, coord = vector4(-47.427722930908,-1101.3747558594,25.714616775513,341.64694213867)},
            [2] = {model = 'fmj', value = 1000000, coord = vector4(-44.736125946045,-1094.1976318359,25.748092651367,158.2547454834)},
            [3] = {model = 'adder', value = 1000000, coord = vector4(-40.32751083374,-1095.6105957031,26.009906768799,158.58676147461)},
            [4] = {model = 'zentorno', value = 1000000, coord = vector4(-43.318450927734,-1102.1627197266,25.758722305298,340.29724121094)},
        }
    },

    ['Police Vehicle Shop'] = { -- same with name
        name = "Police Vehicle Shop", --MRPD police shop
        title = "Police Vehicle Shop",
        icon = 'https://i.imgur.com/t1OPuVL.png',
        job = 'police',
        type = 'carshop',
        default_garage = 'Police Garage',
        Dist = 3, -- distance (DEPRECATED)
        Blip = {color = 38, sprite = 662, scale = 0.9},
        shop_x = 456.89453125,
        shop_y = -1020.8922729492,
        shop_z = 28.290912628174, -- coordinates for this garage
        spawn_x = 449.27224731445,
        spawn_y = -1025.3255615234,
        spawn_z = 27.905115127563,
        heading = 2.6015937328339, -- Vehicle spawn location
        plateprefix = 'LSPD', -- carefull using this, maximum should be 4, recommended is 3, use this only for limited vehicles, if you use this parameter in other shop, you might have a limited plates available, ex. LSPD1234 (max char of plate is 8) it means you only have 9999 vehicles possible with this LSPD
        shop = { -- if not vehicle is setup in Database SQL, we will use this
            {shop='Police Vehicle Shop',brand='Police Sedan',stock=50,price=100000,model='police',name="Police Car", grade = 1},
            {shop='Police Vehicle Shop',brand='Police Sedan',stock=50,price=100000,model='police2',name="Police 2", grade = 1},
            {shop='Police Vehicle Shop',brand='Police Sedan',stock=50,price=100000,model='police4',name="Police 4", grade = 3},
            {shop='Police Vehicle Shop',brand='Police SUVs',stock=50,price=100000,model='police3',name="Police SUV",grade = 5},
        },
    },

    -- BOAT shop
    ['Yacht Club Boat Shop'] = { -- same with name
        name = "Yacht Club Boat Shop", --LEGION
        type = 'boat', -- type of shop
        title = "Yacht Club Boat Shop",
        icon = 'https://i.imgur.com/62bRdH6.png',
        job = 'all',
        default_garage = 'Boat Garage A',
        Dist = 7, -- distance (DEPRECATED)
        Blip = {color = 38, sprite = 410, scale = 0.9},
        shop_x = -812.87133789062,
        shop_y = -1407.4493408203,
        shop_z = 5.0005192756653, -- coordinates for this garage
        spawn_x = -818.69775390625,
        spawn_y = -1420.5775146484,
        spawn_z = 0.12045155465603,
        heading = 178.27006530762, -- Vehicle spawn location
        shop = { -- if not vehicle is setup in Database SQL, we will use this
            {shop='Yacht Club Boat Shop',brand='Normal Boat',stock=50,price=50000,model='dinghy',name="Dinghy"},
            {shop='Yacht Club Boat Shop',brand='Normal Boat',stock=50,price=100000,model='dinghy2',name="Dinghy2"},
            {shop='Yacht Club Boat Shop',brand='Normal Boat',stock=50,price=100000,model='dinghy3',name="Dinghy 3"},
            {shop='Yacht Club Boat Shop',brand='Normal Boat',stock=50,price=100000,model='dinghy4',name="Dinghy4"},
            {shop='Yacht Club Boat Shop',brand='Rich Boat',stock=50,price=100000,model='marquis',name="Marquiz"},
            {shop='Yacht Club Boat Shop',brand='Rich Boat',stock=50,price=100000,model='toro2',name="Toro 2"},
            {shop='Yacht Club Boat Shop',brand='Submarine',stock=50,price=100000,model='submersible',name="Submersible"},
            {shop='Yacht Club Boat Shop',brand='Submarine',stock=50,price=100000,model='submersible2',name="Submersible2"},
        },
    },
    -- PLANE SHOP
    ['DEVIN WESTON PLANE SHOP'] = { -- same with name
        name = "DEVIN WESTON PLANE SHOP", --LEGION
        title = "DEVIN PLANE SHOP",
        icon = 'https://i.imgur.com/12rKk6E.png',
        type = 'air', -- type of shop
        job = 'all',
        default_garage = 'Plane Hangar A',
        Dist = 7, -- distance (DEPRECATED)
        Blip = {color = 38, sprite = 423, scale = 0.9},
        shop_x = -916.04522705078,
        shop_y = -3025.2377929688,
        shop_z = 13.945063591003, -- coordinates for this garage
        spawn_x = -985.01806640625,
        spawn_y = -3005.4670410156,
        spawn_z = 14.783501625061,
        heading = 54.631553649902, -- Vehicle spawn location
        shop = { -- if not vehicle is setup in Database SQL, we will use this
            {shop='DEVIN WESTON PLANE SHOP',brand='Military',stock=50,price=50000,model='hydra',name="Hydra"},
            {shop='DEVIN WESTON PLANE SHOP',brand='Military',stock=50,price=100000,model='titan',name="Titan"},
            {shop='DEVIN WESTON PLANE SHOP',brand='Private Plane',stock=50,price=100000,model='luxor2',name="Luxor 2"},
            {shop='DEVIN WESTON PLANE SHOP',brand='Private Plane',stock=50,price=100000,model='luxor',name="Luxor"},
            {shop='DEVIN WESTON PLANE SHOP',brand='Private Plane',stock=50,price=100000,model='nimbus',name="Nimbus"},
            {shop='DEVIN WESTON PLANE SHOP',brand='Propeller Type',stock=50,price=100000,model='dodo',name="Dodo"},
            {shop='DEVIN WESTON PLANE SHOP',brand='Propeller Type',stock=50,price=100000,model='duster',name="Duster"},
            {shop='DEVIN WESTON PLANE SHOP',brand='Propeller Type',stock=50,price=100000,model='nokota',name="Nokota"},
        },
    },
}

Config.EnableVehicleSelling = true -- allow your user to sell the vehicle and deletes it from database
Config.RefundPercent = 70 -- 70% (percentage from original value)
Refund = {
    ['pdm'] = { -- same with name
        name = "pdm", --LEGION
        job = 'all',
        Dist = 7, -- distance
        Blip = {color = 38, sprite = 219, scale = 0.6},
        shop_x = -46.320140838623,
        shop_y = -1095.1837158203,
        shop_z = 25.91579246521, -- coordinates for selling / refunding the vehicle
    },
}

lib = nil

function TryOxLib(file)
    local fcall = function()
        local name = ('%s.lua'):format(file)
        local content = LoadResourceFile('ox_lib',name)
        local f, err = load(content)
        return f()
    end
    _, ret = pcall(fcall,false)
    return ret
end