# Geoint Service Jupyterhub


[Jupyterhub](https://github.com/jupyterhub/jupyterhub) allows users to share,
evaluate, and test code in self-contained browser-based environments.

The Geoint Services _gsjhub_ project packages Jupyterhub along with 
all the required dependencies in an easily installable package suitable
for even non-networked systems. All dependencies not included in the package
are available from upstream repositories available within the operating systems
respective package manager.

## Target Requirements
Jupyterhub requires NodeJS, NPM,  Python3.4, Pip3.4 along with quite a few Python packages
available from [pypi](https://pypi.org). The Node module, `configurable-http-proxy`
is also required. The package installer takes care of all of this for you though.

## Building the Package
The build requires [FPM](https://github.com/jordansissel/fpm).

> FPM helps you build packages quickly and easily (Packages like RPM and DEB formats).

### Installing FPM on the Build Machine
*CentOS 7*:
FPM can be installed as a Ruby Gem:

    # yum -y install ruby ruby-devel
    # gem install fpm

*Debian*:
FPM can be installed as a Ruby Gem:
    # aptitude install ruby ruby-dev gcc make
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
and then install gsjhub: `# yum -y install gsjhub-xxx-x.x86_64.rpm`

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
3. The required node and python modules are installed from the RPM using the 
system Python and Nodejs.
4. A _gsjhub_ user is created on the system and given limited sudo privileges (only useradd and sudospawner are granted)
5. A systemd service file is added to `/usr/lib/systemd/system/`
6. The Jupyterhub config file is added to `/etc/gsjhub`

### Debian/Ubuntu
The following packages are required prior to installation of the gsjhub package:

- python3.4
- python3.4-dev
- libssl-dev
- libsqlite3-dev
- libpq-dev
- nodejs
- npm

Then install the gsjhub package `# dpkg -i gsjhub_x.x.x_amd64.deb`

**Still needs work**

## Configuration after installation

The _gsjhub_ package installs the default `jupyterhub_config.py` in `/etc/gsjhub`.
Starting the `gsjhub` service without modifying the configuration file will fail
since Jupyterhub will refuse to start without SSL enabled. 

You should modify this configuration file to suit your particular environment.

This example outlines configuration settings for:

- LDAP Authentication using [jupyterhub-ldapauthenticator](https://pypi.python.org/pypi/jupyterhub-ldapauthenticator/1.0).
- Using [sudospawner](https://github.com/jupyterhub/sudospawner) so the service 
doesn't need to run as root.
- Using an external PostgreSQL Database for storage.
- Allowing users authenticated through LDAP to have system accounts created
if they don't already exist with [jupyterhub-ldapcreateusers](https://pypi.python.org/pypi/jupyterhub-ldapcreateusers).

You can also find this sample config in `/usr/share/doc/gsjhub-$VERSION`.

### Behind a Proxy that has SSL Already

```
c.JupyterHub.confirm_no_ssl = True
```

### LDAP Authentication using [ldapauthenticator](https://github.com/jupyterhub/ldapauthenticator)

```
c.JupyterHub.authenticator_class = 'ldapauthenticator.LDAPAuthenticator'
c.LDAPAuthenticator.server_address = '192.168.22.100'
c.LDAPAuthenticator.server_port = 389
c.LDAPAuthenticator.use_ssl = False
c.LDAPAuthenticator.bind_dn_template = 'uid={username},ou=people,dc=wikimedia,dc=org'
```

### LDAP Authentication _and_ Creation of System Users with SSL

This option utilizes the [jupyterhub-ldapcreateusers](https://pypi.python.org/pypi?%3Aaction=pkg_edit&name=jupyterhub-ldapcreateusers) module.

```
c.JupyterHub.authenticator_class = 'ldapcreateusers.LocalLDAPCreateUsers'
c.LocalLDAPCreateUsers.server_address = '192.168.33.64'
c.LocalLDAPCreateUsers.server_port = 634
c.LocalLDAPCreateUsers.use_ssl = True
c.LocalLDAPCreateUsers.bind_dn_template = 'uid={username},dc=geointservices,dc=io'
c.LocalLDAPCreateUsers.create_system_users = True
```

### PostgreSQL Configuration

```
# url for the database. e.g. `sqlite:///jupyterhub.sqlite`
db_pass = 'secretpassword'
db_host = 'yourdb.com'
db_port = '5432'
db_user = 'dbusername'
db_name = 'dbname'
c.JupyterHub.db_url = 'postgresql://{}:{}@{}:{}/{}'.format(
    db_user,
    db_pass,
    db_host,
    db_port,
    db_name,
)
```

### With [sudospawner](https://github.com/jupyterhub/sudospawner)

```
c.JupyterHub.spawner_class='sudospawner.SudoSpawner'
c.LocalAuthenticator.add_user_cmd = ['/usr/bin/sudo', '/usr/sbin/useradd']

# If a user is added that doesn't exist on the system, should I try to create
# the system user?
c.LocalAuthenticator.create_system_users = True
c.PAMAuthenticator.open_sessions = True
c.PAMAuthenticator.service = 'login
```

### Whitelist and Admin User(s)
Without setting an _admin_ user, no one will be able to administer the
jupyterhub. You likely will want at least one user:

```
c.Authenticator.admin_users = {'mjones'}
```

You can also _whitelist_ users to allow allow them to login:

```
c.Authenticator.whitelist = {'jsmith', 'epickle'}
```

To allow _any_ authenticated users:

```
c.Authenticator.whitelist = set()
```

## Local Development
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

### Enabling and Starting the _gsjhub_ service
After editing the configuration file located in `/etc/gsjhub/jupterhub_config.py` 
you're now ready to start the service.

First, enable it to survive reboots:

`# systemctl enable gsjhub`

Now start the service:

`# systemctl start gsjhub`

Verify the service started:

`# systemctl status gsjhub`
    ...
    ● gsjhub.service - Geoint Services Jupyterhub
       Loaded: loaded (/etc/systemd/system/gsjhub.service; disabled; vendor preset: disabled)
       Active: active (running) since Fri 2016-09-16 12:49:58 EDT; 6s ago
     Main PID: 19352 (jupyterhub)
       CGroup: /system.slice/gsjhub.service
               ├─19352 /usr/bin/python3 /usr/bin/jupyterhub -f /etc/gsjhub/jupyterhub_config.py
               └─19356 node /usr/bin/configurable-http-proxy --ip 0.0.0.0 --port 8080 --api-ip 0.0.0.0 --a...

