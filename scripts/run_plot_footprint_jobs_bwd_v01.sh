#!/bin/bash

ALL_DIRS=$(\ls -1d *split*/*)
SPECIES='AIRTRACER AERO-TRACE MIN_DUST'

for DIR in ${ALL_DIRS}
do
  pushd ${DIR}
  for SPEC in ${SPECIES}
  do
    if [ ! -e plot_footprint_${SPEC}/*.png ] ; then
      qsub run_plot_footprint_job_${SPEC}.sh
    fi
  done
  popd
done
