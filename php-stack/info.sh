#### launch.json

'
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Listen for XDebug",
            "type": "php",
            "request": "launch",
            "port": 9000,
            "pathMappings": {
                "/var/www/html": "${workspaceFolder}"
            },
            "xdebugSettings": {
                "max_data": 65535,
                "show_hidden": 1,
                "max_children": 100,
                "max_depth": 5
            }
        }
    ]
}
'

## create symfony project
#### web site
composer create-project symfony/website-skeleton path
#### api | cli
composer create-project symfony/skeleton path
#### api with view of endpoints
composer require api


### for auth (general security)
composer require symfony/security-bundle
    #### multiple auth source
    composer require symfony/security-guard

### for entity
composer require symfony/orm-pack
composer require --dev symfony/maker-bundle
    ### make entity
    php bin/console make:entity

### to use uuid
composer require ramsey/uuid
composer require ramsey/uuid-doctrine

## csrf
composer require symfony/security-csrf

###
composer create-project symfony/skeleton ./
composer require symfony/orm-pack ramsey/uuid symfony/security-bundle symfony/security-guard symfony/security-csrf
composer require ramsey/uuid-doctrine
composer require symfony/maker-bundle --dev
composer require --dev doctrine/doctrine-fixtures-bundle