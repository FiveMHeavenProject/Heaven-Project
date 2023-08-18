fx_version 'bodacious'
game 'gta5'
author 'Resesetti'
    
   
shared_scripts {
    '@es_extended/imports.lua'
}
    
client_scripts {
    'config.lua',
    'client/*.lua',
}
    
server_scripts {
    'config.lua',
    'server/*.lua',
}
dependencies {
    'hp_fixwiring'
}


files {
	'web/FuseBox.html',
	'web/FuseBox.js',
	'web/FuseBox.css'
}

ui_page 'web/FuseBox.html'