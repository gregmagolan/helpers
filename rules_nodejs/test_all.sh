#!/usr/bin/env bash

set -eux -o pipefail
# -e: exits if a command fails
# -u: errors if an variable is referenced before being set
# -x: shows the commands that get run
# -o pipefail: causes a pipeline to produce a failure return code if any command errors

# Check environment
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    MSYS_NT*)   machine=Windows;;
    *)          machine="UNKNOWN:${unameOut}"
esac
echo "Running on $machine"

SCRIPT_DIR=$(cd $(dirname "$0"); pwd)

$SCRIPT_DIR/clean_all.sh

printf "\n\nRunning @nodejs//:yarn\n"
bazel run @nodejs//:yarn

printf "\n\nBuilding all targets\n"
bazel build ...

printf "\n\nTesting all targets\n"
if [[ $machine == "Windows" ]] ; then
    bazel test ... --test_tag_filters=-fix-windows
else
    bazel test ...
fi

printf "\n\nTesting /packages/typescript\n"
yarn packages-typescript

printf "\n\nTesting /packages/karma\n"
yarn packages-karma

printf "\n\nTesting /packages/jasmine\n"
yarn packages-jasmine

# These targets should run
printf "\n\nTesting set of runnable targets\n"
bazel run //internal/node/test:no_deps
bazel run //internal/node/test:has_deps_legacy
bazel run //internal/node/test:has_deps
bazel run //internal/node/test:has_deps_hybrid
bazel run //internal/e2e/fine_grained_no_bin:index
bazel run @fine_grained_deps_yarn//typescript/bin:tsc

# bazel test @program_example//... # DO NOT WORK WITH --nolegacy_external_runfiles
# bazel test @packages_example//... # DO NOT WORK WITH --nolegacy_external_runfiles

./e2e/test.sh

printf "\n\nTesting /internal/e2e\n"
yarn test:e2e

printf "\n\nTesting /examples\n"
yarn test:examples
