process training {
    label 'train'
    publishDir "${params.output_path}", pattern : "checkpoints/last.ckpt", mode : "copy"
    input: tuple path(train_im), path(val_im), path (test_im), path(configpath)

    output:
    path "checkpoints/last.ckpt", emit: model
    script:
    """
    train.py --train_path $train_im --val_path $val_im --test_path $test_im --output_path ./training --config_path $configpath
    """
}
