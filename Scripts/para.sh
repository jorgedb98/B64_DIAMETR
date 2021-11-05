#!/bin/bash
echo $SLURM_ARRAY_TASK_ID $(hostname)
sleep 0
echo $SLURM_ARRAY_TASK_ID $(date)
