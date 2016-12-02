# Available variables are:
# $CRAYON_ARCHITECT_DIR = the directory of the crayon-architect tools
# $CRAYON_PROJECT_DIR = the directory to run the build tools in - uses pwd if undefined, this will be the working directory

if [ "$TRAVIS_PULL_REQUEST" = "true" ]; then
	echo "TRAVIS_PULL_REQUEST is true, setting CRAYON_CMD_DEPLOY_SKIP to true";
	export CRAYON_CMD_DEPLOY_SKIP="true"
fi

