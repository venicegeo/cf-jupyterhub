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

if [ -f *.deb ]; then
  rm *.deb
fi

if [ -f "jupyterhub_cookie_secret" ]; then
  rm "jupyterhub_cookie_secret"
fi


echo "Creating source directories..."
# Create the source directories
mkdir -p $NAME/etc/{systemd/system,$NAME}
mkdir -p $NAME/tmp
mkdir -p $NAME/var/run/gsjhub

# ADD the Pip Installer for portability to non-network systems
echo "Downloading Pip..."
curl -L https://bootstrap.pypa.io/get-pip.py -o $NAME/tmp/get-pip.py
cp -r requirements.txt $NAME/tmp/requirements.txt

echo "Downloading node modules..."
pushd $NAME/tmp
npm install --save configurable-http-proxy

echo "Downloading python modules..."
mkdir gsjhub-modules
/usr/bin/pip3.4 download -r ../tmp/requirements.txt -d gsjhub-modules
popd

echo "Adding jupyterhub config file..."
cp jupyterhub_config.py $NAME/etc/$NAME
echo "Adding systemd service file..."
cp gsjhub.service $NAME/etc/systemd/system

echo "Building the package..."

case "$PKGTYPE" in

# Build a deb package
deb)
  echo "Building deb..."
  /usr/local/bin/fpm -s dir -t deb -n $NAME -v $VERSION -C $NAME --after-install post-install.sh --after-remove post-remove.sh --before-install before-install.sh -d 'zlib1g-dev' -d 'libssl-dev' -d 'libsqlite3-dev' -d 'gcc' -d 'make' -d 'libpq-dev' --replaces $NAME-$VERSION --description 'Geoint Services Jupyterhub' --provides 'gsjhub' -p ./
  ;;
# Build an rpm package
rpm) 
  echo "Building rpm..."
  /usr/local/bin/fpm -s dir -t rpm -n $NAME -v $VERSION -C $NAME --after-install post-install.sh --after-remove post-remove.sh --before-install before-install.sh -d 'epel-release' -d 'python34' -d 'python34-devel' -d 'gcc' -d 'nodejs' -d 'npm' -d 'zlib-devel' -d'openssl-devel' -d 'sqlite-devel' -d 'postgresql-devel' --replaces $NAME --description 'Geoint Services Jupyterhub' --provides 'gsjhub' -p ./
  ;;
esac

#rm -rf $NAME
echo "Build complete!"

