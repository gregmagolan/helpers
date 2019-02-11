set -eux -o pipefail
# -e: exits if a command fails
# -u: errors if an variable is referenced before being set
# -x: shows the commands that get run
# -o pipefail: causes a pipeline to produce a failure return code if any command errors

rm -rf ./node_modules
rm -rf ./packages/bazel/node_modules
rm -rf ./integration/bazel-schematics/node_modules
rm -rf ./tools/npm/node_modules
rm -rf ./dist

bazel clean --expunge

(
  cd integration/bazel
  rm -rf ./node_modules
  bazel clean --expunge
)
