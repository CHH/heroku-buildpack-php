# Advanced PHP Heroku Build Pack

## What works?

Nothing.

## Configuration

_Status: Not implemented yet._

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
                "site": "web/index.php",
                "catch-non-existing": true
            }
        }
    }

This configures an app with the document root set to the project's `web`
directory, and sets that all requests should go through `web/index.php`
which contains the application's front controller.

### Configuration Directives

#### document-root

Document root relative to the app root. Defaults to the app root.

    "document-root": "web"

#### index-document

Index document, typically contains the front controller.

    "index-document": "web/app.php"

#### engines

Configure PHP and NGINX versions.

    "engines": {
        "php": "5.3.23"
    }

#### php-config

Add directives to the `php.ini`.

    "php-config": [
        "display_errors=off"
    ]

