process training {
    label 'process_gpu_medium'
    //container "community.wave.seqera.io/library/careamics:0.0.16--973e324f2f759ff5" //docker
    //container "community.wave.seqera.io/library/careamics:0.0.16--2d14874a14adc1ce" //apptainer
    //container "careamics_0.0.16--2d14874a14adc1ce.sif" //local apptainer
    container "careamics:0.0.16" //local docker
    
    input: tuple val(meta), path(train_im), path(val), path(configpath)

    output:
    path("checkpoints/last.ckpt"), emit: model

    script:
  //  def args = task.ext.args ?: ''
    """
    careamics train --train-source $train_im --val-source $val  $configpath 
    """
    // a remettre dans le script $args
}
