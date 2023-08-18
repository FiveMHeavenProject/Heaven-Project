fx_version 'adamant'

game 'gta5'

description 'Heaven Project gps'
lua54 'yes'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
	'server.lua'
}

client_scripts {
	'config.lua',
	'client.lua'
}