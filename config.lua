Config = {}
Config.Locale = "en"
Config.UseRayZone = false -- unrelease script https://github.com/renzuzu/renzu_rayzone
Config.UsePopUI = true -- Create a Thread for checking playercoords and Use POPUI to Trigger Event, set this to false if using rayzone. Popui is originaly built in to RayZone -- DOWNLOAD https://github.com/renzuzu/renzu_popui
Config.Quickpick = false -- if false system will create a garage shell and spawn every vehicle you preview
VehicleShop = {
    ['pdm'] = { -- same with name
        name = "pdm", --LEGION
        job = 'all',
        Dist = 7, -- distance (DEPRECATED)
        Blip = {color = 38, sprite = 219, scale = 0.6},
        shop_x = -35.469879150391,
        shop_y = -1100.3621826172,
        shop_z = 26.422359466553, -- coordinates for this garage
        spawn_x = -32.283363342285,
        spawn_y = -1091.0841064453,
        spawn_z = 25.749485015869,
        heading = 340.23065185547 -- Vehicle spawn location
    },

    ['police'] = { -- same with name
        name = "police", --MRPD police shop
        job = 'police',
        Dist = 7, -- distance (DEPRECATED)
        Blip = {color = 38, sprite = 229, scale = 0.6},
        shop_x = 456.89453125,
        shop_y = -1020.8922729492,
        shop_z = 28.290912628174, -- coordinates for this garage
        spawn_x = 449.27224731445,
        spawn_y = -1025.3255615234,
        spawn_z = 27.905115127563,
        heading = 2.6015937328339, -- Vehicle spawn location
        shop = { -- if not vehicle is setup in Database SQL, we will use this
            {shop='police',category='Police Sedan',stock=50,price=100000,model='police',name="Police Car"},
            {shop='police',category='Police Sedan',stock=50,price=100000,model='police2',name="Police 2"},
            {shop='police',category='Police Sedan',stock=50,price=100000,model='police4',name="Police 4"},
            {shop='police',category='Police SUVs',stock=50,price=100000,model='police3',name="Police SUV"},
        },
    },
}
