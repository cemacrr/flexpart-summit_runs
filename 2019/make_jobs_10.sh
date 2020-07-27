#!/bin/bash

# month for jobs, 01 -> 12:
MONTH='10'

# jobs name / label:
JOBS_NAME=${MONTH}

# particle release heights:
REL_HEIGHTS='3 100 500 3000'

# template directory:
TEMPL_DIR=$(dirname $(readlink -f ${0}))/../templates/bwd_v02
# job running script:
RUN_SCRIPT=$(dirname $(readlink -f ${0}))/../scripts/run_job.sh

# start time (2019-10-31 21:00 UTC):
START_TIME=$(date -u -d '2019-10-31 21:00' +%s)
# end time (2019-10-01 00:00 UTC):
END_TIME=$(date -u -d '2019-10-01 00:00' +%s)
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
  SD=$(date -u -d @${START} +%Y%m%d)
  # start hour:
  SH=$(date -u -d @${START} +%H%M%S)
  # run end time:
  ET=$((${START} - ${RUN_LEN}))
  # end date:
  ED=$(date -u -d @${ET} +%Y%m%d)
  # end hour:
  EH=$(date -u -d @${ET} +%H%M%S)
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
  done
  # increment run start time:
  START=$((${START} - ${RUN_INT}))
done
