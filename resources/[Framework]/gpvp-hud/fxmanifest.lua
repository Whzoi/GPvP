fx_version 'cerulean'
game 'gta5'

author 'timed'
description 'GRP hud'

lua54 'on'

ui_page 'html/index.html'

client_scripts {
    'config.lua',
    'client.lua'
}

server_scripts {
    'server.lua'
}

shared_scripts {
    '@ox_lib/init.lua'
}

files {
    'html/*.html',
    'html/*.js',
    'html/*.css',
    'html/fonts/*.ttf',
    'html/images/*.png'
}

exports {
    'AddStress'
}

server_exports {
    'AddStressToPlayer'
}
