# Purpose:
# This script sets some environment variables based on the current git state
#
# Expected Software:
# git
#
# Modifiable Environment Variables:
# GIT_PENDING_CHANGES = true or false, are there local pending chanegs
# GIT_COMMIT_HASH = the most recent commit
# GIT_COMMIT_UNIXTIME = the most recent commit's unixtime
#
###########################################################################
# $CRAYON_ARCHITECT_DIR = the directory of the crayon-architect tools
# $CRAYON_PROJECT_DIR = the directory to run the build tools in - uses pwd if undefined, this will be the working directory

if [ "$(git ls-files --modified --others --exclude-standard)" != "" ]; then
	export GIT_PENDING_CHANGES="true"
else
	export GIT_PENDING_CHANGES="false"
fi
echo "GIT_PENDING_CHANGES is $GIT_PENDING_CHANGES"

export GIT_COMMIT_HASH=$(git rev-parse HEAD)
echo "GIT_COMMIT_HASH is $GIT_COMMIT_HASH"

export GIT_COMMIT_DATE=$(git show -s --format=%cD ${GIT_COMMIT_HASH})
echo "GIT_COMMIT_DATE is $GIT_COMMIT_DATE"

export GIT_COMMIT_UNIXTIME=$(git show -s --format=%ct ${GIT_COMMIT_HASH})
echo "GIT_COMMIT_UNIXTIME is $GIT_COMMIT_UNIXTIME"
