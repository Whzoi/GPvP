fx_version "cerulean"

description "Fivem Custom React HudV3 maade for purchase"
author "Whzoi" -- Most re written im taking credit
version '1.0.0'

lua54 'yes'

games {
  "gta5",
  "rdr3"
}

ui_page 'ui/index.html'

client_script 'config.lua'
client_script "client/**/*"
-- client_script 'NoReticle.Client.net.dll'

server_script "server/**/*"
-- server_script 'NoReticle.Server.net.dll'

files {
	'ui/index.html',
	'ui/**/*',
}