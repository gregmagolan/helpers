#!/usr/bin/env bash

set -eux -o pipefail
# -e: exits if a command fails
# -u: errors if an variable is referenced before being set
# -x: shows the commands that get run
# -o pipefail: causes a pipeline to produce a failure return code if any command errors

# Fix VisualCode annoyance
sed -i.bak 's/"editor.formatOnSave": true/"editor.formatOnSave": false/' ./.vscode/settings.json
rm ./.vscode/settings.json.bak

# Make sure workspace_status_command always runs
echo "build --workspace_status_command=\"node ./tools/bazel_stamp_vars.js\"" >> ./.bazelrc
