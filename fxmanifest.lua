fx_version 'cerulean'
game {'gta5'}
lua54 'yes'

scriptname '0r-repairkit'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config/*.lua',
    'locales/*.lua',
}

client_scripts {
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
}

escrow_ignore {
    'locales/*.lua',
    'config/*.lua',
}

files {
    'ui/index.html',
    'ui/index.css',
    'ui/index.js',
    'ui/assets/**/*.js',
    'ui/assets/**/*.ttf',
    'ui/assets/**/*.svg',
}

ui_page 'ui/index.html'

dependencies {
    'ox_lib',
}