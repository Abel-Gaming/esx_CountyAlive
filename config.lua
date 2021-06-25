Config = {}

-- Debug --
Config.EnableDebug = false

-- Ground Marker Settings (Will apply everywhere that a marker is used)
Config.MarkerType = 27 -- Type of marker
Config.xScale = 1.0
Config.yScale = 1.0
Config.zScale = 1.0
Config.MarkerRotate = true -- Rotate the marker (not sure if this affects script time)

-- Ground Marker RGB
Config.MarkerRed = 0
Config.MarkerGreen = 255
Config.MarkerBlue = 0
Config.MarkerAlpha = 155

-- Global Notification Alerts (Both can be enabled)
Config.AlertsUseNotification = true -- Global alerts will use the notification box (above radar)
Config.AlertsUseHelpMessage = false -- Global alerts will use the help message box (top left corner)

-- Hospital
Config.EnableHospitalBlip = true -- Enable the blip on the map
Config.EnablePlayerHealing = true -- Allow players to go and heal themselves
Config.DrawHealingGroundMarker = true -- Draw the ground marker at the healing location (if set to false, only the 3D text will appear)
Config.HospitalBlipSprite = 61 -- Blip Sprite
Config.HospitalBlipColour = 2 -- Blip Color
Config.HospitalBlipScale = 0.75 -- Blip Scale
Config.HospitalHealCoords = vector3(1839.21, 3673.07, 34.28) -- Coords for healing
Config.HospitalHealPrice = 500 -- Price for healing

-- Food Trucks/Trailers
Config.EnableFoodVendors = true -- Allow players to purchase items from food trucks and trailers
Config.FoodVendors = {
    {
        name = 'Chihuahua Hotdogs', -- Name of the blip if enabled
        vendorBlip = true, -- Will draw the blip on the map
        vendorBlipSprite = 266, -- The sprite of the blip
        vendorBlipColour = 56, -- The colour of the blip
        purchaseCoord = vector3(1983.1, 3708.3, 32.12), -- The coord where the player needs to stand to purchase the food. The blip will also be drawn here
        items = -- Items available at the location
        {
            {
                label = 'Bread', -- This will appear in the menu
                item = 'bread', -- This is the item that is added to the inventory of the player
                price = 2 -- This is obviously the price
            },
            {
                label = 'Water',
                item = 'water',
                price = 1
            }
        }
    },
    {
        name = 'Chihuahua Hotdogs',
        vendorBlip = true,
        vendorBlipSprite = 266,
        vendorBlipColour = 56,
        purchaseCoord = vector3(2083.38, 3556.53, 41.98),
        items = 
        {
            {
                label = 'Bread',
                item = 'bread',
                price = 2
            },
            {
                label = 'Water',
                item = 'water',
                price = 1
            }
        }
    }
}

-- Camping
Config.EnableCamping = true -- Allow players to setup camp and experience the great outdoors!

Config.TentModelHash = -596943609
Config.CampFireModelHash = -1065766299
Config.GrillModelHash =  977744387 -- Find more here: http://www.test.raccoon72.ru/?s=bbq
Config.ChairModelHash = 1071807406

Config.UseCommands = false -- If set to false, the menu will be used with all functions inside of it

Config.CampingMenuCommand = 'camping-menu'
Config.StartCampfireCommand = 'set-campfire'
Config.PitchTentCommand = 'set-tent'
Config.PlaceGrillCommand = 'set-grill'

-- Fishing
Config.EnableFishing = true -- If set to false, fishing will not be enabled

Config.EnableFishingCommand = true -- Allows you to fish from anywhere (still will use the preset fishing locations)
Config.FishingCommand = 'fish' -- Allows you to fish from anywhere

Config.EnableFishingBlips = true
Config.FishingBlipSprite = 540
Config.FishingBlipColour = 52 
Config.FishingBlipScale = 0.75

Config.EnableFishingInventory = true -- If set to true, the player will gain fish to their inventory while fishing
Config.FishItem = 'fish' -- Whatever item that needs to be added to the inventory while fishing
Config.FishingCatchCooldown = 20 -- This is in seconds. This is how often fish will be added to the inventory of the player if they are fishing and can carry the item

Config.FishingLocations = { -- The only different in this and the fish command is that these locations will be drawn with blips (if enabled)
    vector3(1732.96, 3986.19, 31.98),
    vector3(1422.82, 3852.66, 32.02)
}

-- Offroad Vehicle Rental
Config.EnableVehicleRental = true -- Allow players to rent vehicles for off-road use near Mt Chiliad (does not insert into any database)

Config.EnableVehicleRentalBlip = true -- Enable a blip for the rental location
Config.EnableVehicleRentalBlipSprite = 532 -- Blip sprite
Config.EnableVehicleRentalBlipColour = 46 -- Blip colour
Config.EnableVehicleRentalBlipScale = 0.75 -- Blip scale

Config.RentalPurchaseCoord = vector3(346.58, 3406.08, 36.48) -- Where to go to open the rental vehicle menu
Config.RentalVehicleSpawnCoord = vector3(311.7, 3382.14, 35.91) -- Where the vehicle will spawn if you rent it
Config.RentalVehicleSpawnHeading = 290.58 -- The heading the vehicle will spawn
Config.RentalVehicleReturnCoord = vector3(359.51, 3422.57, 35.58) -- The location where the return marker will be drawn

Config.RentalVehicles = {
    {
        label = 'ATV', -- This is what will appear on the menu
        spawnCode = 'blazer', -- This is the spawn name of the vehicle
        price = 500 -- This is the price
    },
    {
        label = 'Dirt Bike',
        spawnCode = 'sanchez',
        price = 400
    }
}

-- Hiking
Config.EnableHiking = true

Config.EnableHikingBlip = true
Config.HikingBlipSprite = 442 -- Blip sprite
Config.HikingBlipColour = 46 -- Blip colour
Config.HikingBlipScale = 0.75 -- Blip scale

Config.GlobalHikingNotification = true -- Should all players be notified the player is hiking

Config.TrailSignInCoord = vector3(2392.942, 5319.21, 97.86246) -- Where the hiking trail sign in sign will spawn
Config.TrailEndCoords = vector3(501.6557, 5603.702, 797.9102) -- Where the hiking trail ends

Config.TrailSignInCoordZOffset = 1.25 -- The Z offset of the sign (to place it in the ground)
Config.TrailSignInHeading = 35.24 -- The heading of the sign (which way it is facing)
Config.TrailSignInSignHash = -435354659 -- The hash of the sign

Config.TrailCheckPoints = {
    vector3(2280.621, 5367.913, 131.04),
    vector3(2141.794, 5379.937, 164.8636),
    vector3(1859.645, 5404.401, 229.4281),
    vector3(1664.27, 5473.131, 321.4781),
    vector3(1405.41, 5550.413, 461.3765),
    vector3(1177.113, 5573.83, 533.9446),
    vector3(960.3922, 5641.531, 634.641),
    vector3(792.9186, 5693.178, 69634244)
}

Config.EnableHikingReward = true
Config.HikingRewardMoney = true -- If set to false, it will use an item
Config.HikingRewardAmount = 100 -- Amount of money (if enabled)
Config.HikingRewardItem = 'bread' -- Item (if enabled)

Config.HikingAlertText = 'A player has begun a hike up Mt Chiliad!'