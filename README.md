# Advanced PHP Heroku Build Pack

## What works?

* Basic provisioning
* NGINX Configuration for frameworks `silex` and `symfony2`
* Reading configuration from `composer.json`

[Available PHP Versions]: http://chh-heroku-buildpack-php.s3.amazonaws.com/manifest.php
[Available NGINX Versions]: http://chh-heroku-buildpack-php.s3.amazonaws.com/manifest.nginx

## Configuration

Configuration is done via a file named `composer.json` in the project's
root.

A simple configuration could look like this:

    {
        "name": "my-app",
        "require": {
            "php": ">=5.4.0"
        },
        "extra": {
            "heroku": {
                "document-root": "web",
                "index-document": "index.php"
            }
        }
    }

This configures an app with the document root set to the project's `web`
directory, and sets that all requests should go through `web/index.php`
which contains the application's front controller.

### Configuration Directives

#### framework

Use a framework preset for configuration. Some configuration keys cannot
be overriden!

Available presets:

* `silex` (needs `document-root` and `index-document` set)
* `symfony2`

Example:

    "framework": "silex"

#### document-root

Document root relative to the app root. Defaults to the app root.

    "document-root": "web"

#### index-document

Index Document relative to the document root.

    "index-document": "app.php"

#### engines

Set PHP and NGINX versions.

To launch the app with PHP 5.3.23 and NGINX 1.3.14:

    "engines": {
        "php": "5.3.23",
        "nginx": "1.3.14"
    }

See also:

* [Available NGINX Versions][]
* [Available PHP Versions][]

#### php-config

Add directives to the `php.ini`.

    "php-config": [
        "display_errors=off",
        "short_open_tag=on"
    ]

#### compile

_Status: Not Implemented_

Run console commands on slug compilation.

    "compile": [
        "php app/console assetic:dump --env=prod --no-debug"
    ]

