process prediction {
    label 'predict'
  //container "community.wave.seqera.io/library/careamics:0.0.15--f3dd84103b1e9da6" //docker
    container 'oras://community.wave.seqera.io/library/careamics:0.0.15--79edde96e3aa7bcb' //apptainer
    input: tuple path(test_im), path(modelpath), val(file_extension) 

    output:
    path("predictions/*.${file_extension}"), emit: predictions
    script:
    def args = task.ext.args ?: ''
    """
    careamics predict  $modelpath $test_im  $args
    """
}

