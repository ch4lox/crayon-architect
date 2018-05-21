# Purpose:
# This script set the "skip deploy" option if it's a pull request
# 
# Expected Environment Variables:
# TRAVIS_PULL_REQUEST (optional) = This variable is set to true if it is a pull request vs a push
#
# Modifiable Environment Variables:
# CRAYON_CMD_DEPLOY_SKIP = this variable is set to true if we're in a travis pull request build
#
###########################################################################
# $CRAYON_ARCHITECT_DIR = the directory of the crayon-architect tools
# $CRAYON_PROJECT_DIR = the directory to run the build tools in - uses pwd if undefined, this will be the working directory

if [ "$TRAVIS_PULL_REQUEST" = "true" ]; then
	echo "TRAVIS_PULL_REQUEST is true, setting CRAYON_CMD_DEPLOY_SKIP to true";
	export CRAYON_CMD_DEPLOY_SKIP="true"
fi

