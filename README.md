# Compose file for Gitlab Community Edition

[![License](https://img.shields.io/github/license/mgcrea/docker-compose-gitlab-ce.svg?style=flat)](https://tldrlegal.com/license/mit-license)
[![Docker Stars](https://img.shields.io/docker/stars/gitlab/gitlab-ce.svg)](https://registry.hub.docker.com/u/gitlab/gitlab-ce/)
[![Docker Pulls](https://img.shields.io/docker/pulls/gitlab/gitlab-ce.svg)](https://registry.hub.docker.com/u/gitlab/gitlab-ce/)

Working `docker-compose.yml` for official [gitlab-ce](https://hub.docker.com/r/gitlab/gitlab-ce) docker images leveraging separate instances for services:

- Uses official [postgres](https://hub.docker.com/_/postgres/) docker image
- Uses official [redis](https://hub.docker.com/_/redis/) docker image
- Comes with a [gitlab-runner](https://hub.docker.com/r/gitlab/gitlab-runner/) instance

Made to work behind a separate automated [nginx-proxy](https://github.com/jwilder/nginx-proxy) with SSL support via letsencrypt.

## Quickstart

- You can quickly start your compose gitlab instance (requires a working automated nginx_proxy compose instance)

```bash
git clone https://github.com/amaan-igs/docker-compose-gitlab-ce.git gitlab; cd $_
cp .env.default .env; nano .env
sudo rm volumes/postgres/.gitkeep  # Required: Remove .gitkeep to allow PostgreSQL initialization
make
docker compose up -d
```

## Register GitLab Runner

The compose file includes a GitLab Runner container, but it needs to be registered with your GitLab instance.

### Register the included runner

1. Go to `https://<yourdomain>/admin/runners` in your GitLab instance
2. Click on the three-dot menu next to the "New instance runner" button
3. Copy the registration token
4. Run the following command (replace `YOUR_TOKEN` with the copied token):

```bash
docker exec -it gitlab_runner gitlab-runner register \
  --non-interactive \
  --url "http://gitlab" \
  --registration-token "YOUR_TOKEN" \
  --executor "docker" \
  --docker-image "alpine:latest" \
  --description "docker-runner" \
  --tag-list "docker,linux" \
  --run-untagged="true" \
  --locked="false" \
  --docker-network-mode "docker-compose-gitlab-ce_default"
```

### Register external runners

For runners outside of this compose setup:

1. Go to `https://<yourdomain>/admin/runners`
2. Click on the three-dot menu next to "New instance runner"
3. Select "Show runner installation and registration instructions"
4. Follow the instructions for your platform

## Check postgres bundled version

```bash
source .env
docker run --rm -it gitlab/gitlab-ce:${GITLAB_CE_VERSION} postgres --version
```

## Templates

- [gitlab.rb](https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/files/gitlab-config-template/gitlab.rb.template)

## Related Documentation

- [Gitlab installation](https://docs.gitlab.com/ce/install/docker.html)
- [GitLab Docker images](https://docs.gitlab.com/omnibus/docker/)
- [GitLab CI Docker images](https://docs.gitlab.com/ce/ci/docker/using_docker_images.html)
- [Using a non-bundled web-server](https://docs.gitlab.com/omnibus/settings/nginx.html#using-a-non-bundled-web-server)
