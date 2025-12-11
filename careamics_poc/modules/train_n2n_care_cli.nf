process TRAIN_N2N_CARE_CLI {
    label 'process_gpu_medium'
    
    input: 
    tuple   val(meta), path(train), path(target, name: "target/*"), val(model)

    output:
    path("*.yaml"), emit: config
    path("checkpoints/last.ckpt"), emit: model

    script:
    def args = task.ext.args ?: ''
    """
    train_n2n_care.py   --train_data $train --train_target $target --model $model   --output_path . $args 
    """
}
