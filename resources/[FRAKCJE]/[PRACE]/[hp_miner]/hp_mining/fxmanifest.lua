fx_version 'bodacious'
game 'gta5'
author 'Resesetti'
lua54 'yes'

description 'Praca szmaragdowa napisana dla Heaven-Project'
    
shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua'
}
client_scripts {
    'config.lua',
    'client/*.lua',
}
    
server_scripts {
    'server/*.lua'
}

files {
    'stream/emeraldtyp.ytyp'
}
data_file 'DLC_ITYP_REQUEST' 'stream/emeraldtyp.ytyp'
