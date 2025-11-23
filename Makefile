DOCKER_IMAGE := gitlab/gitlab-ce

all: build

bash:
	@source .env
	@docker run --rm --net=host -it gitlab/gitlab-ce:${GITLAB_CE_VERSION} /bin/sh

version:
	@docker run --rm --net=host -it gitlab/gitlab-ce:${GITLAB_CE_VERSION} /opt/gitlab/embedded/bin/psql --version

reconfigure:
	@docker compose exec gitlab gitlab-ctl reconfigure

backup:
	@docker compose exec gitlab gitlab-rake gitlab:backup:create

build:
	@bash scripts/buildEnv.sh

# ------------------------------------------------------------------------------
# Makefile Usage Guide
# ------------------------------------------------------------------------------

# make build
#   Generates required configuration files using scripts/buildEnv.sh.
#   Use this after modifying .env or template files.
#
# make bash
#   Launches a temporary GitLab CE container and opens a shell inside it.
#   Useful for debugging or inspecting the GitLab image.
#
# make version
#   Prints the PostgreSQL version bundled in the GitLab CE image.
#   Helpful before upgrades or compatibility checks.
#
# make reconfigure
#   Runs 'gitlab-ctl reconfigure' on the running GitLab container.
#   Apply this after modifying gitlab.rb or GitLab settings.
#
# make backup
#   Creates a full GitLab backup using gitlab-rake.
#   Recommended before upgrades or major configuration changes.
#
# Default: make
#   Equivalent to running 'make build'.
# ------------------------------------------------------------------------------
