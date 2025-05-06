
fx_version 'cerulean'
game 'gta5'

name 'bzv_illegattablet'
description 'Blackmarket PC System'
author 'Brozovec // For Waxanity'
version '1.0.0'
lua54 'yes'


ui_page 'ui/dist/index.html'

client_scripts {
    'client.lua',
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua',
    'server/*.lua'
}

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
}

dependencies {
    'es_extended',
    'oxmysql'
}

files {
    'ui/dist/index.html',
    'ui/dist/assets/**/*',
}

escrow_ignore {
    'client/*.lua',  
    'server/*.lua',
    'config.lua'
}
