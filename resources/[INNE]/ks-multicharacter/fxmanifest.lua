fx_version 'cerulean'
game 'gta5'

description 'ks-multicharacter'
version '1.0'

lua54 'yes'

shared_scripts {
    '@es_extended/imports.lua',
    'ks-libs-checker/ks-framework.lua',
    
    'ks-libs-configs/ks-config.lua',
}

ui_page 'ks-libs-web/ks-interface.html'

client_scripts {
    'ks-libs-source/ks-client.lua',
    'ks-libs-configs/ks-open-client.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'ks-libs-source/ks-server.lua',
    'ks-libs-configs/ks-open-server.lua',
}

escrow_ignore {
    'ks-libs-configs/*.lua'
}

files { 
    'ks-libs-configs/ks-config.js',
    'ks-libs-web/ks-interface.html',
    'ks-libs-web/ks-scripts/*.js',
    'ks-libs-web/ks-styles/*.css',
    'ks-libs-web/ks-files/*.*', 
}
dependency '/assetpacks'