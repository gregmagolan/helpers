set -eux -o pipefail
# -e: exits if a command fails
# -u: errors if an variable is referenced before being set
# -x: shows the commands that get run
# -o pipefail: causes a pipeline to produce a failure return code if any command errors

ROOT_DIR=$(pwd)
SCRIPT_DIR=$(cd $(dirname "$0"); pwd)

$SCRIPT_DIR/clean_all.sh

bazel run @nodejs//:yarn
bazel build ...
bazel test ...

# These targets should run
bazel run //internal/node/test:no_deps
bazel run //internal/node/test:has_deps_legacy
bazel run //internal/node/test:has_deps
bazel run //internal/node/test:has_deps_hybrid
bazel run //internal/e2e/fine_grained_no_bin:index
bazel run @fine_grained_deps_yarn//typescript/bin:tsc

# bazel test @program_example//... # DO NOT WORK WITH --nolegacy_external_runfiles
# bazel test @packages_example//... # DO NOT WORK WITH --nolegacy_external_runfiles

yarn test:e2e

yarn test:examples
