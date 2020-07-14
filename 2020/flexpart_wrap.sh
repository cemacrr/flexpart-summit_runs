#!/bin/bash
RUN_DIR=${1}
DIR_NAME=$(basename ${RUN_DIR})
cd ${RUN_DIR}
mv output __output
mkdir -p ${TMPDIR}/${DIR_NAME}/output
ln -s ${TMPDIR}/${DIR_NAME}/output output
FLEXPART >& FLEXPART.out
\mv output/* __output/
\rm output
mv __output output
