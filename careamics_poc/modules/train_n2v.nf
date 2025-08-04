process training {
    label 'train'
  //container "community.wave.seqera.io/library/careamics:0.0.15--f3dd84103b1e9da6" //docker
    container 'oras://community.wave.seqera.io/library/careamics:0.0.15--79edde96e3aa7bcb' //apptainer
    input: tuple val(meta), path(train_im), path(val), path(configpath)

    output:
    path("checkpoints/last.ckpt"), emit: model

    script:
    def args = task.ext.args ?: ''
    """
    careamics train --train-source $train_im --val-source $val  $configpath $args
    """
}
