#!/bin/bash
# Source the environment configuration
source ../.erc

# Run the merge command
jq -s '.[0] * .[1]' setup.json $VSCODE__USR_SETTINGS_DEFAULT_PATH__POSIX > .tmp-merged-v.json && mv .tmp-merged-v.json $VSCODE__USR_SETTINGS_DEFAULT_PATH__POSIX