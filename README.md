# crayon-architect
This tool is meant to standardize the way your web-site development is done by using two git repositories, a static site generator, and a continuous deployment tool such as Travis CI or Jenkins so your web-site has a complete history of changes. With this, you can always roll-back to previous versions by simply doing a git checkout of the older commit, and you can accept improvements to the website as pull requests and regenerate the site on merges.

## Overview
- **Repository A** - The source code / templates / markdown files / static web-site generator configuration for  your website resides here [Example](https://github.com/ch4lox/ch4lox-com)
	- crayon-architect is typically used as a git submodule in your web-site's source code repository
		`git submodule add https://github.com/ch4lox/crayon-architect`
	- You have a branch here (such as master) that becomes your website, you may accept pull-requests from others and when the pull-request is merged, a continuous deployment tool pulls the latest source code and and builds using the crayon-architect submodule build scripts
	- **./crayon-architect.conf.sh** - you must create this file from one of the examples in the crayon-architect directory or 
into your top-level directory
- **Repository B** - This is where your static website is generated and pushed to [Example](https://github.com/ch4lox/ch4lox.github.io)
- **Continuous Deployment Tool** - You would use a continous deployment tool such as https://travis-ci.org/ or https://jenkins.org/ to build your website whenever the source code changes using the crayon-architect shell scripts. See **crayon-architect/example_.travis.yml** for an example configuration with https://travis-ci.org/ch4lox/ch4lox-com

## Files in a typical usage scenario

crayon-architect starts with 1 continuous deployment config file (potentially optional), 1 crayon-architect config file (you copy from an example), 4 shell scripts which use the crayon-architect config file, and 4 helper directories containing additional scripts you can use.

***Each file is documented with comments explaining what they do and any environment variables you may provide to change their behavior.***

From the point of view of your source code directory with crayon-architect submodule:

- **./.travis.yml** - used by https://travis-ci.org/ to build your web-site, other continuous deployment tools would be configured differently. See **crayon-architect/example_.travis.yml** for an example.
- **./crayon-architect.conf.sh** - you must create this file from one of the examples in the crayon-architect directory
into your top-level directory
	- This file is "sourced" into the other shell scripts when they are executed.
	- This file should typically be in the working directory of your build (usually your top-level directory)
- **./crayon-architect/clean.sh** - cleans up any built artifact from the last build
- **./crayon-architect/serve.sh** - if your tool has a "preview-in-place" feature, you execute this script during development
- **./crayon-architect/build.sh** - executes your builder and generates your website
- **./crayon-architect/deploy.sh** - deploys / pushes the generated website to the final location
- **./crayon-architect/*_helpers/** - these directories contain helper scripts for the four main tools to use
