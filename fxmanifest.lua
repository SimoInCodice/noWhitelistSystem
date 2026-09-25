games {'gta5'}

fx_version 'cerulean'

description 'No whitelist jobs system'
version '0.0.1'

client_scripts {
  'client/*.lua',
  'client/**/*.lua'
}

shared_scripts {
  '@ox_lib/init.lua',
  'shared/config.lua'
}

server_scripts {
  'server/*.lua',
  'server/**/*.lua'
}

ui_page 'nui/index.html'


files {
  'nui/index.html',
  'nui/assets/*.*',
}

data_file 'DLC_ITYP_REQUEST' 'stream/prop_byte_elevator.ytyp'

dependencies {
  'ox_lib',
  'MugShotBase64'
}
