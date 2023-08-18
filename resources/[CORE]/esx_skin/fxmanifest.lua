-- Define the FX Server version and game type
fx_version "adamant"
game "gta5"
server_scripts {
  '@es_extended/locale.lua',
  'config.lua',
  'locales/de.lua',
  'locales/br.lua',
  'locales/en.lua',
  'locales/fr.lua',
  '@oxmysql/lib/MySQL.lua',
  'server/main.lua',
}

shared_script '@es_extended/imports.lua'

client_scripts {
  '@es_extended/locale.lua',
  'config.lua',
  'locales/de.lua',
  'locales/br.lua',
  'locales/en.lua',
  'locales/fr.lua',
  'client/main.lua',
}
ui_page 'html/index.html'
files {
	'html/*'
}