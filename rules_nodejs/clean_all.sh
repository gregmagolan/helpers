set -eux -o pipefail
# -e: exits if a command fails
# -u: errors if an variable is referenced before being set
# -x: shows the commands that get run
# -o pipefail: causes a pipeline to produce a failure return code if any command errors

rm -rf ./node_modules
rm -rf ./internal/test/node_modules
rm -rf ./internal/npm_install/test/node_modules

bazel clean --expunge

(
  cd examples/program
  bazel clean --expunge
  rm -rf ./node_modules
)

(
  cd internal/e2e
  for testDir in $(ls) ; do
    [[ -d "$testDir" ]] || continue
    (
      cd $testDir
      if [[ -f "WORKSPACE" ]] ; then
        rm -rf ./node_modules
        bazel clean --expunge
      fi
    )
  done
)
