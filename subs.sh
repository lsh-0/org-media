#!/bin/bash
# converts interlaced content to deinterfaced x264 and disables any subtitles turned on by default.
set -eux

input_dir=$1
input_dir=$(realpath "$input_dir")

output_dir=$2
output_dir=$(realpath "$output_dir")

# -c:[stream-specifier]
# -vf yadif - deinterlace using yadif (yet-another-deinterlace-function)
# -c:v libx264 -preset slow -crf 8 -tune animation - use x264 slowly, use level 8 compression and tune for animation
# -c:a copy - copy the audio across without encoding
# -c:s copy - copy the subs across without encoding
# -map 0 - short for -map 0:*, which is saying 'include all streams'
# -disposition:s:0 0 - set the 'default' status disposition of the first sub track to 0 (off, makemkv turned them all on).

for f in $(find "$input_dir" -type f -name "*.mkv"); do
    echo "$f"
    filename=$(basename -- "$f")
    extension="${filename##*.}"
    filename="${filename%.*}"

    ffmpeg -i "$f" \
        -vf yadif \
        -c:v libx264 -preset slow -crf 8 -tune animation \
        -c:a copy \
        -c:s copy \
        -map 0 \
        -disposition:s:0 0 \
        "$output_dir/$filename.$extension"
done

