#!/usr/bin/env bash
# Purpose:
# This script runs the "DEPLOY" action - Used to do the push / copy / etc step to get the build up
#
# Environment Variables Used:
# CRAYON_PRE_DEPLOY = An array of scripts to source "pre" the action
# CRAYON_PRE_DEPLOY_SKIP (modifable by included scripts) = If this is set, skip the next pre script(s)
# CRAYON_CMD_DEPLOY = The actual command to run to perform the action
# CRAYON_CMD_DEPLOY_SUCCESS = Set to true or false depending on a 0 (true) or non-zero (false) exit status from CRAYON_CMD_DEPLOY
# CRAYON_CMD_DEPLOY_SKIP (modifable by included scripts) = If this is set, skip the action
# CRAYON_POST_DEPLOY = An array of scripts to source "post" the action
# CRAYON_POST_DEPLOY_SKIP (modifable by included scripts) = If this is set, skip the next post script(s)
#
###########################################################################
# exit if any command fails
set -e

if [ -z "$CRAYON_ARCHITECT_DIR" ]; then
	export CRAYON_ARCHITECT_DIR=$(dirname "$(readlink -f "$0")")
fi
if [ -z "$CRAYON_PROJECT_DIR" ]; then
	export CRAYON_PROJECT_DIR=$(pwd)
fi
cd "${CRAYON_PROJECT_DIR}"

if [ -z "$CRAYON_ARCHITECT_CONF" ]; then
	export CRAYON_ARCHITECT_CONF="crayon-architect.conf.sh"
fi
if [ "${CRAYON_ARCHITECT_CONF#./}" = "${CRAYON_ARCHITECT_CONF}" ] && [ "${CRAYON_ARCHITECT_CONF#/}" = "${CRAYON_ARCHITECT_CONF}" ]; then
	export CRAYON_ARCHITECT_CONF="./${CRAYON_ARCHITECT_CONF}"
fi
if [ ! -f "${CRAYON_ARCHITECT_CONF}" ]; then
	echo "Unable to find ${CRAYON_ARCHITECT_CONF}"
fi
echo "Reading ${CRAYON_ARCHITECT_CONF}..."
. "${CRAYON_ARCHITECT_CONF}"

echo "Sourcing CRAYON_PRE_DEPLOY files..."
for h in "${CRAYON_PRE_DEPLOY[@]}"; do
	HELPER="${h}"
	if [ "${HELPER#./}" = "${HELPER}" ] && [ "${HELPER#/}" = "${HELPER}" ]; then
		HELPER="./${HELPER}"
	fi
		if [ "$CRAYON_PRE_DEPLOY_SKIP" = "true" ]; then
			echo "CRAYON_PRE_DEPLOY_SKIP is true, skipping ${HELPER}..."
		else
			echo "${HELPER}..."
			. "${HELPER}"
		fi
done

echo "Rereading ${CRAYON_ARCHITECT_CONF}..."
. "${CRAYON_ARCHITECT_CONF}"

if [ "$CRAYON_CMD_DEPLOY_SKIP" = "true" ]; then
	echo "CRAYON_CMD_DEPLOY_SKIP is true, skipping CRAYON_CMD_DEPLOY and CRAYON_POST_DEPLOY..."
else
	echo "Running ${CRAYON_CMD_DEPLOY}..."
	if ${CRAYON_CMD_DEPLOY}; then
		export CRAYON_CMD_DEPLOY_SUCCESS="true"
	else 
		export CRAYON_CMD_DEPLOY_SUCCESS="false"
	fi
	echo "CRAYON_CMD_DEPLOY_SUCCESS is $CRAYON_CMD_DEPLOY_SUCCESS"
	
	echo "Sourcing CRAYON_POST_DEPLOY files..."
	for h in "${CRAYON_POST_DEPLOY[@]}"; do
		HELPER="${h}"
		if [ "${HELPER#./}" = "${HELPER}" ] && [ "${HELPER#/}" = "${HELPER}" ]; then
			HELPER="./${HELPER}"
		fi
		if [ "$CRAYON_POST_DEPLOY_SKIP" = "true" ]; then
			echo "CRAYON_POST_DEPLOY_SKIP is true, skipping ${HELPER}..."
		else
			echo "${HELPER}..."
			. "${HELPER}"
		fi
	done
fi

echo Done.
if [ "$CRAYON_CMD_DEPLOY_SUCCESS" = "false"]; then
	exit 1;
fi

