# Readme

## usage

- starts from a csv
- can be run on HPC slurm (if needed I will add the nextflow.config on the cluster)/locally
- using docker or apptainer
- predict.nf can be used independently from train.nf

```bash
nextflow run main.nf -profile vsc_kul_uhasselt,tier2kul_custom --model n2v
```

## to do
- clean config
- add tests
- add documentations
- test conda

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
