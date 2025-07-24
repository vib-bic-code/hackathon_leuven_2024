process prediction {
    label 'predict'
    input: tuple path(test_im), path(modelpath)

    output:
    path("predictions/*.${params.file_extension}"), emit: predictions
    script:
    def args = task.ext.args ?: ''
    """
    careamics predict  $modelpath $test_im  $args
    """
}

