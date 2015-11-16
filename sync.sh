#!/bin/sh
set -e
src=~/Desktop/src/fire

rm -rf fire fire.xcodeproj
mkdir -p fire.xcodeproj

cp -av $src/fire fire
cp -v $src/fire.xcodeproj/project.pbxproj fire.xcodeproj/
cp -v $src/README.adoc .
