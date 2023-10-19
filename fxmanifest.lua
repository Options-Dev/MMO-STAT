fx_version 'cerulean'                                                                      
games { 'gta5' }                                                                           
                                                                                           
author 'Option Developer - Team.'
description 'Option Developer - Team.'
version '1.0.0'
lua54 'yes'

shared_script {
  "config.extension.lua",
  "config.farmwork.lua",
  "config.database.lua",
  "core/security/security.function.lua",
}

client_scripts {
  'core/core.client.lua',
  'core/function/function.client.lua',
}

server_scripts {
  'core/core.server.lua',
  'core/function/function.server.lua',
}

-- ui_page 'interface/dist/index.html'

-- files {
--   'interface/dist/index.html',
--   'interface/dist/assets/*.js',
--   'interface/dist/assets/*.css',
-- }

-- server_only 'yes'    -- [# หยุดไคลเอนต์ไม่ให้ดาวน์โหลดทรัพยากรนี้ ( ทำงานเฉพาะฝัง Server เท่านั้น )
-- provide 'tests'           -- [# เวลามีการ exports จะสามารถใชื่อที่ตั้งแทนชื่อทรัพยากร exports.tests:thisfunction()
-- dependencies {}      -- [# ต้องการทรัพยากรที่ระบุเพื่อโหลดก่อนทรัพยากรปัจจุบัน
-- exports {}
