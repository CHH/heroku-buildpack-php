# Advanced PHP Heroku Build Pack

## What makes it unique?

* **Faster** deployments, because the runtime environment is built from precompiled binaries via Heroku's "vulcan"
* Supports both the latest 5.3 _and_ 5.4 versions
* Uses the memory of the dyno more efficiently by going with NGINX and PHP-FPM.
* Supports Composer out of the box
* No writing NGINX configuration files: supports Classic PHP, Silex and Symfony 2 apps with simple configuration driven by your `composer.json`.
* Zero-Configuration Symfony 2 deployment.

## What works?

* Basic provisioning
* NGINX Configuration for frameworks `silex` and `symfony2`
* Reading configuration from `composer.json`

## How to use it

Use the `--buildpack` parameter when creating a new app:

    heroku create --buildpack https://github.com/CHH/heroku-buildpack-php myapp

Or set the `BUILDPACK_URL` config var on an existing app:

    heroku config:set BUILDPACK_URL=https://github.com/CHH/heroku-buildpack-php

* * *

If you want to be on the bleeding edge and use pre-release features, then use
`git://github.com/CHH/heroku-buildpack-php#development` as buildpack
url.

## Stack

* NGINX 1.4 or 1.5
* PHP 5.3, 5.4 and 5.5, with [ZendOpcache][] and [APCu][] ([Info](https://chh-php-test.herokuapp.com/info))
* PHP-FPM

[ZendOpcache]: http://pecl.php.net/package/ZendOpcache
[APCu]: http://pecl.php.net/package/apcu
[Available PHP Versions]: http://chh-heroku-buildpack-php.s3.amazonaws.com/manifest.php
[Available NGINX Versions]: http://chh-heroku-buildpack-php.s3.amazonaws.com/manifest.nginx

## Detection

This buildpack detects apps when the app has a `composer.json` in the
app's root.

If an `index.php` is detected in the app's root, then it switches to
"classic mode", which means that every ".php" file is served with PHP,
and the document root is set to the app root.

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

The classic PHP configuration is used as fallback when no framework was detected. It serves every `.php` file relative to the document root.

This is also used when an `index.php` file was found in the root of your
project and no `composer.json`.

## Configuration

Configuration is done via a file named `composer.json` in the app's
root.

A simple configuration could look like this:

    {
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

Set the version to "default" to use the current default version. The current
default versions are NGINX `1.4.2` and PHP `5.5.3`.

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

#### nginx-includes

_Default: []_

Include additional config files into the NGINX configuration. Config
files are included into the `server` scope and are loaded after the
framework provided config. File paths are treated relative to the app
root.

Example:
    
    "nginx-includes": ["etc/nginx.conf"]

#### compile

_Default: []_

Run console commands on slug compilation.

    "compile": [
        "php app/console assetic:dump --env=prod --no-debug"
    ]

_Note: pecl is not runnable this way._

# Contributing

Please see the [CONTRIBUTING](/CONTRIBUTING.md) file for all the
details.
