#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# Updates the current repo to vendor the current commit hash of a
# local library repo. The commit hash is assumed to have already been
# pushed.

if [[ ! "$#" -eq 1 ]]; then
  >&2 echo "Usage: $0 <username>/<library-repo>"
  exit 1
fi

USER_REPO="${1}"
LIBRARY_REPO="$(basename "${USER_REPO}")"

pushd ../${LIBRARY_REPO} > /dev/null
  REPO_COMMIT="$(git log -n1 --format=format:"%H")"
popd > /dev/null

go mod edit -replace="github.com/openshift/${LIBRARY_REPO}=github.com/${USER_REPO}@${REPO_COMMIT}"

go mod tidy

if [[ ! "${SHIST_NO_VENDOR:-}" ]]; then
  go mod vendor
fi
