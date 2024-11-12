fx_version 'cerulean'
games { 'gta5' }

author 'Vallen'
description 'Radial Menu for FiveM'
version '1.0.0'

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/styles.css',
    'html/script.js',
}

client_scripts {
    'client.lua',
    'trunk.lua'
}

server_script 'server.lua'