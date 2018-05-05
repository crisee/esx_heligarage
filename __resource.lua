resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'esx_heligarage - Police and Ambulance Helicopter garage. - Made by crise'

version '1.0'

client_scripts {
  'config.lua',
  'client/main.lua'
}

server_scripts {
  'config.lua',
  '@mysql-async/lib/MySQL.lua',
  'server/main.lua'
}
