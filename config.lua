Config = {}
Config.Locale = "en"
Config.Mysql = 'ghmattisql' -- "ghmattisql", "mysql-async"
Config.UseRayZone = false -- unrelease script https://github.com/renzuzu/renzu_rayzone
Config.UsePopUI = true -- Create a Thread for checking playercoords and Use POPUI to Trigger Event, set this to false if using rayzone. Popui is originaly built in to RayZone -- DOWNLOAD https://github.com/renzuzu/renzu_popui
Config.Quickpick = true -- if false system will create a garage shell and spawn every vehicle you preview
Config.EnableTestDrive = true
Config.PlateSpace = true -- enable / disable plate spaces (compatibility with esx 1.1?)
Config.SaveJob = true -- this config is to save the value to owned_vehicles.job column
VehicleShop = {
    ['pdm'] = { -- same with name
        name = "pdm", --LEGION
        title = "PDM Vehicle Shop",
        type = 'car',
        job = 'all',
        Dist = 7, -- distance (DEPRECATED)
        Blip = {color = 38, sprite = 595, scale = 0.9},
        shop_x = -35.469879150391,
        shop_y = -1100.3621826172,
        shop_z = 26.422359466553, -- coordinates for this garage
        spawn_x = -32.283363342285,
        spawn_y = -1091.0841064453,
        spawn_z = 25.749485015869,
        heading = 340.23065185547 -- Vehicle spawn location
    },

    ['Police Vehicle Shop'] = { -- same with name
        name = "Police Vehicle Shop", --MRPD police shop
        job = 'police',
        type = 'car',
        Dist = 7, -- distance (DEPRECATED)
        Blip = {color = 38, sprite = 662, scale = 0.9},
        shop_x = 456.89453125,
        shop_y = -1020.8922729492,
        shop_z = 28.290912628174, -- coordinates for this garage
        spawn_x = 449.27224731445,
        spawn_y = -1025.3255615234,
        spawn_z = 27.905115127563,
        heading = 2.6015937328339, -- Vehicle spawn location
        shop = { -- if not vehicle is setup in Database SQL, we will use this
            {shop='Police Vehicle Shop',category='Police Sedan',stock=50,price=100000,model='police',name="Police Car"},
            {shop='Police Vehicle Shop',category='Police Sedan',stock=50,price=100000,model='police2',name="Police 2"},
            {shop='Police Vehicle Shop',category='Police Sedan',stock=50,price=100000,model='police4',name="Police 4"},
            {shop='Police Vehicle Shop',category='Police SUVs',stock=50,price=100000,model='police3',name="Police SUV"},
        },
    },

    -- BOAT shop
    ['Yacht Club Boat Shop'] = { -- same with name
        name = "Yacht Club Boat Shop", --LEGION
        type = 'boat', -- type of shop
        job = 'all',
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
            {shop='Yacht Club Boat Shop',category='Normal Boat',stock=50,price=50000,model='dinghy',name="Dinghy"},
            {shop='Yacht Club Boat Shop',category='Normal Boat',stock=50,price=100000,model='dinghy2',name="Dinghy2"},
            {shop='Yacht Club Boat Shop',category='Normal Boat',stock=50,price=100000,model='dinghy3',name="Dinghy 3"},
            {shop='Yacht Club Boat Shop',category='Normal Boat',stock=50,price=100000,model='dinghy4',name="Dinghy4"},
            {shop='Yacht Club Boat Shop',category='Rich Boat',stock=50,price=100000,model='marquis',name="Marquiz"},
            {shop='Yacht Club Boat Shop',category='Rich Boat',stock=50,price=100000,model='toro2',name="Toro 2"},
            {shop='Yacht Club Boat Shop',category='Submarine',stock=50,price=100000,model='submersible',name="Submersible"},
            {shop='Yacht Club Boat Shop',category='Submarine',stock=50,price=100000,model='submersible2',name="Submersible2"},
        },
    },
    -- PLANE SHOP
    ['DEVIN WESTON PLANE SHOP'] = { -- same with name
        name = "DEVIN WESTON PLANE SHOP", --LEGION
        title = "DEVIN PLANE SHOP",
        type = 'plane', -- type of shop
        job = 'all',
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
            {shop='DEVIN WESTON PLANE SHOP',category='Military',stock=50,price=50000,model='hydra',name="Hydra"},
            {shop='DEVIN WESTON PLANE SHOP',category='Military',stock=50,price=100000,model='titan',name="Titan"},
            {shop='DEVIN WESTON PLANE SHOP',category='Private Plane',stock=50,price=100000,model='luxor2',name="Luxor 2"},
            {shop='DEVIN WESTON PLANE SHOP',category='Private Plane',stock=50,price=100000,model='luxor',name="Luxor"},
            {shop='DEVIN WESTON PLANE SHOP',category='Private Plane',stock=50,price=100000,model='nimbus',name="Nimbus"},
            {shop='DEVIN WESTON PLANE SHOP',category='Propeller Type',stock=50,price=100000,model='dodo',name="Dodo"},
            {shop='DEVIN WESTON PLANE SHOP',category='Propeller Type',stock=50,price=100000,model='duster',name="Duster"},
            {shop='DEVIN WESTON PLANE SHOP',category='Propeller Type',stock=50,price=100000,model='nokota',name="Nokota"},
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
