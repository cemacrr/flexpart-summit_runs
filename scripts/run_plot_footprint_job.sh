#!/bin/bash
#$ -cwd -V
#$ -l h_rt=1:30:00
#$ -pe smp 1
#$ -l h_vmem=8G

# print date:
date

# load modules:
module purge

# load conda environment with iris:
. /nobackup/earrr/conda/etc/profile.d/conda.sh
conda activate iris

# check which modules are loaded:
module list

# python script:
PLOT_SCRIPT='/nobackup/earrr/flexpart/neely/scripts/plot_flexpart_footprint.py'

# get the run name:
RUN_NAME=$(basename $(pwd) | egrep -o '.*REL_[0-9]+?')

# plot the time steps:
mkdir -p plot_footprint
cd plot_footprint
${PLOT_SCRIPT} ../output/grid*.nc AIRTRACER ${RUN_NAME}

# print the date:
date
