# Camping
While camping, users will be able to set a tent, set a fire, set a chair, and set a grill! All items that are set are able to be moved by toggling edit mode in the camping menu!

## Camping Configuration Settings

```lua
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
```

## To Do
- [x] Add the ability to move objects
- [x] Add the ability to spawn a chair (to sit by the fire)
- [ ] Add the ability to cook on the grill (using animation + adding food if enabled in the config)
- [ ] Add the ability to lock objects in place (so moving others does not interfere)

----

![Tent](https://thedopechronicles.files.wordpress.com/2013/12/0_0-124.jpg)
