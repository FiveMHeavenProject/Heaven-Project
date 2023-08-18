fx_version 'bodacious'
game 'gta5'
author 'Resesetti'
lua54 'yes'

description 'Praca winiarza napisana dla Heaven-Project'
    
shared_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    '@es_extended/imports.lua',
    '@ox_lib/init.lua'
}
client_scripts {
    'client/*.lua',
}
    
server_scripts {
    'server/*.lua'
}

dependencies {
    'es_extended',
    'hp_logs',
    'hp_progressbar',
    'ox_target',
    'ox_inventory'
}
