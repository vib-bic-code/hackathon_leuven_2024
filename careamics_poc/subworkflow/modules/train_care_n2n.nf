process training {
    label 'train'
    
    input:
    tuple val(meta), path(train_im), path(target, name: "target/*"), path(configpath)

    output:
    path("checkpoints/last.ckpt"), emit: model

    script:
    def args = task.ext.args ?: ''
    """
    careamics train --train-source $train_im --train-target $target $configpath $args
    """
}