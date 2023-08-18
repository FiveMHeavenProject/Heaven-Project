fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Resesetti'

shared_scripts{
    '@ox_lib/init.lua',
    '@es_extended/imports.lua'
} 

client_scripts {
    'client/*.lua'
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}
server_export {
    'getDutyTime'
}

ui_page 'html/index.html'
files {
    'html/*',
    'html/fonts/*.ttf',
    'html/assets/*.png'
}