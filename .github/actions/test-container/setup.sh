#!/usr/bin/env bash
set -Eeuo pipefail

APP="${1:?}"

if yq '.schemaVersion' "./apps/${APP}/tests.yaml" &>/dev/null; then
    gh release download --repo GoogleContainerTools/container-structure-test --pattern "*-linux-amd64" --output /usr/local/bin/container-structure-test
    chmod +x /usr/local/bin/container-structure-test
else
    gh release download --repo goss-org/goss --pattern "*-linux-amd64" --output /usr/local/bin/goss
    chmod +x /usr/local/bin/goss
    gh release download --repo goss-org/goss --pattern "dgoss" --output /usr/local/bin/dgoss
    chmod +x /usr/local/bin/dgoss
fi
