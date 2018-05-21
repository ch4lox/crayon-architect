# Purpose:
# This include script tries to make sure JBAKE_HOME is available
# and if not, it downloads jbake to CRAYON_ARCHITECT_DIR/cache/jbake,
# extracts it, and sets JBAKE_HOME
# 
# Expected Software:
# wget
# unzip
# jbake (optional, downloads if necessary)
#
# Expected Environment Variables:
# JBAKE_HOME (optional) = a variable holding the location of the jbake installation
# 
# Modifiable Environment Variables:
# JBAKE_HOME = a variable holding the location of the jbake installation
#
# The version of jbake to download if we don't have a JBAKE_HOME
if [ -z "$JBAKE_GET_VERSION" ]; then
	export JBAKE_GET_VERSION=2.5.0
fi
#
###########################################################################
# $CRAYON_ARCHITECT_DIR = the directory of the crayon-architect tools
# $CRAYON_PROJECT_DIR = the directory to run the build tools in - uses pwd if undefined, this will be the working directory

if [ -z "$JBAKE_HOME" ]; then
	echo "JBAKE_HOME is not set, so checking for cached download of jbake in ${CRAYON_ARCHITECT_DIR}/cache/jbake...";
	if [ ! -d "${CRAYON_ARCHITECT_DIR}/cache/jbake" ]; then
		mkdir -p "${CRAYON_ARCHITECT_DIR}/cache/jbake"
	fi
	
	if [ ! -f "${CRAYON_ARCHITECT_DIR}/cache/jbake/jbake-${JBAKE_GET_VERSION}/bin/jbake" ]; then
		if [ -f "${CRAYON_ARCHITECT_DIR}/cache/jbake/jbake-${JBAKE_GET_VERSION}.zip" ]; then
			echo "Removing old downloaded archive ${CRAYON_ARCHITECT_DIR}/cache/jbake/jbake-${JBAKE_GET_VERSION}.zip";
			rm -f "${CRAYON_ARCHITECT_DIR}/cache/jbake/jbake-${JBAKE_GET_VERSION}.zip"
		fi
		echo "Downloading and extracting http://jbake.org/files/jbake-${JBAKE_GET_VERSION}-bin.zip...";
		wget -O "${CRAYON_ARCHITECT_DIR}/cache/jbake/jbake-${JBAKE_GET_VERSION}.zip" "http://jbake.org/files/jbake-${JBAKE_GET_VERSION}-bin.zip"
		unzip -d "${CRAYON_ARCHITECT_DIR}/cache/jbake" "${CRAYON_ARCHITECT_DIR}/cache/jbake/jbake-${JBAKE_GET_VERSION}.zip"
	fi
	if [ ! -f "${CRAYON_ARCHITECT_DIR}/cache/jbake/jbake-${JBAKE_GET_VERSION}/bin/jbake" ]; then
		echo "Unable to find jbake binary at ${CRAYON_ARCHITECT_DIR}/cache/jbake/jbake-${JBAKE_GET_VERSION}/bin/jbake!"
		exit;
	fi
	
	echo "Setting JBAKE_HOME to downloaded version...";
	export JBAKE_HOME="${CRAYON_ARCHITECT_DIR}/cache/jbake/jbake-${JBAKE_GET_VERSION}"
fi

echo "JBAKE_HOME is ${JBAKE_HOME}";

