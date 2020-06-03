#!/bin/bash
#$ -cwd -V
#$ -l h_rt=0:20:00
#$ -pe smp 1
#$ -l h_vmem=16G

# print the date:
date

# module loadings:
if [ -r /nobackup/cemac/cemac.sh ] ; then
  . /nobackup/cemac/cemac.sh
fi
module purge
module load user flexpart
module list 2>&1

# run flexpart:
FLEXPART

# print the date:
date
