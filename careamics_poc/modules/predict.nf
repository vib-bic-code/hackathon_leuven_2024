process prediction {
    label 'predict'
    input: tuple path(test_im), path(modelpath), val(file_extension) 

    output:
    path("predictions/*.${file_extension}"), emit: predictions
    script:
    def args = task.ext.args ?: ''
    """
    careamics predict  $modelpath $test_im  $args
    """
}

