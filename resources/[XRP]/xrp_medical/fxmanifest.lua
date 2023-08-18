fx_version 'adamant'

game 'gta5'

description 'Skrypt na billard'
lua54 'yes'

version '1.0'

client_scripts {
	'@es_extended/locale.lua',
	'config.lua',
	'client/*.lua',
	'locales/en.lua',
}

server_scripts {
	'@es_extended/locale.lua',
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/*.lua',
	'locales/en.lua',
}