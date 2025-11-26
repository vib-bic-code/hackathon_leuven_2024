process training {
    label 'process_gpu_medium'

    input: tuple path(train_im), path(val_im), path(configpath)

    output:
    path "checkpoints/last.ckpt", emit: model
    script:
    """
    careamics train --train-source $train_im --val-source $val_im $configpath
    """
}
