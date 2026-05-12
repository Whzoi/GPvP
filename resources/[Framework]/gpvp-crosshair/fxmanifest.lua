fx_version 'cerulean'
game 'gta5'

description 'GPVP Crosshair'
version '1.0.0'

ui_page 'ui/index.html'

shared_scripts {
    '@ox_lib/init.lua',
}

client_scripts {
    'client/combat/crosshair.lua',
    'client/combat/disableauto.lua',
    'client/staff/noobs.lua',
}

files {
    'ui/crosshair.png',
    'ui/index.html',
    'ui/script.js',
    'ui/style.css',
}

lua54 'yes'
use_experimental_fxv2_oal 'yes'

