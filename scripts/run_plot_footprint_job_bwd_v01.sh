#!/bin/bash
#$ -cwd -V
#$ -l h_rt=3:00:00
#$ -pe smp 1
#$ -l h_vmem=8G

# print date:
date

# load modules:
module purge

# load python3 environment:
module load python3

# check which modules are loaded:
module list 2>&1

# python script:
PLOT_SCRIPT='/nobackup/earrr/flexpart/neely/scripts/plot_flexpart_footprint_v01.py'

# get the run name:
RUN_NAME=$(basename $(pwd) | egrep -o '.*REL_[0-9]+?')_XSPECIESX

# plot the footprints:
mkdir -p plot_footprint_XSPECIESX
cd plot_footprint_XSPECIESX
${PLOT_SCRIPT} ../output/grid*.nc XSPECIESX ${RUN_NAME}

# print the date:
date
