#!/bin/bash

# job running script:
RUN_SCRIPT=$(dirname $(readlink -f ${0}))/../scripts/run_movie_footprint_job_bwd_v01.sh

# job types:
TYPES='nosplit split'
# release heights:
RELS='3 100 500 3000'
# species:
SPECS='AIRTRACER AERO-TRACE MIN_DUST'

# for each type:
for TYPE in ${TYPES}
do
  # for each release height:
  for REL in ${RELS}
  do
    # make directory:
    MOV_DIR=movies_${TYPE}/REL_${REL}
    mkdir -p ${MOV_DIR}
    pushd ${MOV_DIR}
    # for each species:
    for SPEC in ${SPECS}
    do
      # copy job script:
      JOB_SCRIPT=$(basename ${RUN_SCRIPT/bwd_v01/${SPEC}})  
      \cp ${RUN_SCRIPT} ${JOB_SCRIPT}
      # update script:
      sed -i "s|XTYPEX|${TYPE}|g" ${JOB_SCRIPT}
      sed -i "s|XRELX|${REL}|g" ${JOB_SCRIPT}
      sed -i "s|XSPECX|${SPEC}|g" ${JOB_SCRIPT}
    done
    popd
  done
done
