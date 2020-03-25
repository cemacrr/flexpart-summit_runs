#!/bin/bash

# job running script:
RUN_SCRIPT=$(dirname $(readlink -f ${0}))/../scripts/run_plot_footprint_job.sh

# for each directory:
for DIR in $(find 300_3000 -mindepth 1 -maxdepth 1 -type d -name '*300_3000')
do
    # run job script:
    \cp ${RUN_SCRIPT} ${DIR}/run_plot_footprint_job.sh
    chmod 755 ${DIR}/run_plot_footprint_job.sh
done
