#!/usr/bin/env bash

# exit if any command fails
set -e

# Available variables are:
# $CRAYON_ARCHITECT_DIR = the directory of the crayon-architect tools
# $CRAYON_PROJECT_DIR = the directory to run the build tools in - uses pwd if undefined, this will be the working directory

if [ ! -f "jbake.properties" ]; then
	echo "Unable to find jbake.properties in $(pwd)"
	exit 1;
fi

BUILD_CACHE_SETTING=$(grep -Eo '^db\.store\s*=\s*.+' "jbake.properties"|cut -d '=' -f 2|xargs)
if [ -z "${BUILD_CACHE_SETTING}" ]; then
	BUILD_CACHE_SETTING="memory"
fi

BUILD_CACHE_PATH=$(grep -Eo '^db\.path\s*=\s*.+' "jbake.properties"|cut -d '=' -f 2|xargs)
if [ -z "${BUILD_CACHE_PATH}" ]; then
	BUILD_CACHE_PATH="./cache"
fi

BUILD_OUTPUT_PATH=$(grep -Eo '^destination\.folder\s*=\s*.+' "jbake.properties"|cut -d '=' -f 2|xargs)
if [ -z "${BUILD_OUTPUT_PATH}" ]; then
	BUILD_OUTPUT_PATH="./output"
fi

if [ "${BUILD_CACHE_SETTING}" = "local" ]; then
	if [ -d "${BUILD_CACHE_PATH}" ]; then
		echo "Removing ${BUILD_CACHE_PATH}...";
		rm -rf "${BUILD_CACHE_PATH}"
	else
		echo "${BUILD_CACHE_PATH} already gone.";
	fi
fi

if [ -d "${BUILD_OUTPUT_PATH}" ]; then
	echo "Removing ${BUILD_OUTPUT_PATH}...";
	rm -rf "${BUILD_OUTPUT_PATH}"
else 
	echo "${BUILD_OUTPUT_PATH} already gone.";
fi

