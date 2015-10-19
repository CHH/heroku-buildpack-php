# Changelog

## v0.4.1, 2015-10-19

* Autotune the PHP-FPM configuration based on the dyno size

## v0.4.0, 2015-04-28

### New features

* Update PHP to 5.5.24
* Improve the nginx config to support SSL endpoints
* Add a way to authenticate github api calls for composer by setting an oauth token in ``COMPOSER_GITHUB_TOKEN``
* Add support for the Yii framework
* Add support for the composer cakephp package to detect Cakephp
* Add support of extension with dependencies in the compile script
* Add support for the AMQP extension. Add ``ext-amqp`` to your requirements in your composer.json to enable it
* Add support for the SSH2 extension. Add ``ext-ssh2`` to your requirements in your composer.json to enable it
* Add support for the FTP extension. Add ``ext-ftp`` to your requirements in your composer.json to enable it

### Bug fixes

* Made the build scripts compatible with Linux
* Don't use the fifo for logs as it does not work on logplex
* Show script name and line number when errors occur to make buildpack errors easier to debug
* Update the build scripts to avoid using vulcan, which does not work anymore
* Update the sorting of versions to handle them properly

## v0.3.7, 2015-04-28

### Changes

* Use the official repo for pecl/memcache
* Use the heroku env variables for the newrelic config

## v0.3.6, 2014-03-26

### Changes

* Update PHP to 5.5.10
* Tail CakePHP log files
* Add `memcache` extension, you can enable it by putting
  `"ext-memcache": "*"` into your `composer.json` requirements
* Set UTC as default timezone to prevent PHP notices. This can be
  changed anytime by your app via `date_default_timezone_set` or by
  setting `date.timezone` in your `php-config` section in
  `composer.json`

## v0.3.5, 2014-02-25

### Changes

* Add support for new Heroku API for compile time user config variables.
  Variables set with `heroku config:set` are now always available at
  compile time.
* Add support for Zend Framework 2
* Enable Freetype support in PHP GD
* Updated PHP to 5.5.9
* Frameworks can now define which log files should be additionally
  "tailed" so they show up in `heroku logs`

## v0.3.4, 2014-01-24

### Changes

* Add `application/x-javascript` to GZIP-able types
* Add support for the Sundown extension. Add `ext-sundown` to your
  requirements in your `composer.json` and update your lockfile to enable it.

## v0.3.3, 2014-01-20

### Changes

* Ignore when a prebuilt extension bundle was not found in S3, which
  fixes Composer requires for `ext-curl` for example.

## v0.3.2, 2014-01-14

### Changes

* Update PHP to 5.5.8
* Update NGINX to 1.4.4

## v0.3.1, 2014-01-12

### Changes

* Add `apcu` as a separate extension bundle for easy updating
* Install `apcu` from the separate extension bundle in `compile` to
  update all existing installations to APCU 4.0.2. This release features
  the return of the `apc_` functions for a real drop in replacement.
* Merge PR #72

## v0.3.0, 2013-12-27

### Changes

* Add support for wildcards in engine versions, e.g. `5.4.*` selects the
  latest available version of PHP 5.4. Staying up to date has never been easier!
* Made document root overridable for Symfony apps
* Rebuilt 5.5, 5.4.19 and 5.3.27 to include the [phpredis][], mongo, exif,
  readline, sockets and bcmath extensions.
* Enable extensions in the `.ini` files distributed with the binaries.
* Added `php-includes` config directive for `composer.json` for
  including additional PHP config files.
* PHP, NGINX and Composer binaries are now cached and revalidated
  against MD5 hashes. This should provide notably faster deployments.
* Add scripts for pre-building some popular extensions, like Mongo, Redis,
Imagick, Libevent,…
* Add support for adding extensions like Mongo on-demand, driven by
  `ext-` requirements in `composer.json`, e.g. require `ext-libevent` to
  add the `libevent` extension
* Add BCMath and EXIF extensions to PHP
* Add mcrypt to PHP
* Add the `intl` extension
* Add support for Slim, CakePHP and Magento frameworks
* Add `sockets` to PHP
* Add support for installing NPM packages found in `package.json` files,
  which can be used at compile time (e.g. the LESS compiler)
* Add NewRelic support.
* Add support for `imagick` extension
* Frameworks now support a `post-compile` method
* `composer.lock` is now mandatory
* Composer packages are now detected by looking at the `composer.lock`.
* Vulcan is now installed with bundler
* A `HEROKU_BUILD_TIME` variable is now set when compiling the slug,
  which is available at runtime.
* Symfony apps now only expose `app.php`, previously also `app_dev.php`
  was reachable.

[phpredis]: http://github.com/nicolasff/phpredis

## v0.2.1, 2013-09-10

### Changes

* Fix compile command evaluation
* #28: Fix NGINX error caused by duplicate `root` directives

## v0.2.0, 2013-09-03

### Changes

* Buildpack now works also only with an `index.php` in the project's
  root, without `composer.json`. This makes it possible to run apps
  which are built for the official Heroku PHP buildpack.
* Packaging scripts now use zlib package from S3 bucket
* Add APCu by default
* Changed the default PHP to 5.5.3
* Add `nginx-includes` config key to include custom NGINX config files.
* Add the special `default` specifier for engine versions
* New structure for NGINX configurations. All shared config (like port,
  etc.) is now in one shared file, framework configurations are now
  included into the `server` scope.

## v0.1.1, 2013-07-05

### Changes

* PHP 5.5.0 is the new default
* Added PHP 5.4.17

## v0.1.0

### Changes

* Added 5.3.26, 5.4.16, 5.5.0
* Added `buildpack.conf` to easily customize buildpack settings when
  forked
* Add Opcache settings
* Using Zend Opcache for all PHP builds, leads to better performance and
  is an uniform solution from 5.3 to 5.5
* Removed APC, in favor of APCu.
