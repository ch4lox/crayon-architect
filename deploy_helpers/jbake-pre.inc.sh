#!/usr/bin/env bash

# exit if any command fails
set -e

# Available variables are:
# $CRAYON_ARCHITECT_DIR = the directory of the crayon-architect tools
# $CRAYON_PROJECT_DIR = the directory to run the build tools in - uses pwd if undefined, this will be the working directory

export DEPLOY_BUILD_OUTPUT_PATH=$(grep -Eo '^destination\.folder\s*=\s*.+' "jbake.properties"|cut -d '=' -f 2|xargs)
if [ -z "${DEPLOY_OUTPUT_PATH}" ]; then
	export DEPLOY_OUTPUT_PATH="./output"
fi

if [ ! -d "${DEPLOY_OUTPUT_PATH}" ]; then
	export CRAYON_PRE_DEPLOY_SKIP="true";
	export CRAYON_CMD_DEPLOY_SKIP="true";
	
	echo "${DEPLOY_OUTPUT_PATH} does not exist!";
fi

if [ "$CRAYON_PRE_DEPLOY_SKIP" != "true" ]; then
	if [ ! -f "${DEPLOY_OUTPUT_PATH}/index.html" ]; then
		export CRAYON_PRE_DEPLOY_SKIP="true";
		export CRAYON_CMD_DEPLOY_SKIP="true";
	
		echo "${DEPLOY_OUTPUT_PATH}/index.html does not exist!";
	fi
fi


