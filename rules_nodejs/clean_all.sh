#!/usr/bin/env bash

set -eux -o pipefail
# -e: exits if a command fails
# -u: errors if an variable is referenced before being set
# -x: shows the commands that get run
# -o pipefail: causes a pipeline to produce a failure return code if any command errors

rm -rf ./node_modules
rm -rf ./internal/test/node_modules
rm -rf ./internal/npm_install/test/package/node_modules

bazel clean --expunge

for rootDir in examples e2e internal/e2e packages ; do
  (
    cd $rootDir
    for subDir in $(ls) ; do
      [[ -d "$subDir" ]] || continue
      (
        cd $subDir
        if [[ -e 'WORKSPACE' ]] ; then
          printf "\n\nCleaning /$rootDir/$subDir\n"
          bazel clean --expunge
          rm -rf node_modules
        fi
      )
    done
  )
done
