#!/bin/bash

# Write the config file from environment variables. Thias, for the issue with the program
# when fails when prompting for the user and password under Alpine.
if [ ! -f /config/megafuse.conf ]; then
  if [ "$1" == "-i" ]; then
    [ -z "$USERNAME" ] && read -rp "Username: " USERNAME || exit 1
    [ -z "$PASSWORD" ] && read -rp "Password: " PASSWORD || exit 1
    [ -z "$APPKEY" ] && read   -rp "App  key: " APPKEY || exit 1

    cat << EOF > megafuse.conf
###################
# Config file, please remove the # in front of the variable when you edit it: "#USERNAME" --> "USERNAME"
###################


USERNAME = $USERNAME
PASSWORD = $PASSWORD

##### create your appkey at https://mega.co.nz/#sdk

APPKEY = $APPKEY

#### you can specify a mountpoint here, only absolute paths are supported.

MOUNTPOINT = /mega

#### path for the cached files; /tmp is the default, change it if your /tmp is small

CACHEPATH = /tmp

EOF

    mkdir /mega
    chown -R abc:abc \
      /config \
      /mega
    
    s6-setuidgid abc megafuse -c /config/megafuse.conf

  else
    echo "Fatal: No config file found. Please run '/start.sh -i' or provide the required parameters"
    echo "from the envirnment variables in order to get a working config file."
    # Leave commented in order to keep the container running and allow to run '/start.sh -i'
    #exit 1
  fi
fi
