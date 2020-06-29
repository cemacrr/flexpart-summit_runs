#!/bin/bash

ALL_DIRS=$(\ls -1d 20190226-20190214/*)

for DIR in ${ALL_DIRS}
do
  pushd ${DIR}
  if [ ! -e output/grid*.nc ] ; then
    qsub run_job.sh
  fi
  popd
done
