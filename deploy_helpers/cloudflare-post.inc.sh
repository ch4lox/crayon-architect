# This include script makes an API call to cloudflare using curl to purge CDN caches

# Available variables are:
# $CRAYON_ARCHITECT_DIR = the directory of the crayon-architect tools
# $CRAYON_PROJECT_DIR = the directory to run the build tools in - uses pwd if undefined, this will be the working directory
# $CRAYON_CMD_DEPLOY_SUCCESS = true or false if the command completed successfully

if [ "$CRAYON_CMD_DEPLOY_SUCCESS" = "false" ]; then
	echo "CRAYON_CMD_DEPLOY_SUCCESS is false, so skipping.";
fi
	if [ -z "$DEPLOY_CLOUDFLARE_ID" ]; then
		echo "DEPLOY_CLOUDFLARE_ID is not set!"
		echo "Also make sure you specify DEPLOY_CLOUDFLARE_EMAIL and DEPLOY_CLOUDFLARE_KEY!"
	else
		echo "Purging Cloudflare caches..."

		if [ -z "$DEPLOY_CLOUDFLARE_EMAIL" ]; then
			echo "DEPLOY_CLOUDFLARE_EMAIL environment variable not set";
		fi
		if [ -z "$DEPLOY_CLOUDFLARE_KEY" ]; then
			echo "DEPLOY_CLOUDFLARE_KEY environment variable not set";
		fi

		if [ ! -z "$DEPLOY_CLOUDFLARE_KEY" ] && [ ! -z "$DEPLOY_CLOUDFLARE_EMAIL" ]; then
		curl -X DELETE "https://api.cloudflare.com/client/v4/zones/${DEPLOY_CLOUDFLARE_ID}/purge_cache" -H "X-Auth-Email: ${DEPLOY_CLOUDFLARE_EMAIL}" -H "X-Auth-Key: ${DEPLOY_CLOUDFLARE_KEY}" -H "Content-Type: application/json" --data '{"purge_everything":true}'
		fi
	fi
fi
