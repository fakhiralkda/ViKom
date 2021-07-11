#!/bin/bash

echo "::group::Install Dependencies"
apt update -qq -y && DEBIAN_FRONTEND=noninteractive apt install -qq -y --no-install-recommends aria2 ffmpeg wget curl
echo "::endgroup::"

echo "::group::Download"
tracker_list=$(curl -Ns https://raw.githubusercontent.com/XIU2/TrackersListCollection/master/all.txt https://ngosang.github.io/trackerslist/trackers_all_http.txt https://newtrackon.com/api/all https://raw.githubusercontent.com/DeSireFire/animeTrackerList/master/AT_all.txt https://raw.githubusercontent.com/hezhijie0327/Trackerslist/main/trackerslist_tracker.txt https://raw.githubusercontent.com/hezhijie0327/Trackerslist/main/trackerslist_exclude.txt | awk '$0' | tr '\n\n' ',')
aria2c --bt-tracker="[$tracker_list]" --bt-max-peers=0 --bt-tracker-connect-timeout=300 \
    --bt-stop-timeout=1200 --min-split-size=10M --bt-enable-lpd=true --check-certificate=false \
    --peer-id-prefix=-qB4350- --user-agent=qBittorrent/4.3.5 --peer-agent=qBittorrent/4.3.5 \
    --max-overall-upload-limit=0 --max-concurrent-downloads=7 --max-overall-download-limit=0 \
    --seed-time=2 --seed-ratio=1.0 --follow-torrent=true --split=10 \
    $1

if [[ -n "$(find . -type f -iname '*.mp4')" ]]; then
    FILEPATH=$(find . -type f -iname "*.mp4")
    FILENAME=$(basename -- "${FILEPATH}")
    NAME="${FILENAM1%.*}"
    COMPRESSED="${NAME}-Comp.mp4"
elif [[ -n "$(find . -type f -iname '*.mkv')" ]]; then
    FILEPATH=$(find . -type f -iname "*.mkv")
    FILENAME=$(basename -- "${FILEPATH}")
    NAME="${FILENAME%.*}"
    COMPRESSED="${NAME}-Comp.mkv"
else
    ls *
    exit 1
fi
echo "::endgroup::"

echo "::group::Kompres"
ffmpeg -i ${FILEPATH} -loglevel warning -c:v libx264 -preset medium -tune film -crf 26 -vf scale=-2:480 -c:a copy ${COMPRESSED}
echo "::endgroup::"

du -sh ${COMPRESSED}
curl -k --upload-file ${COMPRESSED} https://transfer.sh/${COMPRESSED}
