process prediction {
    label 'predict'
    publishDir "${params.output_path}", pattern : "predictions/*.tiff", mode : "copy"
    input: tuple path(test_im), path(modelpath), val(axes), val(tile_size), val(tile_overlap)

    output:
    path "predictions/*.tiff", emit: prediction_folder
    script:
    """
    predict.py --test_path $test_im --model_path $modelpath --axes $axes  --tile_size $tile_size --tile_overlap $tile_overlap 
    """
}
