process training {
    label 'train'
    publishDir "${params.output_path}", pattern : "checkpoints/last.ckpt", mode : "copy"
    input: tuple path(train_im), path(val_im), path(configpath)

    output:
    path "checkpoints/last.ckpt", emit: model
    script:
    """
    careamics train --train-source $train_im --val-source $val_im $configpath
    """
}
