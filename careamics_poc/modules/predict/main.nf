process PREDICT{
    label 'process_gpu_medium'

    input: tuple path(test_im), path(modelpath), val(file_extension) 

    output:
    path("predictions/*.${file_extension}"), emit: predictions
    script:
    def args = task.ext.args ?: ''
    """
    predict.py --trained_model $modelpath --test_data $test_im  $args
    """
    stub: 
    """
    mkdir predictions
    cd predictions
    touch test.tiff
    """
}

