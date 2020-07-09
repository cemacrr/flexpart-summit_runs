#!/bin/bash
#$ -cwd -V
#$ -l h_rt=06:00:00
#$ -pe smp 8
#$ -l h_vmem=8G

# should have 8 arguments, each one being a FLEXPART job directory:
if [ "${#}" != "8" ] ; then
  echo "8 arguments required"
  exit
fi
# job directories:
JOB_DIRS="${@}"

# print the date:
date

# echo job directories:
echo "${JOB_DIRS}" | tr ' ' '\n'

# module loadings:
if [ -r /nobackup/cemac/cemac.sh ] ; then
  . /nobackup/cemac/cemac.sh
fi
module purge
module load user flexpart parallel
module list 2>&1

# run flexpart with parallel:
parallel 'cd {} ; FLEXPART >& FLEXPART.out' ::: ${JOB_DIRS}

# print the date:
date
