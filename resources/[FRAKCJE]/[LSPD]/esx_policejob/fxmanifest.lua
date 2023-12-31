fx_version 'adamant'

game 'gta5'

description 'ESX Police Job'
lua54 'yes'
version '1.0.2'
legacyversion '1.9.1'

shared_scripts  {
	'@es_extended/imports.lua',
	'@ox_lib/init.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'server/*.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'client/*.lua'
}

dependencies {
	'es_extended'
}
