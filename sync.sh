#!/bin/sh

destFolder=$1
syncFoldersFile=$2
if [[ -z "$destFolder" || -z "$syncFoldersFile" ]]
then
    echo "You have to provide a target folder name and a sync folders file. Usage: ./sync.sh FOLDERNAME SYNCFOLDERSFILE.txt"
    exit 1
fi

destPath=$(pwd)/$destFolder
if [ ! -d "$destPath" ] 
then
    read -r -p "Error: Directory $destPath does not exist. Do you want to create it? [y/N] " response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
    then
        mkdir -p $destPath
        echo "created folder $destFolder in $(pwd)"
    else
        echo "Sync canceled."
        exit 1
    fi
else
    echo "Directory $destPath exists."
fi

if [ ! -f "$syncFoldersFile" ]
then
    echo "The sync folders file $(pwd)/$syncFoldersFile does not exist. Usage: ./sync.sh FOLDERNAME SYNCFOLDERSFILE.txt"
    exit 1
fi

syncFoldersArray=($(cat $syncFoldersFile | tr "\n" " "))

copy() {
    copySourceFolder="${1/\\\// }"
    copyDestFolder="$2"

    # https://stackoverflow.com/a/13210909 (Replace pattern)

    printf "Copying from %s to %s\n" "$copySourceFolder" "$copyDestFolder"
    adb-sync --reverse --times "$copySourceFolder" "$copyDestFolder"
    printf "finished copying %s\n" "$copySourceFolder"
}

for (( i=0; i<${#syncFoldersArray[@]}; ++i )); do
    syncFoldersArrayLine=${syncFoldersArray[i]}
    if [[ $syncFoldersArrayLine == \#* ]]
    then
        echo "ignore line: $syncFoldersArrayLine"
    else
        syncSourceFolder="$syncFoldersArrayLine"

        echo "$syncFoldersArrayLine"
        printf "Job %d of %d | copy from %s to %s\n" "$((i+1))" "${#rfolders[@]}" "$syncSourceFolder" "$destPath"
        copy "$syncSourceFolder" "$destPath"
    fi
done

# delete all .dotfolders
find . -not -path "." -type d -name ".*"  -exec rm -r "{}" \;

exit 0
