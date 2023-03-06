fx_version 'cerulean'
games {'gta5'}
ui_page 'html/index.html'
lua54 'yes'
use_fxv2_oal 'yes'

shared_scripts {
	'config.lua',
	'vehicles.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',	
	'framework/sv_wrapper.lua',
	'server/server.lua'
}

client_scripts {
	'framework/cl_wrapper.lua',
	'client/client.lua',
}

files {
	'html/design.css',
	'html/index.html',
	'html/script.js',
	'html/fonts/*',	
	'html/brands/*.png',	
	'imgs/*.png',
	'imgs/uploads/*.jpg',
}

data_file 'DLC_ITYP_REQUEST' 'stream/garage.ytyp'
files {
    'stream/garage.ytyp'
}