fx_version 'cerulean'
game 'gta5'

name "core"
description "core"
author "BIMBOHAHA"
version "1.0.0"

shared_scripts {
	'shared/**'
}

files {
    'luacrypto/**/**'
}

client_scripts {
	"@PolyZone/client.lua",
    "@PolyZone/BoxZone.lua",
    "@PolyZone/EntityZone.lua",
    "@PolyZone/CircleZone.lua",
    "@PolyZone/ComboZone.lua",
	
	'client/**',
	'gamesettings/**/**',
}

server_scripts {
	'server/**'
}

-- loadscreen 'https://LysolLol.github.io'
loadscreen_manual_shutdown "yes"