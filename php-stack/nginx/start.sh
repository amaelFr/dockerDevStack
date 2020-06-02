#!/bin/bash

cp /etc/nginx/nginx.conf.bk /etc/nginx/nginx.conf

sed -i 's/phpfpm/'$PHPFPM'/g' /etc/nginx/nginx.conf

# if [ -z "$PHPROOT" ]; then
#     sed -i 's|rootpath|/var/www/html/'$PHPROOT'|g' /etc/nginx/nginx.conf
# else
sed -i 's|rootpath|/var/www/html/'$PHPROOT'|g' /etc/nginx/nginx.conf
# fi
if [ "$REDIRECTINDEX" = "1" ]; then
    sed -i 's|serverlocation|location / {\n            try_files $uri @rewriteapp;\n        }\n        location @rewriteapp {\n            rewrite ^(.*)$ /index.php/$1 last;\n        }|g' /etc/nginx/nginx.conf
else
    sed -i 's|serverlocation|location / {\n            try_files $uri;\n        }\n |g' /etc/nginx/nginx.conf
fi

nginx -g "daemon off;"