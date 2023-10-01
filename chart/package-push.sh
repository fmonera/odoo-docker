#!/bin/bash
PACKAGE=$1

if [ "X$1" == "X" ]
then
	echo "Specify the package name as a parameter."
	exit
fi

cd $PACKAGE
helm dependency update
cd ..

echo "Packaging ..."
rm -f *tgz
helm package $PACKAGE

P="$(ls *tgz)"

if [ "X$P" == "X" ]
then
	echo "Error generating package."
	exit 1
fi

echo "Pushing package $P ..."

helm push $P oci://reg.paperxp.com/charts
helm repo update

