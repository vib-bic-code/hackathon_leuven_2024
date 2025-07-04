#!/usr/bin/env nextflow

include {configuration} from './modules/config.nf'  
include { training } from './modules/train.nf'
include { prediction } from './modules/predict.nf'

workflow {
       def patchsize = params.patch_size.join(',')
       configuration([
           model      : params.model,
           exp_name   : params.exp_name,
           batch_size : params.batch_size,
           patch_size  : patchsize,
           num_epoch  : params.num_epochs,
           data_type  : params.data_type,
           axis_train : params.axis_train
       ])
       def read_ch_test = Channel.fromPath("${params.test_path}/*.${params.file_extension}", checkIfExists:true)
       def read_ch_tr = Channel.fromPath("${params.train_path}/*.${params.file_extension}", checkIfExists:true)
       def read_ch_v = Channel.fromPath("${params.val_path}/*.${params.file_extension}", checkIfExists:true)
       input_training_ch = read_ch_tr.combine(read_ch_v)
                                     .combine(read_ch_test)
                                     .combine(configuration.out.config)
                                     .map{train, val, test, config -> tuple(train, val, test,config)}
       training(input_training_ch)
       def tilesize = params.tile_size.join(',')
       def tileoverlap = params.tile_overlap.join(',')
       def prediction_input_ch = read_ch_test
         .combine(training.out.model).map{test,model -> tuple(test,model, params.axis_train, tilesize, tileoverlap)}
       prediction_input_ch.view()
       prediction {prediction_input_ch}
}
