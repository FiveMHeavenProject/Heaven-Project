fx_version 'bodacious'
game 'gta5'
author '! Resesetti#8473'
description 'Heaven Gym - Autorski skrypt wykonany.'
lua54 'yes'
shared_scripts {
	'@es_extended/imports.lua',
	'@ox_lib/init.lua'
}

client_scripts{
	'@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
	'client/*.lua',
}

server_scripts{
	'server/*.lua',
}
