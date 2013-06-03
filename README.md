# Advanced PHP Heroku Build Pack

## What makes it unique?

* **Faster** deployments the runtime environment is built from precompiled binaries via Heroku's "vulcan"
* Supports both the latest 5.3 _and_ 5.4 versions
* Uses the memory of the dyno more efficiently by going with NGINX and PHP-FPM.
* Supports Composer out of the box
* No writing NGINX configuration files: supports Classic PHP, Silex and Symfony 2 apps with simple configuration driven by your `composer.json`.
* Zero-Configuration Symfony 2 deployment.

## What works?

* Basic provisioning
* NGINX Configuration for frameworks `silex` and `symfony2`
* Reading configuration from `composer.json`

## Stack

* NGINX 1.2 or 1.3
* PHP 5.3 or 5.4
* PHP-FPM

[Available PHP Versions]: http://chh-heroku-buildpack-php.s3.amazonaws.com/manifest.php
[Available NGINX Versions]: http://chh-heroku-buildpack-php.s3.amazonaws.com/manifest.nginx

## Detection

This buildpack detects apps when the app has a `composer.json` in the
app's root.

## Configuration

Configuration is done via a file named `composer.json` in the app's
root.

A simple configuration could look like this:

    {
        "name": "my-app",
        "require": {
            "php": ">=5.4.0",
            "silex/silex": "~1.0@dev"
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

This buildpack supports configuration through directives placed in the `heroku`
key in the `extra` object.

#### framework

_Default: Null_

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

_Default: "index.php"_

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

_Default: []_

Add directives to the `php.ini`.

    "php-config": [
        "display_errors=off",
        "short_open_tag=on"
    ]

#### compile

_Status: Not Implemented_

_Default: []_

Run console commands on slug compilation.

    "compile": [
        "php app/console assetic:dump --env=prod --no-debug"
    ]

## Frameworks

### Symfony 2

Is detected when the app requires the `symfony/symfony` package or when the 
`extra.heroku.framework` key is set to `symfony2` in the `composer.json`.

This framework preset doesn't need any configuration to work.

### Silex

Is used when the app requires the `silex/silex` package or when the 
`extra.heroku.framework` key is set to `silex` in the `composer.json`.

Options:

* `index-document`: With Silex apps, this should be the file where `$app->run()`
  is called. All requests which don't match an existing file will be forwarded to
  this document.

### Classic PHP

The classic PHP configuration is used as fallback when no framework was detected. It serves every `.php` file relative
to the document root.

# Hacking

You need the following tools to hack on this project:

* `s3cmd` from <http://s3tools.org>
* `vulcan` from Heroku via `gem install vulcan`

