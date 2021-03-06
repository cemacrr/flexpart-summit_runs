#!/bin/bash

# jobs name / label:
JOBS_NAME='20190226-20190214'

# particle release heights:
REL_HEIGHTS='3 100 500 3000'

# template directory:
TEMPL_DIR=$(dirname $(readlink -f ${0}))/../templates/bwd_v02
# job running script:
RUN_SCRIPT=$(dirname $(readlink -f ${0}))/../scripts/run_job.sh

# start time (2019-02-27 00:00):
START_TIME=1551225600
# end time (2019-02-14 00:00):
END_TIME=1550102400
# interval between runs (3 hours):
RUN_INT=10800
# run length (32 days):
RUN_LEN=2764800

# data type, ei or ea:
DATA_TYPE='ea'

# make directory for jobs:
OUT_DIR=$(dirname $(readlink -f ${0}))/${JOBS_NAME}
mkdir ${OUT_DIR}

# start time and end time:
START=${START_TIME}
END=${END_TIME}
# loop through start times:
while [ ${START} -ge ${END} ]
do
  # start date:
  SD=$(date -d @${START} +%Y%m%d)
  # start hour:
  SH=$(date -d @${START} +%H%M%S)
  # run end time:
  ET=$((${START} - ${RUN_LEN}))
  # end date:
  ED=$(date -d @${ET} +%Y%m%d)
  # end hour:
  EH=$(date -d @${ET} +%H%M%S)
  # for each release height:
  for REL_HEIGHT in ${REL_HEIGHTS}
  do
    # run dir:
    RD="${OUT_DIR}/${SD}${SH}-${ED}${EH}_REL_${REL_HEIGHT}"
    # create directory for this run:
    rm -fr ${RD}
    \cp -r ${TEMPL_DIR} ${RD}
    # update pathnames:
    sed -i "s|XXX|${RD}|g" ${RD}/pathnames
    # update release file:
    sed -i "s|XXXXXXXX|${SD}|g" ${RD}/options/RELEASES
    sed -i "s|XXXXXX|${SH}|g" ${RD}/options/RELEASES
    sed -i "s|XXXX|${REL_HEIGHT}|g" ${RD}/options/RELEASES
    # update command file:
    sed -i "s|XXXEDXXX|${SD}|g" ${RD}/options/COMMAND
    sed -i "s|XXETXX|${SH}|g" ${RD}/options/COMMAND
    sed -i "s|XXXSDXXX|${ED}|g" ${RD}/options/COMMAND
    sed -i "s|XXSTXX|${EH}|g" ${RD}/options/COMMAND
    # run job script:
    \cp ${RUN_SCRIPT} ${RD}/run_job.sh
    # increase run time:
    sed -i 's|0:20:00|4:00:00|g' ${RD}/run_job.sh
    # adjust memory request:
    sed -i 's|-l h_vmem=16G|-l h_vmem=8G|g' ${RD}/run_job.sh
    # make executable:
    chmod 755 ${RD}/run_job.sh
  done
  # increment run start time:
  START=$((${START} - ${RUN_INT}))
done
