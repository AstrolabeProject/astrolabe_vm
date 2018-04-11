#!/bin/bash

# Astrolabe Setup Script
#   Change ownership of Astrolabe code and data directories.
#   "After an instance using the image is launched and active, the script will be executed."
#
#   Written by: Tom Hicks. 3/12/2018.
#   Last Modified: Auto-create the users iRods environment file on startup.
#

# Directories to modify. Names must not contain a space.
SET_DIRS='/opt/astrolabe /data'
USER_HOME=/home/${ATMO_USER}

main ()
{
  # This is the main function -- These lines will be executed each run
  inject_atmo_vars
  init_icmds
  mk_user_dirs
  set_directory
}

inject_atmo_vars ()
{
  # Source the .bashrc -- this contains $ATMO_USER
  PS1='HACK to avoid early-exit in .bashrc'
  . ~/.bashrc
  if [ -z "$ATMO_USER" ]; then
      echo 'Variable $ATMO_USER is not set in .bashrc! Abort!'
      exit 1 # 1 - ATMO_USER is not set!
  fi
  echo "Found user: $ATMO_USER"
}

init_icmds ()
{
  mkdir -p ${USER_HOME}/.irods
  chown -R $ATMO_USER:iplant-everyone ${USER_HOME}/.irods
  cat > ${USER_HOME}/.irods/irods_environment.json  <<ICMDS_JSON
{
    "irods_host": "data.cyverse.org",
    "irods_port": 1247,
    "irods_user_name": "$ATMO_USER",
    "irods_zone_name": "iplant",
    "irods_default_resource" : "CyVerseRes"
}
ICMDS_JSON
}

mk_user_dirs ()
{
  mkdir -p ${USER_HOME}/bin ${USER_HOME}/temp ${USER_HOME}/data_store
  chown -R $ATMO_USER:iplant-everyone ${USER_HOME}/bin ${USER_HOME}/temp ${USER_HOME}/data_store
}

set_directory ()
{
  chown -R $ATMO_USER:iplant-everyone $SET_DIRS
  exit 0
}

# Start the execution of this script:
main
