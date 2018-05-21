#!/usr/bin/env bash
# Purpose:
# This script runs the "CLEAN" action - Used to clean any "output" build directories from the "BUILD" step
#
# Environment Variables Used:
# CRAYON_PRE_CLEAN = An array of scripts to source "pre" the action
# CRAYON_PRE_CLEAN_SKIP (modifable by included scripts) = If this is set, skip the next pre script(s)
# CRAYON_CMD_CLEAN = The actual command to run to perform the action
# CRAYON_CMD_CLEAN_SUCCESS = Set to true or false depending on a 0 (true) or non-zero (false) exit status from CRAYON_CMD_CLEAN
# CRAYON_CMD_CLEAN_SKIP (modifable by included scripts) = If this is set, skip the action
# CRAYON_POST_CLEAN = An array of scripts to source "post" the action
# CRAYON_POST_CLEAN_SKIP (modifable by included scripts) = If this is set, skip the next post script(s)
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

echo "Sourcing CRAYON_PRE_CLEAN files..."
for h in "${CRAYON_PRE_CLEAN[@]}"; do
	HELPER="${h}"
	if [ "${HELPER#./}" = "${HELPER}" ] && [ "${HELPER#/}" = "${HELPER}" ]; then
		HELPER="./${HELPER}"
	fi
		if [ "$CRAYON_PRE_CLEAN_SKIP" = "true" ]; then
			echo "CRAYON_PRE_CLEAN_SKIP is true, skipping ${HELPER}..."
		else
			echo "${HELPER}..."
			. "${HELPER}"
		fi
done

echo "Rereading ${CRAYON_ARCHITECT_CONF}..."
. "${CRAYON_ARCHITECT_CONF}"

if [ "$CRAYON_CMD_CLEAN_SKIP" = "true" ]; then
	echo "CRAYON_CMD_CLEAN_SKIP is true, skipping CRAYON_CMD_CLEAN and CRAYON_POST_CLEAN..."
else
	echo "Running ${CRAYON_CMD_CLEAN}..."
	if ${CRAYON_CMD_CLEAN}; then
		export CRAYON_CMD_CLEAN_SUCCESS="true"
	else 
		export CRAYON_CMD_CLEAN_SUCCESS="false"
	fi
	echo "CRAYON_CMD_CLEAN_SUCCESS is $CRAYON_CMD_CLEAN_SUCCESS"

        if [ "$CRAYON_CMD_CLEAN_SUCCESS" = "false"]; then
                exit 1;
        fi
	
	echo "Sourcing CRAYON_POST_CLEAN files..."
	for h in "${CRAYON_POST_CLEAN[@]}"; do
		HELPER="${h}"
		if [ "${HELPER#./}" = "${HELPER}" ] && [ "${HELPER#/}" = "${HELPER}" ]; then
			HELPER="./${HELPER}"
		fi
		if [ "$CRAYON_POST_CLEAN_SKIP" = "true" ]; then
			echo "CRAYON_POST_CLEAN_SKIP is true, skipping ${HELPER}..."
		else
			echo "${HELPER}..."
			. "${HELPER}"
		fi
	done
fi

echo Done.
