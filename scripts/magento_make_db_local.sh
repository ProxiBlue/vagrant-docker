#!/bin/bash

n98-magerun --scope-id=0 config:set web/unsecure/base_url {{base_url}}
n98-magerun --scope-id=0 config:set web/unsecure/base_link_url {{base_url}}
n98-magerun --scope-id=2 --scope="stores" config:set web/unsecure/base_url {{base_url}}
n98-magerun --scope-id=2 --scope="stores" config:set web/unsecure/base_link_url {{base_url}}
n98-magerun --scope-id=1 --scope="stores" config:set web/unsecure/base_link_url {{base_url}}
n98-magerun --scope-id=2 --scope="stores" config:set web/secure/base_link_url {{base_url}}
n98-magerun --scope-id=2 --scope="stores" config:set web/unsecure/base_link_url {{base_url}}
n98-magerun --scope-id=1 --scope="stores" config:set web/secure/base_link_url {{base_url}}
n98-magerun --scope-id=1 --scope="stores" config:set web/unsecure/base_link_url {{base_url}}
n98-magerun --scope-id=2 --scope="stores" config:set web/secure/base_url {{base_url}}
n98-magerun --scope-id=0 --scope="stores" config:set web/secure/base_url {{base_url}}
n98-magerun --scope-id=0 --scope="stores" config:set web/unsecure/base_url {{base_url}}
n98-magerun --scope-id=0 --scope="stores" config:set web/secure/base_url {{base_url}}
n98-magerun --scope-id=1 --scope="stores" config:set web/unsecure/base_url {{base_url}}
n98-magerun --scope-id=1 --scope="stores" config:set web/secure/base_url {{base_url}}
n98-magerun --scope-id=1 --scope="stores"  config:set web/unsecure/base_url {{base_url}}
n98-magerun --scope-id=1 --scope="stores" config:set web/secure/base_url {{base_url}}
n98-magerun --scope-id=1 --scope="stores" config:set web/unsecure/base_skin_url {{base_url}}/skin
n98-magerun --scope-id=1 --scope="stores" config:set web/secure/base_skin_url {{base_url}}/skin
n98-magerun --scope-id=0 --scope="stores" config:set web/unsecure/base_skin_url {{base_url}}/skin
n98-magerun --scope-id=0 --scope="stores" config:set web/secure/base_skin_url {{base_url}}/skin
n98-magerun --scope-id=1 --scope="stores" config:set web/unsecure/base_js_url {{base_url}}/js
n98-magerun --scope-id=1 --scope="stores" config:set web/secure/base_js_url {{base_url}}/js
n98-magerun --scope-id=0 --scope="stores" config:set web/unsecure/base_js_url {{base_url}}/js
n98-magerun --scope-id=0 --scope="stores" config:set web/secure/base_js_url {{base_url}}/js
n98-magerun --scope-id=1 --scope="stores" config:set web/unsecure/base_media_url {{base_url}}/media
n98-magerun --scope-id=1 --scope="stores" config:set web/secure/base_media_url {{base_url}}/media
n98-magerun --scope-id=0 --scope="stores" config:set web/unsecure/base_media_url {{base_url}}/media
n98-magerun --scope-id=0 --scope="stores" config:set web/secure/base_media_url {{base_url}}/media
n98-magerun --scope-id=2 --scope="websites" config:set web/unsecure/base_url {{base_url}}
n98-magerun --scope-id=2 --scope="websites" config:set web/unsecure/base_link_url {{base_url}}
n98-magerun --scope-id=1 --scope="websites" config:set web/unsecure/base_link_url {{base_url}}
n98-magerun --scope-id=2 --scope="websites" config:set web/secure/base_link_url {{base_url}}
n98-magerun --scope-id=2 --scope="websites" config:set web/unsecure/base_link_url {{base_url}}
n98-magerun --scope-id=1 --scope="websites" config:set web/secure/base_link_url {{base_url}}
n98-magerun --scope-id=1 --scope="websites" config:set web/unsecure/base_link_url {{base_url}}
n98-magerun --scope-id=2 --scope="websites" config:set web/secure/base_url {{base_url}}
n98-magerun --scope-id=0 --scope="websites" config:set web/secure/base_url {{base_url}}
n98-magerun --scope-id=0 --scope="websites" config:set web/unsecure/base_url {{base_url}}
n98-magerun --scope-id=0 --scope="websites" config:set web/secure/base_url {{base_url}}
n98-magerun --scope-id=1 --scope="websites" config:set web/unsecure/base_url {{base_url}}
n98-magerun --scope-id=1 --scope="websites" config:set web/secure/base_url {{base_url}}
n98-magerun --scope-id=1 --scope="websites"  config:set web/unsecure/base_url {{base_url}}
n98-magerun --scope-id=1 --scope="websites" config:set web/secure/base_url {{base_url}}
n98-magerun --scope-id=1 --scope="websites" config:set web/unsecure/base_skin_url {{base_url}}/skin
n98-magerun --scope-id=1 --scope="websites" config:set web/secure/base_skin_url {{base_url}}/skin
n98-magerun --scope-id=0 --scope="websites" config:set web/unsecure/base_skin_url {{base_url}}/skin
n98-magerun --scope-id=0 --scope="websites" config:set web/secure/base_skin_url {{base_url}}/skin
n98-magerun --scope-id=1 --scope="websites" config:set web/unsecure/base_js_url {{base_url}}/js
n98-magerun --scope-id=1 --scope="websites" config:set web/secure/base_js_url {{base_url}}/js
n98-magerun --scope-id=0 --scope="websites" config:set web/unsecure/base_js_url {{base_url}}/js
n98-magerun --scope-id=0 --scope="websites" config:set web/secure/base_js_url {{base_url}}/js
n98-magerun --scope-id=1 --scope="websites" config:set web/unsecure/base_media_url {{base_url}}/media
n98-magerun --scope-id=1 --scope="websites" config:set web/secure/base_media_url {{base_url}}/media
n98-magerun --scope-id=0 --scope="websites" config:set web/unsecure/base_media_url {{base_url}}/media
n98-magerun --scope-id=0 --scope="websites" config:set web/secure/base_media_url {{base_url}}/media
n98-magerun config:set web/secure/use_in_frontend 0
n98-magerun config:set web/secure/use_in_adminhtml 0
n98-magerun config:set admin/url/custom {{base_url}}
n98-magerun config:set admin/url/use_custom 0
n98-magerun config:set admin/url/use_custom_path 0

n98-magerun config:set system/smtp/disable 1
n98-magerun config:set dev/css/merge_css_files 0
n98-magerun config:set dev/js/merge_files 0
n98-magerun config:set dev/log/active 1
n98-magerun config:delete web/cookie/cookie_domain
n98-magerun config:delete web/cookie/cookie_path
n98-magerun config:set google/analytics/active 0


n98-magerun cache:disable
n98-magerun admin:user:create proxiblue sales@proxiblue.com.au password lucas lucas

