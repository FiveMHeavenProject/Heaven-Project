fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Shir0u & Kris'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
	'server/server.lua',
}
client_scripts {
	'config.lua',
	'client/utils.lua',
	'client/client.lua'
}
ui_page 'web/dist/index.html'


files {
	'web/dist/**/*',
}

shared_script '@es_extended/imports.lua'