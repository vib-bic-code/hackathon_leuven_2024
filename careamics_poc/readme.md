# Readme

## usage

- starts from a csv
- can be run on HPC slurm (if needed I will add the nextflow.config on the cluster)/locally
- using docker or apptainer
- predict.nf can be used independently from train.nf

```bash

# on wsl with docker
nextflow run main.nf -c nextflow.config_care --profile docker_wsl --model care --basepath path_where_data_folder_is
# on a cluster with conda
nextflow run main.nf -profile vsc_kul_uhasselt,conda_tier2 --model n2v --basepath path_where_data_folder_is
# on another cluster with singularity
nextflow run main.nf -profile vsc_ugent,singularity_tier1 --model n2n --basepath path_where_data_folder_is

```

## to do
- clean config =>done
- add tests
- add documentations
- test conda => done

## how to use the containers from seqera

### Apptainer

```bash
wget https://wave.seqera.io/view/builds/bd-79edde96e3aa7bcb_1
# use /tmp instead of $VSC_SCRATCH on Tier1
export APPTAINER_CACHE=$VSC_SCRATCH/.apptainer 
export APPTAINER_TMP=$VSC_SCRATCH/.apptainer
apptainer pull careamics_wave.sif oras://community.wave.seqera.io/library/careamics:0.0.15--79edde96e3aa7bcb
```

### general
- let me know whether there are any mistakes or things that can be done better
- subworkflow will be use as a succession of three module (i.e. config.nf + train.nf + test.nf)
