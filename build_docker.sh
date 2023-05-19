#!/bin/bash
# Author: fmonera@opensistemas.com

MINOR=$1

V=16.0
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $V
ODOO_RELEASE=$( cat Dockerfile  | grep "ARG ODOO_RELEASE" | cut -d= -f2 ) 
ODOO_SHA=$(cat Dockerfile | grep "ARG ODOO_SHA" | cut -d= -f2 )

if test -f "$SCRIPT_DIR/config/env"; then
  source $SCRIPT_DIR/config/env 
else
  echo "ERROR: You must create a config/env file. There is an example in config/env.example."
  rm -rf $SCRIPT_DIR/build/*
  cd $SCRIPT_DIR
  exit
fi

echo "Current release: $ODOO_RELEASE"
echo "Current SHA: $ODOO_SHA"
echo "Added Minor Version: $MINOR"
echo "Docker tags: "
echo "  - $DOCKER_TAG:$ODOO_RELEASE$MINOR"
echo "  - $DOCKER_TAG:latest"
echo
echo "Press ENTER to start ..."
read a

echo $ODOO_RELEASE$MINOR > $SCRIPT_DIR/VERSION


# Build
cd $SCRIPT_DIR/$V
docker build -t $DOCKER_TAG:latest .
docker tag $DOCKER_TAG:latest $DOCKER_TAG:$ODOO_RELEASE$MINOR
docker push $DOCKER_TAG:$ODOO_RELEASE$MINOR
docker push $DOCKER_TAG:latest

echo "Uploaded:"
echo "  $DOCKER_TAG:$ODOO_RELEASE$MINOR"
echo "  $DOCKER_TAG:latest"

