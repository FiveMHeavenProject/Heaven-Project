fx_version 'cerulean'
game 'gta5'
author 'ja'
lua54 'yes'

client_scripts {
    'client.lua',
    'config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

shared_script '@ox_lib/init.lua'
ui_page "html/copy.html"
file "html/copy.html"