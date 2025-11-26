process prediction {
    label 'process_gpu_medium'
     //container "community.wave.seqera.io/library/careamics:0.0.16--973e324f2f759ff5" //docker
    //container "oras://community.wave.seqera.io/library/careamics:0.0.16--2d14874a14adc1ce" //apptainer
    //container "careamics_0.0.16--2d14874a14adc1ce.sif" //local apptainer
    container "careamics:0.0.16" //local docker

    input: tuple path(test_im), path(modelpath), val(file_extension) 

    output:
    path("predictions/*.${file_extension}"), emit: predictions
    script:
    def args = task.ext.args ?: ''
    """
    careamics predict  $modelpath $test_im  $args
    """
}

