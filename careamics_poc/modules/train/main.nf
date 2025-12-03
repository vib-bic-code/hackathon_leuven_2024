process training {
    label 'process_gpu_medium'
    conda 'careamics'    

    input: tuple val(meta), path(train_im), path(val), path(configpath)

    output:
    path("checkpoints/last.ckpt"), emit: model

    when:

    task.ext.when == null || task.ext.when

    script:
  //  def args = task.ext.args ?: ''
    """
    careamics train --train-source $train_im --val-source $val  $configpath 
    """
    // a remettre dans le script $args

    
    stub:
    """
    mkdir checkpoints
    cd checkpoints
    touch "last.ckpt"
    """
}
