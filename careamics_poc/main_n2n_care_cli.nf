include {TRAIN_N2N_CARE_CLI } from './modules/train_n2n_care_cli.nf'
include {PREDICT_CLI } from './modules/predict_cli.nf'

workflow{
    def ch_images = Channel.fromPath(params.input_csv, checkIfExists: true)
                                   .splitCsv(header:true)
                                   .map { row ->
                                        def meta = [:]
                                        meta.id = row.sample
                                        def image = file(row.image)
                                        def image_target = file(row.image_target) 
             return [meta, image, image_target]
         }
    ch_combined = ch_images.map { meta, path_a, path_b ->
        tuple(meta, path_a, path_b, params.model)
    }
    ch_combined.view()
    TRAIN_N2N_CARE_CLI(ch_combined)
    model_trained=TRAIN_N2N_CARE_CLI.out.model
    def test_data = Channel.fromPath("${params.test_path}/*.${params.file_extension}", checkIfExists:true)
    PREDICT_CLI(test_data.combine(TRAIN_N2N_CARE_CLI.out.model)
                         .map{ test,model -> tuple( test,model,params.file_extension)})

}
