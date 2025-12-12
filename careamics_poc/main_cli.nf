#!/usr/bin/env nextflow

include {DENOISING} from './subworkflow/denoising_careamics_cli.nf'  

workflow {
    def read_ch_test = Channel.fromPath("${params.test_path}/*.${params.file_extension}", checkIfExists:true)
    DENOISING (params.input_csv, 
               read_ch_test,
               params.model,
               params.exp_name,
               params.batch_size,
               params.patch_size,
               params.num_epochs,
               params.axes,
               params.file_extension) 
}
