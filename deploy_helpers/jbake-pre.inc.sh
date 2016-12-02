#!/usr/bin/env bash

# exit if any command fails
set -e

# Available variables are:
# $CRAYON_ARCHITECT_DIR = the directory of the crayon-architect tools
# $CRAYON_PROJECT_DIR = the directory to run the build tools in - uses pwd if undefined, this will be the working directory

export DEPLOY_BUILD_OUTPUT_DIR=$(grep -Eo '^destination\.folder\s*=\s*.+' "jbake.properties"|cut -d '=' -f 2|xargs)
if [ -z "${DEPLOY_BUILD_OUTPUT_DIR}" ]; then
	export DEPLOY_BUILD_OUTPUT_DIR="./output"
fi
echo "DEPLOY_BUILD_OUTPUT_DIR is $DEPLOY_BUILD_OUTPUT_DIR"

if [ ! -d "${DEPLOY_BUILD_OUTPUT_DIR}" ]; then
	export CRAYON_PRE_DEPLOY_SKIP="true";
	export CRAYON_CMD_DEPLOY_SKIP="true";
	
	echo "${DEPLOY_BUILD_OUTPUT_DIR} does not exist!";
fi

if [ "$CRAYON_PRE_DEPLOY_SKIP" != "true" ]; then
	if [ ! -f "${DEPLOY_BUILD_OUTPUT_DIR}/index.html" ]; then
		export CRAYON_PRE_DEPLOY_SKIP="true";
		export CRAYON_CMD_DEPLOY_SKIP="true";
	
		echo "${DEPLOY_BUILD_OUTPUT_DIR}/index.html does not exist!";
	fi
fi


