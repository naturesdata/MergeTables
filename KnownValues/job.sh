#!/bin/bash

JOB_NAME="known-values"

sbatch -J $JOB_NAME \
    --time=03-00:00:00 \
    --nodes=1 \
    --ntasks=1 \
    --mem=3G \
    -o ${JOB_NAME}.out \
    -e ${JOB_NAME}.err \
    ${JOB_NAME}.sh
