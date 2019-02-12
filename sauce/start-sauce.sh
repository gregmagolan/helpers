#!/usr/bin/env bash

set -eux -o pipefail
# -e: exits if a command fails
# -u: errors if an variable is referenced before being set
# -x: shows the commands that get run
# -o pipefail: causes a pipeline to produce a failure return code if any command errors

# Command arguments that will be passed to sauce-connect.
sauceArgs=""

if [[ ! -z "${SAUCE_READY_FILE:-}" ]]; then
  sauceArgs="${sauceArgs} --readyfile ${SAUCE_READY_FILE}"
fi

if [[ ! -z "${SAUCE_PID_FILE:-}" ]]; then
  mkdir -p $(dirname ${SAUCE_PID_FILE})
  sauceArgs="${sauceArgs} --pidfile ${SAUCE_PID_FILE}"
fi

if [[ ! -z "${SAUCE_TUNNEL_IDENTIFIER:-}" ]]; then
  sauceArgs="${sauceArgs} --tunnel-identifier ${SAUCE_TUNNEL_IDENTIFIER}"
fi

echo "Starting Sauce Connect. Passed arguments: ${sauceArgs}"

sc -u ${SAUCE_USERNAME} -k ${SAUCE_ACCESS_KEY} ${sauceArgs}
