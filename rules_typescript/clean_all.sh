set -eux -o pipefail
# -e: exits if a command fails
# -u: errors if an variable is referenced before being set
# -x: shows the commands that get run
# -o pipefail: causes a pipeline to produce a failure return code if any command errors

rm -rf ./node_modules
bazel clean --expunge

(
  cd internal/karma
  rm -rf ./node_modules
  bazel clean --expunge
)

(
  cd internal/e2e/npm_packages
  for testDir in $(ls) ; do
    [[ -d "$testDir" ]] || continue
    (
      cd $testDir
      rm -rf ./node_modules
      bazel clean --expunge
    )
  done
)

(
  cd internal/e2e/typescript_3.1
  rm -rf ./node_modules
  bazel clean --expunge
)
