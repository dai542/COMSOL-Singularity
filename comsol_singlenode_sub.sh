#!/bin/bash
#Author: DJ <admin@djhpc.top>  
#SBATCH --job-name=COMSOL
#SBATCH --partition=cpu  
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10  
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err

module purge
#module load mpi/openmpi/5.0.3/gcc9.3.0-pmix4.2.9

cd $SLURM_SUBMIT_DIR
INPUT=$1
OUTPUT="${INPUT%%.*}.out"
BATCHLOG="${INPUT%%.*}.log"
SIF=/nfs/sifs/comsol6.3.290-rocky8.10.sif 

echo "SLURM_CPUS_ON_NODE: $SLURM_CPUS_ON_NODE"
echo "SLURM_JOB_CPUS_PER_NODE: $SLURM_JOB_CPUS_PER_NODE"

export SINGULARITY_BIND="/nfs,/tmp"

# COMSOL command, using -np to specify the number of processors
singularity exec $SIF comsol -np $SLURM_NTASKS batch -mpibootstrap slurm -inputfile ${INPUT} -outputfile ${OUTPUT} -batchlog ${BATCHLOG}
