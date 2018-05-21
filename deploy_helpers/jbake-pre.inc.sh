#!/usr/bin/env bash
# Purpose:
# This script sets some environment variables based on the jbake configuration, to be used by other parts of the build
#
# Expected files:
# $CRAYON_PROJECT_DIR/jbake.properties - the jbake configuration for the project, this is processed to find the correct directories
#
# Modifiable Environment Variables:
# CRAYON_PRE_DEPLOY_SKIP = skip the following pre deploy sripts
# CRAYON_CMD_DEPLOY_SKIP = skip the deploy script
#
###########################################################################
# exit if any command fails
set -e

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


