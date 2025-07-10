#!/usr/bin/env nextflow

include {configuration} from './modules/config.nf'  
include { training } from './modules/train.nf'
include { prediction } from './modules/predict.nf'

workflow {
       configuration([
           model      : params.model,
           exp_name   : params.exp_name,
           batch_size : params.batch_size,
           patch_size  : params.patch_size,
           num_epoch  : params.num_epochs,
           axes : params.axes
       ])
        def read_ch_test = Channel.fromPath("${params.test_path}/*.${params.file_extension}", checkIfExists:true)
        def read_ch_tr = Channel.fromPath("${params.train_path}/*.${params.file_extension}", checkIfExists:true)
        def read_ch_v = Channel.fromPath("${params.val_path}/*.${params.file_extension}", checkIfExists:true)
        input_training_ch = read_ch_tr.combine(read_ch_v)
                                      .combine(configuration.out.config)
                                      .map{train, val, config -> tuple(train, val,config)}
        training(input_training_ch)
        def prediction_input_ch = read_ch_test
            .combine(training.out.model).map{test,model -> tuple(test,model, params.tile_size, params.tile_overlap)}
        prediction_input_ch.view()
        prediction {prediction_input_ch}
}
