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
*CentOS 7*:
FPM can be installed as a Ruby Gem:

    # yum -y install ruby ruby-devel
    # gem install fpm

### Using the Build Script
In the root of this directory is a `build.sh` script. Execute it like this:

    ./build rpm

or

    ./build deb

to build either an rpm or Debian package.

## About the Package
Some Linux Systems use an older version of Python for internal management.
Some target systems also have no network capabilities.

This package relies on a few dependencies, available within the operating
system's standard repositories.

### RHEL/CentOS
- *epel-release* is required prior to installation of the gsjhub.rpm

Install it with `# yum -y install epel-release`

The rpm installation takes care of the rest of the dependencies. Here is what
gets installed along with the gsjhub RPM:

- zlib-devel
- postgresql-devel
- libsqlite-devel
- gcc
- nodejs
- npm
- openssl-devel
- python34
- pip3.4 

On installation of the package rpm:

1. The dependent packages above are installed
2. Source files are copied to the `/tmp` directory
3. The required node and python modules are installed from the RPM
4. A _gsjhub_ user is created on the system and given limited sudo privileges (only useradd and sudospawner are granted)
5. A systemd service file is added to `/usr/lib/systemd/system/`
6. The Jupyterhub config file is added to `/etc/gsjhub`

### Debian/Ubuntu
**Add Something Here!**

## Development
Since the Geoint Services Jupyterhub uses LDAP, PostgreSQL, and Sudospawner, local
development requires these services to emulate the production settings.

### Local LDAP
The simplest way to get an LDAP server for testing gsjhub is using a docker
container.

[https://github.com/osixia/docker-phpLDAPadmin](https://github.com/osixia/docker-phpLDAPadmin)
provides an 'all-in-one' solution. Here's the sample script to get up and going quickly:

    #!/bin/bash -e
        docker run -e LDAP_TLS=false --name ldap-service --hostname ldap-service --detach osixia/openldap:1.1.1
    
            docker run --name phpldapadmin-service --hostname phpldapadmin-service --link ldap-service:ldap-host --env PHPLDAPADMIN_LDAP_HOSTS=ldap-host --detach osixia/phpldapadmin:0.6.11
    
                PHPLDAP_IP=$(docker inspect -f "{{ .NetworkSettings.IPAddress }}" phpldapadmin-service)
    
                echo "Go to: https://$PHPLDAP_IP"
                echo "Login DN: cn=admin,dc=example,dc=org"
                echo "Password: admin"

### Local PostgreSQL
Using docker again you can have a quick PostgreSQL server up and running for testing:

    #!/bin/bash -e
        docker run -e POSTGRES_PASSWORD=abc1234 -e POSTGRES_USER=jupyterhub -e POSTGRES_DB=jupyterhub -P postgres:latest
- Docker for PostgreSQL
- ???

**STUB Not Complete**
