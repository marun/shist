#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# Enable switching to the local git repo of one or more of the
# operator shared libraries.

REPO_ROOT=$(dirname "${BASH_SOURCE[0]}")

if [[ "$#" -eq 0 ]]; then
  >&2 echo "Please supply one or more of {api,build-machinery-go,apiserver-library-go,client-go,library-go} as arguments."
  exit 1
fi

for library_repo in "$@"; do
  go mod edit -replace="github.com/openshift/${library_repo}=${REPO_ROOT}/${library_repo}"
done

go mod tidy

if [[ ! "${SHIST_NO_VENDOR}" ]]; then
  go mod vendor
fi
