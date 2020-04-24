#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# Update shared libraries to master.

if [[ "$#" -eq 0 ]]; then
  >&2 echo "Please supply one or more of {api,build-machinery-go,apiserver-library-go,client-go,library-go} as arguments."
  exit 1
fi

for library_repo in "$@"; do
  go get "github.com/openshift/${library_repo}@master"
done

go mod tidy

if [[ ! "${SHIST_NO_VENDOR}" ]]; then
  go mod vendor
fi
