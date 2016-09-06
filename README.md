# JupyterHub and Notebook in Cloudfoundry

[Jupyterhub](https://github.com/jupyterhub/jupyterhub) requires Python 3.3 or
higher and NodeJS. This presents an issue when you attempt to run this app
in cloudfoundry. Cloudfoundry only supports one buildpack per application. 
You can run a python application or a node application, but not one that uses 
both.

Using the [heroku-buildpack-multi](https://github.com/ddollar/heroku-buildpack-multi) 
though, you can use multiple buildpacks in one app.

## Adding a buildpack

Then create a `.buildpacks` file specifying the buildpacks you'd like to use:

    https://github.com/jthomas/nodejs-v4-buildpack
    https://github.com/cloudfoundry/python-buildpack

## Starting the application

From this directory:

`$ cf push -u none`
Starts the jupyterhub.

# Jupyterhub without CloudFoundry

1. Install epel
2. Install nodejs, npm
3. Install postgresql-devel (needed for psychopg library)
3. npm install -g inherits
4. npm install -g configurable-http-proxy
5. Install python3
6. Install pip3 -> curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
    /usr/bin/python3 get-pip.py
7. Install python requirements -> /usr/bin/pip3 install -r requirements.txt
8. Add jupyterhub config to /etc/jupyterhub
9.  

## System Architecture

[The Jupyter Project](http://jupyter.org/) is 
>an open source, interactive data science and scientific computing across over 40 programming languages.

The Geoint Services deployment utilizes the following:

- [Jupyterhub](https://github.com/jupyterhub/jupyterhub) which coordinates and spawns multi-user notebooks.
- [Jupyter Notebook](https://github.com/jupyter/notebook) which is a web-based environment for interactive computing.
- [sudospawner](https://github.com/jupyterhub/sudospawner) which enables Jupyterhub to spawn user notebooks without needing to be run as root.
- [ldapauthenticator](https://github.com/jupyterhub/ldapauthenticator) which allows authentication of users using the LDAP protocol.
- [jupyterhub-ldacpcreateusers](https://github.com/benhosmer/jupyterhub-ldapcreateusers) which enables the LDAP Authenticator to create system users.

## Configuration

### `sudospawner`

[Official docs](https://github.com/jupyterhub/sudospawner) for the sudospawner with configuration
examples. **NOTE** CentOS bawks at the default config for jupyter. See laster in jupyter config.

A sample sudoers file for CentOS 7:

```
## Jupyterhub Settings ##
# comma-separated whitelist of users that can spawn single-user servers
Runas_Alias JUPYTER_USERS = ALL

# the command(s) the Hub can run on behalf of the above users without needing a password
# the exact path may differ, depending on how sudospawner was installed
Cmnd_Alias JUPYTER_CMD = /usr/bin/sudospawner, /sbin/useradd, /usr/sbin/useradd

# actually give the Hub user permission to run the above command on behalf
# of the above users without prompting for a password
hubadmin ALL=(JUPYTER_USERS) NOPASSWD:JUPYTER_CMD
```

### Jupyterhub Config

>>!cat jupyterhub-ldap_config.py

