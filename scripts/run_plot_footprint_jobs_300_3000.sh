#!/bin/bash

ALL_DIRS=$(\ls -1d 300_3000/*)

for DIR in ${ALL_DIRS}
do
  pushd ${DIR}
  if [ ! -e plot_footprint/*.png ] ; then
    qsub run_plot_footprint_job.sh
  fi
  popd
done
