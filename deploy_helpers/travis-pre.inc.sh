# Purpose:
# This script set the "skip deploy" option if it's a pull request
# 
# Expected Environment Variables:
# DEPLOY_FROM_BRANCH (optional) = This will determine if we're on the correct branch and should set CRAYON_CMD_DEPLOY_SKIP to true or false, defaults to master
# TRAVIS_BRANCH = This variable is set by travis to the branch we're making a pull request to or the branch being pushed
# TRAVIS_PULL_REQUEST = This variable is set by travis to a number if it is a pull request or false otherwise
#
# Modifiable Environment Variables:
# CRAYON_CMD_DEPLOY_SKIP = this variable is set to true if we're not building the actual DEPLOY_FROM_BRANCH branch
#
###########################################################################
# $CRAYON_ARCHITECT_DIR = the directory of the crayon-architect tools
# $CRAYON_PROJECT_DIR = the directory to run the build tools in - uses pwd if undefined, this will be the working directory

if [ -z ${TRAVIS_BRANCH+x} ]; then
	echo "TRAVIS_BRANCH is not set!"
	exit 1
fi
if [ -z ${TRAVIS_PULL_REQUEST+x} ]; then
        echo "TRAVIS_PULL_REQUEST is not set!"
        exit 1
fi
if [ -z ${DEPLOY_FROM_BRANCH+x} ]; then
	echo "DEPLOY_FROM_BRANCH is not set, setting to master"
	export DEPLOY_FROM_BRANCH="master"
fi


echo "TRAVIS_PULL_REQUEST is ${TRAVIS_PULL_REQUEST} and TRAVIS_BRANCH is ${TRAVIS_BRANCH} and DEPLOY_FROM_BRANCH is ${DEPLOY_FROM_BRANCH}"
if [ "$TRAVIS_PULL_REQUEST" = "false" ] && [ "$TRAVIS_BRANCH" = "$DEPLOY_FROM_BRANCH" ]; then
	echo "This build will be deployed, setting CRAYON_CMD_DEPLOY_SKIP to false"
	export CRAYON_CMD_DEPLOY_SKIP="false"
else 
	echo "This build will NOT be deployed, setting CRAYON_CMD_DEPLOY_SKIP to true"
	export CRAYON_CMD_DEPLOY_SKIP="true"
fi

