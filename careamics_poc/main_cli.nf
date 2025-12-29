#!/usr/bin/env nextflow

include {DENOISING} from './subworkflow/denoising_careamics_cli.nf'  

workflow {
    def read_ch_test = Channel.fromPath("${params.test_path}/*.${params.file_extension}", checkIfExists:true)
    DENOISING (params.input_csv, 
               read_ch_test,
               params.model,
               params.file_extension) 
}
