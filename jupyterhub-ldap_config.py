# gsjhub configuration file for jupyterhub
# NOTE: Documents configuration using LDAP, allowing authenticated LDAP users
# to be created, SUDOSPAWNER, and PostgreSQL for peristent storage.
# Also can be configured to use environment variables for connect variables.

import os
import ast
c = get_config()

# Set the log level by value or name.
c.JupyterHub.log_level = 'DEBUG'

# Enable debug-logging of the single-user server
c.Spawner.debug = True

# Enable debug-logging of the single-user server
c.LocalProcessSpawner.debug = True

c.SudoSpawner.debug_mediator = True

# LDAP Authentication

# Uncomment to use environment variables
#ldap_server_address = os.getenv('LDAPSERVERADDR')
#ldap_server_port = os.getenv('LDAPSERVERPORT')
#ldap_use_ssl = ast.literal_eval(os.getenv('LDAPSSL'))
#ldap_bind_templ = os.getenv('LDAPBINDTMPL')

# Comment out to use environment variables.
c.JupyterHub.authenticator_class = 'ldapcreateusers.LocalLDAPCreateUsers'
c.LocalLDAPCreateUsers.server_address = '10.0.1.4'
c.LocalLDAPCreateUsers.server_port = 32771
c.LocalLDAPCreateUsers.use_ssl = False
c.LocalLDAPCreateUsers.bind_dn_template = 'uid={username},dc=example,dc=org'
c.LocalLDAPCreateUsers.create_system_users = True


# Confirm that JupyterHub should be run without SSL. This is **NOT RECOMMENDED**
# unless SSL termination is being handled by another layer.
# c.JupyterHub.confirm_no_ssl = False
c.JupyterHub.confirm_no_ssl = True

# Uncomment to use environment variables.
# url for the database. e.g. `sqlite:///jupyterhub.sqlite`
#db_pass = os.getenv('DBPASS')
#db_host = os.getenv('DBHOST')
#db_port = os.getenv('DBPORT', '5432')
#db_user = os.getenv('DBUSER')
#db_name = os.getenv('DBNAME')
#c.JupyterHub.db_url = 'postgresql://{}:{}@{}:{}/{}'.format(
#    db_user,
#    db_pass,
#    db_host,
#    db_port,
#    db_name,
#)

db_pass = os.getenv('jupyter')
db_host = os.getenv('jupyter')
db_port = os.getenv('5432')
db_user = os.getenv('jupyter')
db_name = os.getenv('jupyter')
c.JupyterHub.db_url = 'postgresql://{}:{}@{}:{}/{}'.format(
    db_user,
    db_pass,
    db_host,
    db_port,
    db_name,
)

# log all database transactions. This has A LOT of output
# c.JupyterHub.debug_db = False


# The ip for this process
# c.JupyterHub.hub_ip = '127.0.0.1'
c.JupyterHub.hub_ip = '0.0.0.0'

# The port for this process
# c.JupyterHub.hub_port = 8081
c.JupyterHub.hub_port = 8081

# The prefix for the hub server. Must not be '/'
# c.JupyterHub.hub_prefix = '/hub/'

# The public facing ip of the whole application (the proxy)
# c.JupyterHub.ip = ''
c.JupyterHub.ip = '0.0.0.0'


# The public facing port of the proxy
# c.JupyterHub.port = 8000
c.JupyterHub.port = 8080

# The ip for the proxy API handlers
# c.JupyterHub.proxy_api_ip = '127.0.0.1'
c.JupyterHub.proxy_api_ip = '0.0.0.0'

# The port for the proxy API handlers
# c.JupyterHub.proxy_api_port = 0
c.JupyterHub.proxy_api_port = 8082


# The class to use for spawning single-user servers.
# 
# Should be a subclass of Spawner.
# c.JupyterHub.spawner_class = 'jupyterhub.spawner.LocalProcessSpawner'
c.JupyterHub.spawner_class='sudospawner.SudoSpawner'


# The IP address (or hostname) the single-user server should listen on
# c.Spawner.ip = '127.0.0.1'
c.Spawner.ip = '0.0.0.0'


#------------------------------------------------------------------------------
# Authenticator configuration
#------------------------------------------------------------------------------

# A class for authentication.
# 
# The primary API is one method, `authenticate`, a tornado coroutine for
# authenticating users.

# set of usernames of admin users
# 
# If unspecified, only the user that launches the server will be admin.
# c.Authenticator.admin_users = set()
c.Authenticator.admin_users = {'vagrant'}

# Username whitelist.
# 
# Use this to restrict which users can login. If empty, allow any user to
# attempt login.
c.Authenticator.whitelist = set()
#c.Authenticator.whitelist = {'vagrant', 'admin'}

#------------------------------------------------------------------------------
# LocalAuthenticator configuration
#------------------------------------------------------------------------------

# Base class for Authenticators that work with local Linux/UNIX users
# 
# Checks for local users, and can attempt to create them if they exist.

# The command to use for creating users as a list of strings.
# 
# For each element in the list, the string USERNAME will be replaced with the
# user's username. The username will also be appended as the final argument.
# 
# For Linux, the default value is:
# 
#     ['adduser', '-q', '--gecos', '""', '--disabled-password']
# 
# To specify a custom home directory, set this to:
# 
#     ['adduser', '-q', '--gecos', '""', '--home', '/customhome/USERNAME',
# '--disabled-password']
# 
# This will run the command:
# 
# adduser -q --gecos "" --home /customhome/river --disabled-password river
# 
# when the user 'river' is created.
c.LocalAuthenticator.add_user_cmd = ['/usr/bin/sudo', '/usr/sbin/useradd']

# If a user is added that doesn't exist on the system, should I try to create
# the system user?
c.LocalAuthenticator.create_system_users = True

# Automatically whitelist anyone in this group.
# c.LocalAuthenticator.group_whitelist = set()

#------------------------------------------------------------------------------
# PAMAuthenticator configuration
#------------------------------------------------------------------------------

# Authenticate local Linux/UNIX users with PAM

# The encoding to use for PAM
# c.PAMAuthenticator.encoding = 'utf8'

# Whether to open PAM sessions when spawners are started.
# 
# This may trigger things like mounting shared filsystems, loading credentials,
# etc. depending on system configuration, but it does not always work.
# 
# It can be disabled with::
# 
#     c.PAMAuthenticator.open_sessions = False
c.PAMAuthenticator.open_sessions = True

# The PAM service to use for authentication.
c.PAMAuthenticator.service = 'login'

