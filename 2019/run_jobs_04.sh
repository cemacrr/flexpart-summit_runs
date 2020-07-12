#!/bin/bash

MONTH='04'
OUT_DIR="${MONTH}_out"
mkdir -p ${OUT_DIR}

ALL_DIRS=$(readlink -f ${MONTH}/*)
COUNT=0
JOB_DIRS=''

for DIR in ${ALL_DIRS}
do
  pushd ${DIR}
  if [ ! -e output/grid*.nc ] ; then
    JOB_DIRS="${JOB_DIRS} ${DIR}"
    COUNT=$((${COUNT}+1))
  fi
  popd
  if [ "${COUNT}" = "8" ] ; then
    qsub -e ${OUT_DIR} -o ${OUT_DIR} run_jobs.sh ${JOB_DIRS}
    COUNT=0
    JOB_DIRS=''
  fi
done
