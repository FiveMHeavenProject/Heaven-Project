fx_version 'bodacious'
game 'gta5'
author 'resesetti & wwr'

description 'HP Progressbar by wwr & resesetti'

shared_scripts {
    '@es_extended/imports.lua'
}

client_scripts {
    'client/*.lua',
}

exports 'startProgressbar'

-- NUI

ui_page 'web/dist/index.html'


files {
    'web/dist/**/*',
}
