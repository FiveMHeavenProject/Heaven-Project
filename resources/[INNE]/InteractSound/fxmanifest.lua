-- FXVersion Version
fx_version 'adamant'
games { 'gta5' }

-- Client Scripts
client_script 'client/main.lua'

-- Server Scripts
server_script 'server/main.lua'

-- NUI Default Page
ui_page "client/html/index.html"

-- Files needed for NUI
-- DON'T FORGET TO ADD THE SOUND FILES TO THIS!
files {
    'client/html/index.html',
    -- Begin Sound Files Here...
    -- client/html/sounds/ ... .ogg
    'client/html/sounds/handcuff.ogg',
	'client/html/sounds/gpsloss.ogg',
	'client/html/sounds/10-13.ogg',
	'client/html/sounds/lock.ogg',
	'client/html/sounds/unlock.ogg',
	'client/html/sounds/beltoff.ogg',
	'client/html/sounds/belton.ogg',
	'client/html/sounds/DoorOpen.ogg',
	'client/html/sounds/beep.ogg',
	'client/html/sounds/DoorClose.ogg',
}
