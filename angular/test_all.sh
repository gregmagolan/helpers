#!/usr/bin/env bash

set -eux -o pipefail
# -e: exits if a command fails
# -u: errors if an variable is referenced before being set
# -x: shows the commands that get run
# -o pipefail: causes a pipeline to produce a failure return code if any command errors

SCRIPT_DIR=$(cd $(dirname "$0"); pwd)

$SCRIPT_DIR/local_mods.sh
$SCRIPT_DIR/clean_all.sh
yarn install

### test_ivy_aot
yarn test-ivy-aot //... --symlink_prefix=dist/

### test
yarn bazel test //... --build_tag_filters=-ivy-only --test_tag_filters=-ivy-only,-local
yarn bazel test //... --build_tag_filters=-ivy-only,local --test_tag_filters=-ivy-only,local

./scripts/build-packages-dist.sh

(
  cd integration/bazel
  yarn install
  yarn test
)

(
  cd integration/bazel-schematics
  yarn install
  ./test.sh
)
