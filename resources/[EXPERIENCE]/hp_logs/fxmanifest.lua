fx_version 'bodacious'
game 'gta5'
author '! Resesetti#8473'
description 'Heaven Logs - Autorski skrypt wykonany.'

shared_scripts {
	'@es_extended/imports.lua'
}

client_scripts{
	'client/*.lua',
}

server_scripts{
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua',
}

