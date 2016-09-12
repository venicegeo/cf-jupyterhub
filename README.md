# Geoint Service Jupyterhub

[Jupyterhub](https://github.com/jupyterhub/jupyterhub) requires Python 3.3 or
higher and NodeJS. This presents an issue when you attempt to run this app
in cloudfoundry. Cloudfoundry only supports one buildpack per application. 
You can run a python application or a node application, but not one that uses 
both.

## Target Requirements
Jupyterhub requires NodeJS and Python3 along with quite a few Python packages
available from pypi.

## Building the Package
The build requires [FPM](https://github.com/jordansissel/fpm).

> FPM helps you build packages quickly and easily (Packages like RPM and DEB formats).

### Installing FPM on the Build Machine
FPM can be installed as a Ruby Gem:

    # yum -y install ruby ruby-devel
    # gem install fpm

### Using the Build Scrpt
In the root of this directory is a `build.sh` script. Execute it like this:
    ./build rpm
or
    ./build deb

to build either an rpm or Debian package.

## About the Package
Some Linux Systems use an older version of Python for internal management. 
Some target systems also have no network capabilities. 

This package includes all of the required dependencies in a portable format.

On installation of the package:
- Source files are copied to the `/tmp` directory
- Python3.4 is built and compiled and then installed in `/opt`
- NodeJS and the node_modules are copied to `/opt`
- A _hubadmin_ user is created on the system and given limited sudo privileges

**STUB Not Complete**
