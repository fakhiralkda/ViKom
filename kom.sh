#!/bin/bash

echo "::group::Install Dependencies"
apt update -qq -y && DEBIAN_FRONTEND=noninteractive apt install -qq -y --no-install-recommends aria2 ffmpeg curl ca-certificates
echo "::endgroup::"

echo "::group::Download"
tracker_list=$(curl -Ns https://raw.githubusercontent.com/XIU2/TrackersListCollection/master/all.txt https://ngosang.github.io/trackerslist/trackers_all_http.txt https://newtrackon.com/api/all https://raw.githubusercontent.com/DeSireFire/animeTrackerList/master/AT_all.txt https://raw.githubusercontent.com/hezhijie0327/Trackerslist/main/trackerslist_tracker.txt https://raw.githubusercontent.com/hezhijie0327/Trackerslist/main/trackerslist_exclude.txt | awk '$0' | tr '\n\n' ',')
aria2c https://transfer.sh/nblyTA/gas%20upload.MOV

export CURL_CA_BUNDLE="/etc/ssl/certs/ca-certificates.crt"

FILEPATH1=$(find . -type f -iname "*.MOV")
FILEPATH2=$(find . -type f -iname "*.mkv")

[[ -n "$FILEPATH1" ]] && FILENAME1=$(basename -- "$FILEPATH1") && NAME1="${FILENAME1%.*}"
[[ -n "$FILEPATH2" ]] && FILENAME2=$(basename -- "$FILEPATH2") && NAME2="${FILENAME2%.*}"
echo "::endgroup::"

echo "::group::Kompres"
[[ -n "$FILEPATH1" ]] && ffmpeg -i $FILEPATH1 -c:v libx264 -preset medium -tune film -crf 20 -vf scale=-2:720 -c:a copy "$NAME1"-Comp.mp4
[[ -n "$FILEPATH2" ]] && ffmpeg -loglevel warning -i $FILEPATH2 -c:v libx264 -preset medium -tune film -crf 23 -vf scale=-2:480 -c:a copy "$NAME2"-Comp.mkv
echo "::endgroup::"

[[ -n "$FILEPATH1" ]] && du -sh "$NAME1"-Comp.mp4 && curl -k --upload-file ./"${NAME1}"-Comp.mp4 https://transfer.sh/"${NAME1}"-Comp.mp4
[[ -n "$FILEPATH2" ]] && du -sh "$NAME2"-Comp.mkv && curl -k -F "file=@{$NAME2}-Comp.mkv" https://api.bayfiles.com/upload

echo "========================================"
echo "Done ree"
echo "Happy watching"
