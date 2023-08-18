fx_version  'cerulean'
game        'gta5'
lua54       'yes'

client_scripts {
    'radar.lua',
    'client.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
    'server.lua'
}

-- NUI

ui_page 'web/hud.html'


files {
    'web/hud.html',
    'web/style.css',
    'web/main.js',
    'web/assets/**'
}