process prediction {
    label 'predict'
    publishDir "${params.output_path}", pattern : "predictions/*.tiff", mode : "copy"
    input: tuple path(test_im), path(modelpath), val(tilesize), val(tileoverlap)

    output:
    path "predictions/*.tiff", emit: prediction_folder
    script:
    """
    careamics predict  $modelpath $test_im  --tile-size $tilesize --tile-overlap $tileoverlap
    """
}

