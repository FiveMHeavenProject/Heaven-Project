fx_version 'adamant'

game 'gta5'

description 'Skrypt na garaże'
lua54 'yes'

version '1.0'
legacyversion '1.9.1'

client_scripts {
	'client/main.lua',
	'client/functions.lua',
}

ui_page 'ui/index.html'
files { 
	'ui/index.html', 
	'ui/style.css', 
	'ui/script.js'
}

shared_script '@ox_lib/init.lua'
shared_script 'config.lua'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua'
}
dependency 'es_extended'
