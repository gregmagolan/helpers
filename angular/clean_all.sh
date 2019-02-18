#!/usr/bin/env bash

set -eux -o pipefail
# -e: exits if a command fails
# -u: errors if an variable is referenced before being set
# -x: shows the commands that get run
# -o pipefail: causes a pipeline to produce a failure return code if any command errors

bazel clean --expunge

rm -rf ./node_modules
rm -rf ./packages/bazel/node_modules
rm -rf ./integration/bazel-schematics/node_modules
rm -rf ./tools/npm/node_modules
rm -rf ./dist

(
  cd integration/bazel
  bazel clean --expunge
  rm -rf ./node_modules
)
