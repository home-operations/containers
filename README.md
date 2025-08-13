<div align="center">

## Containers

_An opinionated collection of container images_

</div>

<div align="center">

![GitHub Repo stars](https://img.shields.io/github/stars/home-operations/containers?style=for-the-badge)
![GitHub forks](https://img.shields.io/github/forks/home-operations/containers?style=for-the-badge)
![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/home-operations/containers/release.yaml?style=for-the-badge&label=Release)

</div>

Welcome to our container images! If you are looking for a container, start by [browsing the GitHub Packages page for this repository's packages](https://github.com/orgs/home-operations/packages?repo_name=containers).

## Mission Statement

Our goal is to provide [semantically versioned](https://semver.org/), [rootless](https://rootlesscontaine.rs/), and [multi-architecture](https://www.docker.com/blog/multi-arch-build-and-images-the-simple-way/) containers for various applications.

We adhere to the [KISS principle](https://en.wikipedia.org/wiki/KISS_principle), logging to stdout, maintaining [one process per container](https://testdriven.io/tips/59de3279-4a2d-4556-9cd0-b444249ed31e/), avoiding tools like [s6-overlay](https://github.com/just-containers/s6-overlay), and building all images on top of [Alpine](https://hub.docker.com/_/alpine) or [Ubuntu](https://hub.docker.com/_/ubuntu).

## Features

### Tag Immutability

Containers built here do not use immutable tags in the traditional sense, as seen with [linuxserver.io](https://fleet.linuxserver.io/) or [Bitnami](https://bitnami.com/stacks/containers). Instead, we insist on pinning to the `sha256` digest of the image. While this approach is less visually appealing, it ensures functionality and immutability.

| Container | Immutable |
|-----------------------|----|
| `ghcr.io/home-operations/home-assistant:rolling` | ❌ |
| `ghcr.io/home-operations/home-assistant:2025.5.1` | ❌ |
| `ghcr.io/home-operations/home-assistant:rolling@sha256:8053...` | ✅ |
| `ghcr.io/home-operations/home-assistant:2025.5.1@sha256:8053...` | ✅ |

_If pinning an image to the `sha256` digest, tools like [Renovate](https://github.com/renovatebot/renovate) can update containers based on digest or version changes._

### Rootless

By default the majority of our containers run as a non-root user (`65534:65534`), you are able to change the user/group by updating your configuration files.

#### Docker Compose

```yaml
services:
  home-assistant:
    image: ghcr.io/home-operations/home-assistant:2025.5.1
    container_name: home-assistant
    user: 1000:1000 # The data volume permissions must match this user:group
    read_only: true # May require mounting in additional dirs as tmpfs
    tmpfs:
      - /tmp:rw
    # ...
```

#### Kubernetes

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: home-assistant
# ...
spec:
  # ...
  template:
    # ...
    spec:
      containers:
        - name: home-assistant
          image: ghcr.io/home-operations/home-assistant:2025.5.1
          securityContext: # May require mounting in additional dirs as emptyDir
            allowPrivilegeEscalation: false
            capabilities:
              drop:
                - ALL
            readOnlyRootFilesystem: true
          volumeMounts:
            - name: tmp
              mountPath: /tmp
      # ...
      securityContext:
        runAsUser: 1000
        runAsGroup: 1000
        fsGroup: 65534 # (Requires CSI support)
        fsGroupChangePolicy: OnRootMismatch # (Requires CSI support)
      volumes:
        - name: tmp
          emptyDir: {}
      # ...
# ...
```

### Passing Arguments to Applications

Some applications only allow certain configurations via command-line arguments rather than environment variables. For such cases, refer to the Kubernetes documentation on [defining commands and arguments for a container](https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/). Then, specify the desired arguments as shown below:

```yaml
args:
  - --port
  - "8080"
```

### Configuration Volume

For applications requiring persistent configuration data, the configuration volume is hardcoded to `/config` within the container. In most cases, this path cannot be changed.

### Verify Image Signature

These container images are signed using the [attest-build-provenance](https://github.com/actions/attest-build-provenance) action.

To verify that the image was built by GitHub CI, use the following command:

```sh
gh attestation verify --repo home-operations/containers oci://ghcr.io/home-operations/${APP}:${TAG}
```

or by using [cosign](https://github.com/sigstore/cosign):

```sh
cosign verify-attestation --new-bundle-format --type slsaprovenance1 \
    --certificate-oidc-issuer "https://token.actions.githubusercontent.com" \
    --certificate-identity-regexp "^https://github.com/home-operations/containers/.github/workflows/app-builder.yaml@refs/heads/main" \
    ghcr.io/home-operations/${APP}:${TAG}
```

### Eschewed Features

This repository does not support multiple "channels" for the same application. For example:

- **Prowlarr**, **Radarr**, **Lidarr**, and **Sonarr** only publish the **develop** branch, not the **master** (stable) branch.
- **qBittorrent** is only published with **LibTorrent 2.x**.

This approach ensures consistency and focuses on streamlined builds.

## Contributing

We encourage the use of official upstream container images whenever possible. However, contributing to this repository might make sense if:

- The upstream application is **actively maintained**.
- **And** one of the following applies:
  - No official upstream container exists.
  - The official image does not support **multi-architecture builds**.
  - The official image uses tools like **s6-overlay**, **gosu**, or other unconventional initialization mechanisms.

## Deprecations

Containers in this repository may be deprecated for the following reasons:

1. The upstream application is **no longer actively maintained**.
2. An **official upstream container exists** that aligns with this repository's mission statement.
3. The **maintenance burden** is unsustainable, such as frequent build failures or instability.

**Note**: Deprecated containers will be announced with a release and remain available in the registry for 6 months before removal.

## Maintaining a Fork

Forking this repository is straightforward. Keep the following in mind:

1. **Renovate Bot**: Set up a GitHub Bot for Renovate by following the instructions [here](https://github.com/renovatebot/github-action).
2. **Renovate Configuration**: Configuration files are located in the [`.github`](https://github.com/home-operations/.github) and [renovate-config](https://github.com/home-operations/renovate-config) repositories.
3. **Lowercase Naming**: Ensure your GitHub username/organization and repository names are entirely lowercase to comply with GHCR requirements. Rename them or update workflows as needed.

## Credits

This repository draws inspiration and ideas from the home-ops community, [hotio.dev](https://hotio.dev/), and [linuxserver.io](https://www.linuxserver.io/) contributors.
