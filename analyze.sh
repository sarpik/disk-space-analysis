#!/bin/sh
# analyze.sh

# Options & variables

usage() {
	printf "\nSelect running mode:
	-q: quiet mode 
	-v: verbose mode
	
	Optional arguments for custom use:

	-s: path to start inspecting from (ie /c or ~/)
	-f: path to folder where analyzed data will be stored (3 files)
	-h: Show this message\n";
	exit;
}

# note - the first ':' turns on production mode; the ':' after a letter indicates that an option must provide an argument.
while getopts ":hqvs:f:" o; do case "${o}" in
	h) usage ;;
	q) mode="quiet" ;;
	v) mode="verbose" ;;
	s) startInspectionFromPath=${OPTARG} && [ -d "$startInspectionFromPath" ] || exit ;;
	f) folderToStoreFilesPath=${OPTARG} ;;
	*) printf "Invalid option: -%s\\n" "$OPTARG" && exit ;;
esac done

# Defaults

[ -z "$startInspectionFromPath" ] && startInspectionFromPath="/c"
[ -z "$folderToStoreFilesPath" ] && folderToStoreFilesPath="$HOME/Desktop/disk-analysis"
#[ -z "$mode" ] && mode="false"
[ -z "$mode" ] && usage

# create folder if doesn't exist already

[ ! -d ${folderToStoreFilesPath} ] && mkdir -pv ${folderToStoreFilesPath}

# cd to the folder
cd ${folderToStoreFilesPath}

if [ "$mode" = "quiet" ]; then
	du -h ${startInspectionFromPath} | tee "${folderToStoreFilesPath}/1-file-sizes.txt" | sort -hr | tee "${folderToStoreFilesPath}/2-sorted-file-sizes.txt" | head > "${folderToStoreFilesPath}/3-sorted-and-grouped-file-sizes.txt"

elif [ "$mode" = "verbose" ]; then
	du -h ${startInspectionFromPath} | tee "${folderToStoreFilesPath}/1-file-sizes.txt" 
	cat disk-sizes.txt | sort -hr | tee "${folderToStoreFilesPath}/2-sorted-file-sizes.txt"
	cat sorted-disk-sizes.txt | head | tee "${folderToStoreFilesPath}/3-sorted-and-grouped-file-sizes.txt"
else
	printf "\nError! No mode / bad mode selected\n" && exit 1;
fi

printf "\nanalyze.sh finished. Exiting.\n" && exit 0;

