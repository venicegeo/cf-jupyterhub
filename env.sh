# Geoint Services Jupyterhub environment config file
HUBPORT=8080
APIPORT=8081
DBHOST=10.0.1.4
DBUSER=jupyter
DBPASS=abc1234
DBPORT=32768
DBNAME=jhub

LDAPSERVERADDR='192.168.33.64'
LDAPSERVERPORT=389
LDAPBINDTMPL='uid={username},dc=rbtcloud,dc=dev'
LDAPSSL=False

PATH=/opt/gsjhub/bin:$PATH
