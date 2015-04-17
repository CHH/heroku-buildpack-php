# Contributing

## Branching

The `master` branch should always contain production ready code. All
features which are staged to go into the next release are found in the
`development` branch.

Releases are done by merging `development` to `master` and creating a
tag on `master` which follows [Semantic Versioning][].

[Semantic Versioning]: http://semver.org

Features should always live in their own branch. Feature branches start
with `feature/`, e.g. a name for your feature branch might be `feature/my-awesome-feature`.
Feature branches should branch off `master`, and get merged to
`development` once they are reviewed.

* * *

Please submit pull requests to the `development` branch. The
`development` branch is used to make new releases of this buildpack,
which are available to _all_ users.

## Hacking

### Setup

You need the following tools to hack on this project:

* An Amazon S3 bucket
* An heroku application using the cedar-10 stack (the buildpack is not compatible with the cedar-14 stack) to run the compilation

Setup an S3 Bucket in Amazon. Then note the name of your bucket
and set it as `S3_BUCKET` in `conf/buildpack.conf`.

You can copy our bucket by running ``s3cmd cp --recursive --acl-public s3://chh-heroku-buildpack-php s3://your-bucket``

You should then configure the application to be ready to be used for packaging:

```bash
# configure the application remote (assuming the app name "buildpack-packaging" here)
$ heroku git:remote -a buildpack-packaging

# configure the AWS credentials
$ heroku config:set AWS_ACCESS_KEY='<access key>' AWS_SECRET_KEY='<secret key>'

# deploy the buildpack code to heroku (the development branch here
$ git push heroku development:master
```

### Packaging

Packaging is done by running some scripts in a heroku dyno:

```bash
$ heroku run bash
```

Compilation scripts can then be run on this dyno:

```bash
$ cd support
$ ./package_composer
```

All packaging scripts are in the `support` directory and are named
`package_<type>`, where `<type>` is either `nginx` or `php`. All
packaging scripts take the desired package version as first argument.

When the packaging is complete, the manifest which lists all available
package version is updated for the package type. Manifests are plain
text files which list each available version on a separate line.

They're uploaded to the S3 bucket as `manifest.<type>` files,
e.g. the manifest for PHP is `manifest.php`.

Before packaging anything, you need to make sure that you've a Zlib
tarball in your S3 bucket. Both NGINX and PHP depend on it. _You need
the exact version which is set in the packaging scripts._

To get one, use `support/get_zlib <version>`, for example:

    ./support/get_zlib 1.2.8

#### Updating NGINX

NGINX is packaged by the script `support/package_nginx`.

For example, to build NGINX `1.5.2`:

    ./support/package_nginx 1.5.2

#### Updating PHP

PHP is packaged by the script `support/package_php`.

For example, to build PHP `5.5.0`:

    ./support/package_php 5.5.0

