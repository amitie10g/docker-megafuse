#!/bin/bash

# Local Environment variables
PUID=$(curl -fSs "http://metadata.google.internal/computeMetadata/v1/oslogin/users?pagesize=1" -H "Metadata-Flavor: Google" | python -c "import sys, json; print(json.load(sys.stdin)['loginProfiles'][0]['posixAccounts'][0]['uid'])")
PGID=$(curl -fSs "http://metadata.google.internal/computeMetadata/v1/oslogin/users?pagesize=1" -H "Metadata-Flavor: Google" | python -c "import sys, json; print(json.load(sys.stdin)['loginProfiles'][0]['posixAccounts'][0]['gid'])")
LOCAL_HOME=$(curl -fSs "http://metadata.google.internal/computeMetadata/v1/oslogin/users?pagesize=1" -H "Metadata-Flavor: Google" | python -c "import sys, json; print(json.load(sys.stdin)['loginProfiles'][0]['posixAccounts'][0]['homeDirectory'])")

CONF_PATH="$LOCAL_HOME/config"
CACHE_PATH="$LOCAL_HOME/cache"

# Create the directories
mkdir -p "CONF_PATH" "$CACHE_PATH"
chown -R "$PUID:$PGID" "$LOCAL_HOME"
