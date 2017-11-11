#!/bin/sh
ffprobe -select_streams v -show_streams $1 2>/dev/null | grep nb_frames | sed -e 's/nb_frames=//'
