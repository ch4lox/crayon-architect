#!/usr/bin/env bash

# exit if any command fails
set -e

# Available variables are:
# $CRAYON_ARCHITECT_DIR = the directory of the crayon-architect tools
# $CRAYON_PROJECT_DIR = the directory to run the build tools in - uses pwd if undefined, this will be the working directory

if [ -z $DEPLOY_BUILD_OUTPUT_DIR ]; then
	echo "DEPLOY_BUILD_OUTPUT_DIR is not specified!"
	exit 1
fi
if [ -z $DEPLOY_REPO ]; then
	echo "DEPLOY_REPO is not specified!"
	exit 1
fi

if [ ! -z "$DEPLOY_SSH_PRIVATE_KEY" ]; then
	echo "Found DEPLOY_SSH_PRIVATE_KEY environment variable, creating file for ssh authorization!"
	eval "$(ssh-agent -s)"
	
	# Take this variable and dump its contents into a file in the correct format for ssh
	DEPLOY_SSH_PRIVATE_KEY_FILE=$(mktemp)
	chmod 600 $DEPLOY_SSH_PRIVATE_KEY_FILE
	echo $DEPLOY_SSH_PRIVATE_KEY|grep -Eo '\-----[^-]+-----'|head -n 1 > $DEPLOY_SSH_PRIVATE_KEY_FILE
	echo $DEPLOY_SSH_PRIVATE_KEY|grep -Eo '[^-]{64,}'|grep -Eo '.{,64}' >> $DEPLOY_SSH_PRIVATE_KEY_FILE
	echo $DEPLOY_SSH_PRIVATE_KEY|grep -Eo '\-----[^-]+-----'|tail -n 1 >> $DEPLOY_SSH_PRIVATE_KEY_FILE
	ssh-add $DEPLOY_SSH_PRIVATE_KEY_FILE
	rm "${DEPLOY_SSH_PRIVATE_KEY_FILE}"
fi

TEMP_DIR=$(mktemp -d)

if [ ! -z "$DEPLOY_BRANCH" ]; then
	git clone --depth 1 -b "${DEPLOY_BRANCH}" "${DEPLOY_REPO}" "${TEMP_DIR}"
else
	git clone --depth 1 "${DEPLOY_REPO}" "${TEMP_DIR}"
fi

echo "Rsyncing changes including deletions from '${DEPLOY_BUILD_OUTPUT_DIR}' to '${TEMP_DIR}'..."
rsync -av --del --exclude='/.git' --exclude='/README.md' --exclude='CNAME' "${DEPLOY_BUILD_OUTPUT_DIR}" "${TEMP_DIR}"

cd "${TEMP_DIR}"

git add --all .
git commit -m "Deployed using crayon-architect by ${USER} on $(hostname -s) at $(date)"
git -c push.default=simple push

cd -
rm -rf "${TEMP_DIR}"
