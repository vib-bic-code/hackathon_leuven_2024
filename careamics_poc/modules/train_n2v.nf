process training {
    label 'train'
    input: tuple val(meta), path(train_im), path(val), path(configpath)
    //, path(target) gives error
    //  path(target, stageAs: "?/*")

    output:
    path("checkpoints/last.ckpt"), emit: model

// --train-target $target
    script:
    def args = task.ext.args ?: ''
    """
    careamics train --train-source $train_im --val-source $val  $configpath $args
    """
}
