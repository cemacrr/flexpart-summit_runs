#!/bin/bash

# label for this set of jobs:
JOBS_NAME='split_IR_1'
# number of particles to release:
REL_PARTS='10000'
# split interval:
ITSPLIT='864000'
# ind_receptor mass units:
IND_RECEPTOR='1'

# template directory:
TEMPL_DIR=$(dirname $(readlink -f ${0}))/../templates/bwd_v01
# directory in to which directories will be copied / models will be run:
OUT_DIR=$(dirname $(readlink -f ${0}))/${JOBS_NAME}
# job running script:
RUN_SCRIPT=$(dirname $(readlink -f ${0}))/../scripts/run_job.sh

# start time (2019-09-25 12:00):
START_TIME=1569409200
# end time (2019-09-18 12:00):
END_TIME=1568804400
# interval between runs (3 hours):
RUN_INT=10800
# run length (32 days):
RUN_LEN=2764800

# data type, ei or ea:
DATA_TYPE='ea'

# make sure OUT_DIR exists:
mkdir -p ${OUT_DIR}

while [ ${START_TIME} -ge ${END_TIME} ]
do
  # start date:
  SD=$(date -d @${START_TIME} +%Y%m%d)
  # start hour:
  SH=$(date -d @${START_TIME} +%H%M%S)
  # run end time:
  ET=$((${START_TIME} - ${RUN_LEN}))
  # end date:
  ED=$(date -d @${ET} +%Y%m%d)
  # end hour:
  EH=$(date -d @${ET} +%H%M%S)
  # for each output height:
  for REL_HEIGHT in 3 100 500 3000
  do
    # run dir:
    RD="${OUT_DIR}/${SD}${SH}-${ED}${EH}_REL_${REL_HEIGHT}_${JOBS_NAME}"
    # create directory for this run:
    rm -fr ${RD}
    \cp -r ${TEMPL_DIR} ${RD}
    # update pathnames:
    sed -i "s|XXX|${RD}|g" ${RD}/pathnames
    sed -i "s|XX|${DATA_TYPE}|g" ${RD}/pathnames
    # update outgrid file:
    sed -i "s|XXX|3, 15, 50, 100, 150, 250, 350, 450, 650, 750, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000, 6000, 7000, 8000, 9000, 10000|g" ${RD}/options/OUTGRID
    # update release file:
    sed -i "s|XXXXXXXX|${SD}|g" ${RD}/options/RELEASES
    sed -i "s|XXXXXX|${SH}|g" ${RD}/options/RELEASES
    sed -i "s|XXXXX|${REL_PARTS}|g" ${RD}/options/RELEASES
    sed -i "s|XXX|${REL_HEIGHT}|g" ${RD}/options/RELEASES
    # update command file:
    sed -i "s|XXXEDXXX|${SD}|g" ${RD}/options/COMMAND
    sed -i "s|XXETXX|${SH}|g" ${RD}/options/COMMAND
    sed -i "s|XXXSDXXX|${ED}|g" ${RD}/options/COMMAND
    sed -i "s|XXSTXX|${EH}|g" ${RD}/options/COMMAND
    sed -i "s|XXXISXXX|${ITSPLIT}|g" ${RD}/options/COMMAND
    sed -i "s|XXXIRXXX|${IND_RECEPTOR}|g" ${RD}/options/COMMAND
    # run job script:
    \cp ${RUN_SCRIPT} ${RD}/run_job.sh
    # increase run time:
    sed -i "s|0:20:00|1:30:00|g" ${RD}/run_job.sh
    chmod 755 ${RD}/run_job.sh
  done
  # increment run start time:
  START_TIME=$((${START_TIME} - ${RUN_INT}))
done
