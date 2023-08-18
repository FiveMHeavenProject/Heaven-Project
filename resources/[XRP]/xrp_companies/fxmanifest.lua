fx_version 'cerulean'
games {'gta5'}
lua54 'yes'

author 'jakiś debil z heaven project'
description 'Firmy kozackie'
version '0.1'


client_scripts {
    'client/*.lua'
}

server_scripts {
	'server.lua',
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

