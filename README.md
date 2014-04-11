# Advanced PHP Heroku Build Pack

## What makes it unique?

* **Fast** deployments, because the runtime environment is built from precompiled binaries via Heroku's "vulcan"
* Supports PHP 5.3, 5.4 and 5.5
* Uses the memory of the dyno more efficiently by going with NGINX and PHP-FPM.
* Supports Composer out of the box
* No writing NGINX configuration files: supports CakePHP, Classic PHP applications, Magento, Silex, Slim, Symfony 2 and ZF2 apps with simple configuration driven by your `composer.json`.
* Zero-Configuration Symfony 2 and Yii 1 deployment.
* Dynamic installing of [supported extensions](support/ext) listed as `ext-` requirments in `composer.json`.

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

This buildpack detects apps when the app has a `composer.lock` in the
app's root.

If an `index.php` is detected in the app's root, then it switches to
"classic mode", which means that every ".php" file is served with PHP,
and the document root is set to the app root.

When a `composer.lock` is detected, then the buildpack does `composer
install --no-dev`.

## Environment

This buildpack sets environment variables during compile and runtime:

* `HEROKU_BUILD_TIME`: Time when the slug was compiled. Format is `%Y%m%d%H%M%S`, e.g. `20131103111548`

This buildpack also detects when the app has a node `package.json` in the
app's root. And will install node dependencies like less for example.

## Frameworks

### CakePHP

Is used when the app requires the `pear-pear.cakephp.org/CakePHP` Pear package or when the
`extra.heroku.framework` key is set to `cakephp2` in the `composer.json`. This project assumes the layout given in the [FriendsOfCake/app-template](https://github.com/FriendsOfCake/app-template) composer project.

Options:

* `index-document`: With CakePHP apps, this should be the file where `$Dispatcher->dispatch(new CakeRequest(), new CakeResponse());`
  is called. All requests which don't match an existing file will be forwarded to
  this document.

### Classic PHP

The classic PHP configuration is used as fallback when no framework was detected. It serves every `.php` file relative to the document root.

This is also used when an `index.php` file was found in the root of your
project and no `composer.json`.

### Magento

Is used when the `extra.heroku.framework` key is set to `magento` in the `composer.json`.

### Silex

Is used when the app requires the `silex/silex` package or when the
`framework` setting is set to `silex` in the `composer.json`.

Options:

* `index-document`: With Silex apps, this should be the file where `$app->run()`
  is called. All requests which don't match an existing file will be forwarded to
  this document.

### Slim

Is used when the app requires the `slim/slim` package or when the
`extra.heroku.framework` key is set to `slim` in the `composer.json`.

Options:

* `index-document`: With Slim apps, this should be the file where `$app->run()`
  is called. All requests which don't match an existing file will be forwarded to
  this document.

### Symfony 2

Is detected when the app requires the `symfony/symfony` package or when the
`framework` setting is set to `symfony2` in the `composer.json`.

This framework preset doesn't need any configuration to work.

Please note that if you use config vars in Composer hooks, or in `compile`
scripts, then a new code push may be necessary if you decide to change a config variable.

### Yii 1

Is detected when the app requires the `yiisoft/yii` package or when the
`framework` setting is set to `yii` in the `composer.json`.

This framework preset doesn't need any configuration to work.

Options:

* `index-document`: All requests which don't match an existing file will be forwarded to
  this document. Defaults to `index.php`. With Yii apps, this can be set to `index-test.php`
  for deployments used for acceptance testing.

## Extensions

When the buildpack encounters `ext-` requirements in your `composer.json`, it will look
up the extension name in the [supported extensions](support/ext) and install them.

The version constraint is ignored currently.

For example, to install the Sundown extension:

```
{
    "require": {
        "ext-sundown": "*"
    }
}
```

Note that the extension requirements defined by dependencies are not taken into account there.
It must be required by the project itself.

##Logging

This buildpack defines default log files by framework.
It also defines log files nginx and php.

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

* `cakephp2`
* `magento`
* `silex` (needs `document-root` and `index-document` set)
* `slim`
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
default versions are NGINX `1.4.4` and PHP `5.5.10`.

The version identifiers can also include wildcards, e.g. `5.4.*`. At the
time of writing, PHP `5.4.26` would be used in this case. This also
works for NGINX.

When a file named `.php-version` exists in the project root, then the
PHP version is read from this file instead.

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

#### php-includes

_Default: []_

Include additional .ini files that should be parsed after the default php.ini. File paths
are treated relative to the app root.

Example:

    "php-includes": ["etc/php.ini"]

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

#### newrelic

_Default: false_

Enable instrumentation support via [New Relic](http://newrelic.com).
It's recommended to add the New Relic addon to your Heroku app, but you
can also set your license key manually by setting the `NEW_RELIC_LICENSE_KEY` config var via `heroku config:set`.

    "newrelic": true

#### log-files

_Default: []_

The buildpack defines default log files by framework and some log files for php-fpm and nginx.
Any file put in `log-files` will be be appended to the list.
A tail on each unique log file will be run at application startup

    "log-files": [
        "app/logs/rabbit-mq.log",
        "vendor/nginx/stuff.log"
    ],


## Node.Js

If your app contains a `package.json` node and its dependencies will be installed

The nodejs buildpack is based on the [heroku diet node.js buildpack](https://github.com/heroku/heroku-buildpack-nodejs/tree/diet).
This diet branch of the buildpack is intended to replace the official Node.js buildpack once it has been tested by some users.

It :
- Uses the latest stable version of node and npm by default.
- Allows any recent version of node to be used, including pre-release versions, as soon as they become available on [nodejs.org/dist](http://nodejs.org/dist/).
- Uses the version of npm that comes bundled with node instead of downloading and compiling them separately. npm has been bundled with node since [v0.6.3 (Nov 2011)](http://blog.nodejs.org/2011/11/25/node-v0-6-3/). This effectively means that node versions `<0.6.3` are no longer supported, and that the `engines.npm` field in package.json is now ignored.
- Makes use of an s3 caching proxy of nodejs.org for faster downloads of the node binaries.
- Makes fewer HTTP requests when resolving node versions.
- Uses an updated version of [node-semver](https://github.com/isaacs/node-semver) for dependency resolution.
- No longer depends on SCONS.
- Caches the `node_modules` directory across builds.
- Runs `npm prune` after restoring cached modules, to ensure that any modules formerly used by your app aren't needlessly installed and/or compiled.

A minimal `package.json` file with less will look like this :
```json
{
    "author": "Your Name",
    "name": "App",
    "dependencies": {
        "less": ">= 1.4.*"
    }
}
```

Node and its modules will be available at compilation meaning you could process nodejs script at that time.

## Authenticating Composer calls on the Github API

Unauthenticated calls to the Github API are subject to a low rate limit. This includes calls to the download endpoint
which is attempted by default during the Composer call because archives can be cached between deployments.

The buildpack supports using authenticated API calls with Composer:

- Create a personal API token on Github. You can [read more on this](https://github.com/blog/1509-personal-api-tokens).
  The token should have the minimal permissions needed by your project. If your project only relies on public
  Github repositories for its dependencies, the best choice is to restrict it to the "public access" permissions.
- Set your token as the "COMPOSER_GITHUB_TOKEN" config variable in your heroku application. Any new deployment
  will use it to authenticate the composer calls.

## Contributing

Please see the [CONTRIBUTING](/CONTRIBUTING.md) file for all the
details.
