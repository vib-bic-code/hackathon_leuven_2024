# Readme

## usage

- starts from a csv
- can be run on HPC slurm/locally
- using docker or apptainer
- predict.nf can be used independently from train.nf

## to do
- put as a nfcore pipeline (add tests, standardised installation (bioconda/biocontainer or seqera wave containers => see my questions)

## questions

### careamics itself
1. Will there be a CLI tool like in cellpose ?
2. What is your progress on ome-zarr and will you accept omezarr sharding?
3. Bugra has a nice tool that can convert any format to the new omezarr (https://github.com/Euro-BioImaging/EuBI-Bridge) and it will be a nfcore module
4. Besides train_source and val_source can you tell me which parameters are mandatory for the careamist.train (are train_target+ val_target mandatory for care and  train_target for n2n)?
5. Do you prefer I use checkpoint (ckpt) or bmz model (zip) to save and load a training model? Also if I use the ckpt, which one should I use?

### careamics installation
1. are these your containers?
   ![image](https://github.com/user-attachments/assets/94121dad-9502-4694-b195-49b1eda533f1)
2. if not were do you want to put your containers?
3. do you want a conda installation for the nfcore?

### general
- let me know whether there are any mistakes or things that can be done better
- subworkflow will be use as a succession of three module (i.e. config.nf + train.nf + test.nf)
