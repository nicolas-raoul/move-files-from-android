#!/bin/bash

source settings.conf

# Mount the Android filesystem via ADB
# TODO get exit status and abort if not successful
# TODO get PID to kill it later
$ADBFS $ADBFS_ROOT_DIRECTORY

# Loop over configured directories
while read SOURCE_DIRECTORY; do

  # Ignore comments and white lines in directories.conf
  [[ "$SOURCE_DIRECTORY" =~ ^#.*$ ]] && continue
  [[ "$SOURCE_DIRECTORY" =~ ^[:space:]*$ ]] && continue

  # Warn and skip non-existent directories
  if [ ! -d "$ADBFS_ROOT_DIRECTORY/$SOURCE_DIRECTORY" ]; then
    echo "Directory $SOURCE_DIRECTORY does not exist on the Android device."
    continue
  fi

  # Loop over files contained in this directory
  for FILE in $(ls -1 "$ADBFS_ROOT_DIRECTORY/$SOURCE_DIRECTORY"); do
    mv --backup=t --verbose "$ADBFS_ROOT_DIRECTORY/$SOURCE_DIRECTORY/$FILE" "$DESTINATION_DIRECTORY"
  done

done < directories.conf

# TODO kill adbfs process by PID
#killall $(basename $ADBFS)
