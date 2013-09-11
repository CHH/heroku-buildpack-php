# Changelog

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
