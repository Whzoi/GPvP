fx_version 'cerulean'
games {'gta5'}

client_script 'client.lua'

files{
	'**/weaponcomponents.meta',
	'**/weaponarchetypes.meta',
	'**/weaponanimations.meta',
	'**/pedpersonality.meta',
	'**/weapons.meta',
	'echo_weaponsounds/weapon_audio_bank.awc',
	'data/echo_weapon_sounds.dat54.rel',
	'data/echo_weapon_game.dat151.rel',
	'metas/weaponcomponents/*.meta', 
	'metas/weapons/*.meta',
}

data_file 'WEAPONCOMPONENTSINFO_FILE' '**/weaponcomponents.meta'
data_file 'WEAPON_METADATA_FILE' '**/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/weaponanimations.meta'
data_file 'PED_PERSONALITY_FILE' '**/pedpersonality.meta'
data_file 'WEAPONINFO_FILE' '**/weapons.meta'
data_file 'AUDIO_WAVEPACK' 'echo_weaponsounds'
data_file 'AUDIO_SOUNDDATA' 'data/echo_weapon_sounds.dat'
data_file 'AUDIO_GAMEDATA' 'data/echo_weapon_game.dat'
data_file 'WEAPONINFO_FILE_PATCH' 'metas/weapons/*.meta'
