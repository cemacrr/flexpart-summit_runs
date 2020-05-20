#!/bin/bash

ALL_DIRS=$(\ls -1d *split_IR*/*)

for DIR in ${ALL_DIRS}
do
  pushd ${DIR}
  if [ ! -e output/grid*.nc ] ; then
    qsub run_job.sh
  fi
  popd
done
