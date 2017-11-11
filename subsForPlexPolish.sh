#!/bin/bash

if [ $# -ne 1 ]; then
    echo "./subsForPlexPolish [movieFile]"
    exit 1
fi

qnapiApp=qnapi
mplayerApp=mplayer
movieFile=$1
movieNoExt="${movieFile%.*}"

${qnapiApp} -c -q ${movieFile}
subsFile=$(ls ${movieNoExt}.txt)
if [ ${#subsFile} -eq 0 ]; then
    echo "Subtitles not downloaded"
    exit 1
fi

echo "Subtitles downloaded by qnapi"

enca -x UTF-8 -L polish ${subsFile}
echo "Subtitles converted to UTF-8"

TEST_PL=`grep ą ${subsFile}`

if [ -z "$TEST_PL" ]; then
  echo "ERROR: Subtitles are not in polish language!"
  rm ${subsFile}
  exit 1
fi

${mplayerApp} -sub ${subsFile} -subcp UTF-8 -dumpsrtsub -vo cvidix -really-quiet $movieFile &

sleep 0.2
mplayerPid=$(ps aux | grep mplayer | awk '{print $2}')
if [ ${#mplayerPid} -eq 0 ]; then
    echo "Mplayer not started srt file not created."
    exit 1
fi

kill -9 ${mplayerPid} 2>/dev/null
wait ${mplayerPid} 2>/dev/null

mv ./dumpsub.srt ${movieNoExt}.polish.srt
echo "Subtitles converted to SRT"

rm ${subsFile}

