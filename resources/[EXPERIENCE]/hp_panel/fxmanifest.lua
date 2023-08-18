fx_version 'bodacious'
game 'gta5'
description 'Karta postaci'

shared_scripts {
	'@es_extended/imports.lua'
}

client_scripts {
	'client/*.lua',
}

server_scripts {
	'server/*.lua',
}

-- NUI

ui_page 'web/dist/index.html'


files {
	'web/dist/**/*',
}
