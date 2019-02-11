set -eux -o pipefail
# -e: exits if a command fails
# -u: errors if an variable is referenced before being set
# -x: shows the commands that get run
# -o pipefail: causes a pipeline to produce a failure return code if any command errors

ROOT_DIR=$(pwd)
SCRIPT_DIR=$(cd $(dirname "$0"); pwd)

$SCRIPT_DIR/clean_all.sh

yarn
yarn bazel build ...
yarn bazel test ...

(
  cd internal/karma
  yarn bazel build ...
  yarn bazel test ...
)

yarn e2e