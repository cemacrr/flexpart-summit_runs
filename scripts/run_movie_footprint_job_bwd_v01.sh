#!/bin/bash
#$ -cwd -V
#$ -l h_rt=0:30:00
#$ -pe smp 1
#$ -l h_vmem=8G

# print date:
date

# load modules:
module purge
module load user ffmpeg

# check which modules are loaded:
module list 2>&1

# model run to animate:
TYPE='XTYPEX'
REL='XRELX'
SPEC='XSPECX'
JOB="${TYPE}_REL_${REL}_${SPEC}"

# temp dir for frames:
TMP_DIR="/dev/shm/.__fp_${JOB}"
mkdir -p ${TMP_DIR}

# get all time steps for this run, from all levels:
TIME_STEPS=$(\ls -d ../../${TYPE}*/*_REL_${REL}/plot_footprint_${SPEC}/*.png | \
             awk -F '/' '{print $NF}' | \
             egrep -o '[0-9]{14}-[0-9]{14}' | \
             sort -u)

# for each time step:
for TIME_STEP in ${TIME_STEPS}
do
  # get files for this time step:
  FILE_3=''
  FILE_15=''
  FILE_50=''
  FILE_100=''
  FILE_150=''
  FILE_250=''
  FILE_350=''
  FILE_450=''
  FILE_650=''
  FILE_750=''
  FILE_1000=''
  FILE_1500=''
  FILE_2000=''
  FILE_2500=''
  FILE_3000=''
  FILE_3500=''
  FILE_4000=''
  FILE_4500=''
  FILE_5000=''
  FILE_6000=''
  FILE_7000=''
  FILE_8000=''
  FILE_9000=''
  FILE_10000=''
  NEW_FILE_3=$(\ls -d ../../${TYPE}_1000/*_REL_${REL}/plot_footprint_${SPEC}/3m*${TIME_STEP}*.png 2> /dev/null)
  [ ! -z ${NEW_FILE_3} ] && FILE_3=${NEW_FILE_3}
  NEW_FILE_15=$(\ls -d ../../${TYPE}_1000/*_REL_${REL}/plot_footprint_${SPEC}/15m*${TIME_STEP}*.png 2> /dev/null)
  [ ! -z ${NEW_FILE_15} ] && FILE_15=${NEW_FILE_15}
  NEW_FILE_50=$(\ls -d ../../${TYPE}_1000/*_REL_${REL}/plot_footprint_${SPEC}/50m*${TIME_STEP}*.png 2> /dev/null)
  [ ! -z ${NEW_FILE_50} ] && FILE_50=${NEW_FILE_50}
  NEW_FILE_100=$(\ls -d ../../${TYPE}_1000/*_REL_${REL}/plot_footprint_${SPEC}/100m*${TIME_STEP}*.png 2> /dev/null)
  [ ! -z ${NEW_FILE_100} ] && FILE_100=${NEW_FILE_100}
  NEW_FILE_150=$(\ls -d ../../${TYPE}_1000/*_REL_${REL}/plot_footprint_${SPEC}/150m*${TIME_STEP}*.png 2> /dev/null)
  [ ! -z ${NEW_FILE_150} ] && FILE_150=${NEW_FILE_150}
  NEW_FILE_250=$(\ls -d ../../${TYPE}_1000/*_REL_${REL}/plot_footprint_${SPEC}/250m*${TIME_STEP}*.png 2> /dev/null)
  [ ! -z ${NEW_FILE_250} ] && FILE_250=${NEW_FILE_250}
  NEW_FILE_350=$(\ls -d ../../${TYPE}_1000/*_REL_${REL}/plot_footprint_${SPEC}/350m*${TIME_STEP}*.png 2> /dev/null)
  [ ! -z ${NEW_FILE_350} ] && FILE_350=${NEW_FILE_350}
  NEW_FILE_450=$(\ls -d ../../${TYPE}_1000/*_REL_${REL}/plot_footprint_${SPEC}/450m*${TIME_STEP}*.png 2> /dev/null)
  [ ! -z ${NEW_FILE_450} ] && FILE_450=${NEW_FILE_450}
  NEW_FILE_650=$(\ls -d ../../${TYPE}_1000/*_REL_${REL}/plot_footprint_${SPEC}/650m*${TIME_STEP}*.png 2> /dev/null)
  [ ! -z ${NEW_FILE_650} ] && FILE_650=${NEW_FILE_650}
  NEW_FILE_750=$(\ls -d ../../${TYPE}_1000/*_REL_${REL}/plot_footprint_${SPEC}/750m*${TIME_STEP}*.png 2> /dev/null)
  [ ! -z ${NEW_FILE_750} ] && FILE_750=${NEW_FILE_750}
  NEW_FILE_1000=$(\ls -d ../../${TYPE}_1000/*_REL_${REL}/plot_footprint_${SPEC}/1000m*${TIME_STEP}*.png 2> /dev/null)
  [ ! -z ${NEW_FILE_1000} ] && FILE_1000=${NEW_FILE_1000}
  NEW_FILE_1500=$(\ls -d ../../${TYPE}_10000/*_REL_${REL}/plot_footprint_${SPEC}/1500m*${TIME_STEP}*.png 2> /dev/null)
  [ ! -z ${NEW_FILE_1500} ] && FILE_1500=${NEW_FILE_1500}
  NEW_FILE_2000=$(\ls -d ../../${TYPE}_10000/*_REL_${REL}/plot_footprint_${SPEC}/2000m*${TIME_STEP}*.png 2> /dev/null)
  [ ! -z ${NEW_FILE_2000} ] && FILE_2000=${NEW_FILE_2000}
  NEW_FILE_2500=$(\ls -d ../../${TYPE}_10000/*_REL_${REL}/plot_footprint_${SPEC}/2500m*${TIME_STEP}*.png 2> /dev/null)
  [ ! -z ${NEW_FILE_2500} ] && FILE_2500=${NEW_FILE_2500}
  NEW_FILE_3000=$(\ls -d ../../${TYPE}_10000/*_REL_${REL}/plot_footprint_${SPEC}/3000m*${TIME_STEP}*.png 2> /dev/null)
  [ ! -z ${NEW_FILE_3000} ] && FILE_3000=${NEW_FILE_3000}
  NEW_FILE_3500=$(\ls -d ../../${TYPE}_10000/*_REL_${REL}/plot_footprint_${SPEC}/3500m*${TIME_STEP}*.png 2> /dev/null)
  [ ! -z ${NEW_FILE_3500} ] && FILE_3500=${NEW_FILE_3500}
  NEW_FILE_4000=$(\ls -d ../../${TYPE}_10000/*_REL_${REL}/plot_footprint_${SPEC}/4000m*${TIME_STEP}*.png 2> /dev/null)
  [ ! -z ${NEW_FILE_4000} ] && FILE_4000=${NEW_FILE_4000}
  NEW_FILE_4500=$(\ls -d ../../${TYPE}_10000/*_REL_${REL}/plot_footprint_${SPEC}/4500m*${TIME_STEP}*.png 2> /dev/null)
  [ ! -z ${NEW_FILE_4500} ] && FILE_4500=${NEW_FILE_4500}
  NEW_FILE_5000=$(\ls -d ../../${TYPE}_10000/*_REL_${REL}/plot_footprint_${SPEC}/5000m*${TIME_STEP}*.png 2> /dev/null)
  [ ! -z ${NEW_FILE_5000} ] && FILE_5000=${NEW_FILE_5000}
  NEW_FILE_6000=$(\ls -d ../../${TYPE}_10000/*_REL_${REL}/plot_footprint_${SPEC}/6000m*${TIME_STEP}*.png 2> /dev/null)
  [ ! -z ${NEW_FILE_6000} ] && FILE_6000=${NEW_FILE_6000}
  NEW_FILE_7000=$(\ls -d ../../${TYPE}_10000/*_REL_${REL}/plot_footprint_${SPEC}/7000m*${TIME_STEP}*.png 2> /dev/null)
  [ ! -z ${NEW_FILE_7000} ] && FILE_7000=${NEW_FILE_7000}
  NEW_FILE_8000=$(\ls -d ../../${TYPE}_10000/*_REL_${REL}/plot_footprint_${SPEC}/8000m*${TIME_STEP}*.png 2> /dev/null)
  [ ! -z ${NEW_FILE_8000} ] && FILE_8000=${NEW_FILE_8000}
  NEW_FILE_9000=$(\ls -d ../../${TYPE}_10000/*_REL_${REL}/plot_footprint_${SPEC}/9000m*${TIME_STEP}*.png 2> /dev/null)
  [ ! -z ${NEW_FILE_9000} ] && FILE_9000=${NEW_FILE_9000}
  NEW_FILE_10000=$(\ls -d ../../${TYPE}_10000/*_REL_${REL}/plot_footprint_${SPEC}/10000m*${TIME_STEP}*.png 2> /dev/null)
  [ ! -z ${NEW_FILE_10000} ] && FILE_10000=${NEW_FILE_10000}
  # montage files together:
  MAGICK_THREAD_LIMIT='1' \
    montage \
    -trim \
    ${FILE_3} \
    ${FILE_15} \
    ${FILE_50} \
    ${FILE_100} \
    ${FILE_150} \
    ${FILE_250} \
    ${FILE_350} \
    ${FILE_450} \
    ${FILE_650} \
    ${FILE_750} \
    ${FILE_1000} \
    ${FILE_1500} \
    ${FILE_2000} \
    ${FILE_2500} \
    ${FILE_3000} \
    ${FILE_3500} \
    ${FILE_4000} \
    ${FILE_4500} \
    ${FILE_5000} \
    ${FILE_6000} \
    ${FILE_7000} \
    ${FILE_8000} \
    ${FILE_9000} \
    ${FILE_10000} \
    -border 10 \
    -bordercolor white \
    -geometry 800x200 \
    -tile 4x6 \
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
  -filter:v "setpts=6*PTS" \
  ${JOB}.mp4

# tidy up:
\rm -f ${TMP_DIR}/*
rmdir ${TMP_DIR}

# print the date:
date
