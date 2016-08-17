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

