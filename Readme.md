# Android folder sync

## Requirements
Install Google adb-sync from Github: [github.com/google/adb-sync](https://github.com/google/adb-sync) (Installation guide is provided in the Readme file).

## Usage
`./sync FOLDERNAME SYNC_FOLDERS_FILE.txt`

## Sync Folders file
A txt file containing one folder path on the device per line, e.g. `/sdcard/DCIM/Camera`.
The folder will be synced to *FOLDERNAME/Camera* in this example.
For folder paths containing a Space, e.g. `/sdcard/Documents/My Office`, the spaces need to be replaced by `\/`. The resulting line for the file would be `/sdcard/Documents/My\/Office`
You can use the # character to comment out a line, but make sure to omit spaces at anytime.