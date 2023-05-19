#!/bin/bash
# Author: fmonera@opensistemas.com

V=16.0
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ODOO_RELEASE=$(cat ./$V/Dockerfile | grep "ENV ODO_RELEASE" | cut -d= -f2)
ODOO_SHA=$(cat ./$V/Dockerfile | grep "ENV ODO_SHA" | cut -d= -f2)

if test -f "$SCRIPT_DIR/config/env"; then
  source $SCRIPT_DIR/config/env 
else
  echo "ERROR: You must create a config/env file. There is an example in config/env.example."
  rm -rf $SCRIPT_DIR/build/*
  cd $SCRIPT_DIR
  exit
fi

echo "Current release: $ODO_RELEASE"
echo "Current SHA: $ODO_SHA"
echo "Docker tag: $DOCKER_TAG"
echo "App Image: $APP_IMAGE"
echo
echo "Press ENTER to start ..."
read a

echo $ODO_RELEASE > $SCRIPT_DIR/VERSION


# Build
cd $SCRIPT_DIR/$V
docker build -t $DOCKER_TAG:latest .
docker tag $DOCKER_TAG:latest $DOCKER_TAG:$ODO_RELEASE
docker push $DOCKER_TAG:$ODO_RELEASE
docker push $DOCKER_TAG:latest

echo "Uploaded:"
echo "  $DOCKER_TAG:$ODO_RELEASE"
echo "  $DOCKER_TAG:latest"

