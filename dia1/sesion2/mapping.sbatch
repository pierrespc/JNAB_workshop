#!/bin/bash
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10gb
#SBATCH --output=%x.mappingPipeline.log
#SBATCH --error=%x.mappingPipeline.err

module load gcc

cd $SLURM_SUBMIT_DIR

./mapping_steps.sh $SLURM_JOB_NAME


