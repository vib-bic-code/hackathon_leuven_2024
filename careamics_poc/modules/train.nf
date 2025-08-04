process training {
    label 'train'
    //container "community.wave.seqera.io/library/careamics:0.0.15--f3dd84103b1e9da6" //docker
    container 'oras://community.wave.seqera.io/library/careamics:0.0.15--79edde96e3aa7bcb' //apptainer

    input: tuple path(train_im), path(val_im), path(configpath)

    output:
    path "checkpoints/last.ckpt", emit: model
    script:
    """
    careamics train --train-source $train_im --val-source $val_im $configpath
    """
}
