#!/bin/bash
#$ -cwd -V
#$ -l h_rt=1:00:00
#$ -pe smp 1
#$ -l h_vmem=8G

# print date:
date

# load modules:
module purge
module load user ffmpeg

# check which modules are loaded:
module list

# model run to animate:
MODEL_RUN='XXXXX'

# temp dir for frames:
TMP_DIR="/dev/shm/.__tmp_${MODEL_RUN}_$(date +%s)"
mkdir -p ${TMP_DIR}

# get all time steps for this run, from all levels:
TIME_STEPS=$(\ls -d ../../300_3000/*${MODEL_RUN}*/plot_footprint/*.png | \
             awk -F '/' '{print $NF}' | \
             egrep -o '[0-9]{14}-[0-9]{14}' | \
             sort -u)

# for each time step:
for TIME_STEP in ${TIME_STEPS}
do
  # get files for this time step:
  FILE_300=''
  FILE_3000=''
  NEW_FILE_300=$(\ls -d ../../300_3000/${TIME_STEP}*${MODEL_RUN}_*/plot_footprint/300m*${TIME_STEP}*.png 2> /dev/null)
  [ ! -z "${NEW_FILE_300}" ] && FILE_300=${NEW_FILE_300}
  NEW_FILE_3000=$(\ls -d ../../300_3000/${TIME_STEP}*${MODEL_RUN}_*/plot_footprint/3000m*${TIME_STEP}*.png 2> /dev/null)
  [ ! -z "${NEW_FILE_3000}" ] && FILE_3000=${NEW_FILE_3000}
  # montage files together:
  MAGICK_THREAD_LIMIT='1' \
    montage \
    -trim \
    ${FILE_300} \
    ${FILE_3000} \
    -border 10 \
    -bordercolor white \
    -geometry 3200x800 \
    -tile 1x2 \
    ${TMP_DIR}/${TIME_STEP}.png
done

# rename in reverse order:
count=0
for img in $(\ls -1 ${TMP_DIR}/*.png | sort -r)
do
  img_file=$(basename ${img})
  mv ${TMP_DIR}/${img_file} \
    ${TMP_DIR}/$(printf '%04d' ${count}).png
  count=$((${count} + 1))
done

# ffmpeg images together:
ffmpeg \
  -v 0 \
  -y \
  -threads 1 \
  -i ${TMP_DIR}/%04d.png \
  -movflags faststart \
  -pix_fmt yuv420p \
  -vf "scale=trunc(iw/2)*2:600" \
  -vcodec libx264 \
  -profile:v baseline \
  -an \
  -filter:v "setpts=2.5*PTS" \
  ${MODEL_RUN}.mp4

# tidy up:
rm -fr ${TMP_DIR}

# print the date:
date
