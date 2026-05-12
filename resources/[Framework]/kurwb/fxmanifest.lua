fx_version 'cerulean'
game 'gta5'


name "Customs"
description "VanillaCustoms"
author "TheSmilingRime"
version "1.0.0"


files {
    'data/**/*.meta',
}

client_scripts {
    'scripts/client/*.lua'
}

data_file 'HANDLING_FILE' 'data/**/handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'data/**/vehicles.meta'
data_file 'CARCOLS_FILE' 'data/**/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'data/**/carvariations.meta'
data_file 'VEHICLE_LAYOUTS_FILE' 'data/**/*vehiclelayouts.meta' --This is optional, but from my understading you might need it for RHD vehicles.
