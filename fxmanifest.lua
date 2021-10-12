fx_version 'cerulean'
game 'gta5'
description 'ESX County Alive - Give players things to do in the county!'
author 'Abel Gaming'
version '1.0.1'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'config.lua',
	'client/main.lua'
}

exports {
	"GetTentStatus",
	"GetFireStatus",
	"GetGrillStatus",
	"GetChairStatus",
	"GetEditModeStatus",
	"GetFishingStatus",
	"GetHikingStatus",
	"GetTentDetails",
	"GetFireDetails",
	"GetGrillDetails",
	"GetChairDetails"
}
