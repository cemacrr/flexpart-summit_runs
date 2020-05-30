#!/bin/bash

# job running script:
RUN_SCRIPT=$(dirname $(readlink -f ${0}))/../scripts/run_plot_footprint_job_bwd_v01.sh

# species:
SPECIES='AIRTRACER AERO-TRACE MIN_DUST'

# for each directory:
for DIR in $(\ls -1d *split*/* | head -n 1)
do
    # for each species:
    for SPEC in ${SPECIES}
    do
      # run job script:
      \cp ${RUN_SCRIPT} ${DIR}/run_plot_footprint_job_${SPEC}.sh
      chmod 755 ${DIR}/run_plot_footprint_job_${SPEC}.sh
      # set species name in job script::
      sed -i "s|XSPECIESX|${SPEC}|g" ${DIR}/run_plot_footprint_job_${SPEC}.sh 
    done
done
