#!/bin/bash

TYPES='nosplit split'
RELS='3 100 500 3000'
SPECS='AIRTRACER AERO-TRACE MIN_DUST'

for TYPE in ${TYPES}
do
  for REL in ${RELS}
  do
    MOV_DIR=movies_${TYPE}/REL_${REL}
    pushd ${MOV_DIR}
    for SPEC in ${SPECS}
    do
      qsub run_movie_footprint_job_${SPEC}.sh
    done
    popd
  done
done
