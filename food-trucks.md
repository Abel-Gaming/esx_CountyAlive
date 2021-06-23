# Food Trucks / Trailers
While in the county - or anywhere - players will be able to access food trucks / trailers that you have added! 
They can purchase items at the locations that they might need during their time in the county

## Food Trucks / Trailers Configuration Settings

```lua
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
```

## To Do
- [x] Add the ability for each truck/trailer to have different items available
- [ ] Add a menu slider option to increase the quantity (instead of buying one at a time)

----

![FoodTrailer](https://steamuserimages-a.akamaihd.net/ugc/391047884371275069/0A707199469F8CE8E6EF558B53D45FC1A1341146/?imw=512&&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false)
