version '1.4.0'
author 'Concept Collective'
description 'A chat theme for FiveM'

lua54 'yes'

server_script 'server/main.lua'
client_script 'client/main.lua'

dependency 'chat'

file 'theme/style.css'

chat_theme 'ccChat' {
    styleSheet = 'theme/style.css',
    msgTemplates = {
        ccChat = '<div id="notification"><div id="color-box" style="background-color: {0} !important;" class="noisy"></div><div id="info"><div id="top-info"><h2 id="sub-title">{2}</h2><h2 id="time">{3}</h2></div><div id="bottom-info"><p id="text">{4}</p></div></div>'
    }
}

exports {
    'getTimestamp'
}

game 'common'
fx_version 'adamant'
