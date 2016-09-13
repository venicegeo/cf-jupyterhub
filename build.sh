#!/bin/bash

# Builder script for the Geointservices self-contained jupyterhub

NAME=gsjhub
VERSION=0.1.0
PKGTYPE=$1

if [ -z "$PKGTYPE" ]; then
  echo -e "\033[0;31m Requires package type of deb or rpm:"
  echo -e "$ ./build.sh [deb,rpm] \033[0m"
  exit 1
fi


# Make a clean environment
echo "Cleaning environment..."
if [ -d "$NAME" ]; then
  rm -rf "$NAME"
fi

if [ -f *.rpm ]; then
  rm *.rpm 
fi

if [ -f "jupyterhub_cookie_secret" ]; then
  rm "jupyterhub_cookie_secret"
fi


echo "Creating source directories..."
# Create the source directories
mkdir -p $NAME/opt/$NAME/{bin,include,lib}
mkdir -p $NAME/etc/{systemd/system,$NAME}
mkdir -p $NAME/tmp
mkdir -p $NAME/var/run/gsjhub

# ADD the Python Source and Pip Install for portability to non-network systems
echo "Downloading Python and Pip..."
curl -L https://www.python.org/ftp/python/3.4.5/Python-3.4.5.tgz -o $NAME/tmp/Python-3.4.5.tgz
curl -L https://bootstrap.pypa.io/get-pip.py -o $NAME/tmp/get-pip.py
cp -r requirements.txt $NAME/tmp

# Node and node modules
curl -L https://nodejs.org/dist/v4.5.0/node-v4.5.0-linux-x64.tar.xz -o node-v4.5.0-linux-x64.tar.xz
tar xvf node-v4.5.0-linux-x64.tar.xz
cp -r node-v4.5.0-linux-x64/bin/* $NAME/opt/$NAME/bin/
cp -r node-v4.5.0-linux-x64/include/* $NAME/opt/$NAME/include/
cp -r node-v4.5.0-linux-x64/lib/* $NAME/opt/$NAME/lib
cp -r node-v4.5.0-linux-x64/share/ $NAME/opt/$NAME
rm -rf node-v4.5.0-linux-x64/
rm -rf node-v4.5.0-linux-x64.tar.xz
echo "Installing node modules..."
$NAME/opt/$NAME/bin/npm install configurable-http-proxy -g --prefix $NAME/opt/$NAME

echo "Adding jupyterhub config file..."
cp jupyterhub_config.py $NAME/etc/$NAME
echo "Adding systemd service file..."
cp gsjhub.service $NAME/etc/systemd/system

echo "Building the package..."

case "$PKGTYPE" in

# Build a deb package
deb) echo "Debian package selected..."
  /usr/local/bin/fpm -s dir -t deb -n $NAME -v $VERSION -C $NAME --after-install post-install.sh --after-remove post-remove.sh --before-install before-install.sh -d 'zlib1g-dev' -d 'libssl-dev' -d 'libsqlite3-dev' -d 'gcc' -d 'make' -d 'libpq-dev' --replaces $NAME-$VERSION --description 'Geoint Services Jupyterhub' --provides 'gsjhub' -p ./
  ;;
# Build an rpm package
rpm) echo "RPM package selected..."
  /usr/local/bin/fpm -s dir -t rpm -n $NAME -v $VERSION -C $NAME --after-install post-install.sh --after-remove post-remove.sh --before-install before-install.sh -d 'zlib-devel' -d'openssl-devel' -d 'sqlite-devel' -d 'postgresql-devel' --replaces $NAME --description 'Geoint Services Jupyterhub' --provides 'gsjhub' -p ./
  ;;
esac

#rm -rf $NAME
echo "Build complete!"

