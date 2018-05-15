## ###################################
## Input for the Quing System (SLURM)
## ###################################
## Update to your project account
#SBATCH --account=<your projec account>

## Chose a suitable job name
#SBATCH --job-name=FluentTEST

## The maximal wall time limit for normal jobs is 7 days (168 hours).
#SBATCH --time=0-0:10:0

## Number of nodes: chose between 4 and 32 for a normal job
#SBATCH --nodes=4

## Retain the default number of tasks to start on each node
#SBATCH --ntasks-per-node=32
#SBATCH --cpus-per-task=1

## ###################################
## Executing before running Fluent
## ###################################

## Recommended safety settings:
set -o errexit # Make bash exit on any error
set -o nounset # Treat unset variables as errors

## Software modules
module restore system # Restore loaded modules to the default
module load Fluent/18.2

## Preparing the input files in the working directory
##
## Use the files directly, drop the use of scratch
#mydir=`pwd`
#cd ..
#cp -r $mydir $SCRATCH
#cd $SCRATCH
#cd `basename $mydir`

## ###################################
## Running Fluent batch job
## ###################################
nodes=`scontrol show hostname $SLURM_JOB_NODELIST | paste -d, -s`

## Use 2ddp for 2D simulations and 3ddp for 3D simulations
fluent 2ddp -i input.jou -pinfiniband -t${SLURM_NTASKS} -cnf=${nodes} -g # > ${mydir}/stdout.out 2>&1  # standard error redirected to standard out 
#2>$mydir/error.out

## Make sure output is copied back after job finishes
## You can add other file extensions to copy monitor files etc.
##
## We are dropping use of scratch
