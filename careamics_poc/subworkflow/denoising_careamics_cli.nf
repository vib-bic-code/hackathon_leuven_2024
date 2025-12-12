include {TRAIN_N2N_CARE_CLI } from './../modules/train_n2n_care_cli.nf'
include {TRAIN_N2V_CLI } from './../modules/train_n2v_cli.nf'
include {PREDICT_CLI } from './../modules/predict_cli.nf'


workflow DENOISING {
    take:
    input_csv
    test_data
    model
    exp_name
    batch_size
    patch_size
    num_epochs
    axes
    file_extension

    main: 
    if (params.model == "n2v") {
            def ch_images = Channel.fromPath(input_csv, checkIfExists: true)
                                   .splitCsv(header:true)
                                   .map { row ->
                                        def meta = [:]
                                        meta.id = row.sample
                                        def image = file(row.image)
                                        def image_val = file(row.image_val) 
             return [meta, image, image_val]
         }
            ch_combined = ch_images.map { meta, path_a, path_b ->
                        tuple(meta, path_a, path_b, model)
                        }
            TRAIN_N2V_CLI(ch_combined)
            model_trained=TRAIN_N2V_CLI.out.model
            config=TRAIN_N2V_CLI.out.config
            PREDICT_CLI(test_data.combine(TRAIN_N2V_CLI.out.model)
                         .map{ test,model -> tuple( test,model,file_extension)})
            prediction=PREDICT_CLI.out.predictions
    }
    else if (params.model == "care"){
            def ch_images = Channel.fromPath(input_csv, checkIfExists: true)
                                   .splitCsv(header:true)
                                   .map { row ->
                                        def meta = [:]
                                        meta.id = row.sample
                                        def image = file(row.image)
                                        def image_target = file(row.image_target) 
             return [meta, image, image_target]}
            ch_combined = ch_images.map { meta, path_a, path_b ->
            tuple(meta, path_a, path_b, params.model)}
            TRAIN_N2N_CARE_CLI(ch_combined)
            model_trained=TRAIN_N2N_CARE_CLI.out.model
            config=TRAIN_N2N_CARE_CLI.out.config
            PREDICT_CLI(test_data.combine(TRAIN_N2N_CARE_CLI.out.model)
                         .map{ test,model -> tuple( test,model,file_extension)})
            prediction=PREDICT_CLI.out.predictions
    }
    else if (params.model == "n2n"){
            def ch_images = Channel.fromPath(input_csv, checkIfExists: true)
                                   .splitCsv(header:true)
                                   .map { row ->
                                        def meta = [:]
                                        meta.id = row.sample
                                        def image = file(row.image)
                                        def image_target = file(row.image_target) 
             return [meta, image, image_target]}
            ch_combined = ch_images.map { meta, path_a, path_b ->
            tuple(meta, path_a, path_b, params.model)}
            TRAIN_N2N_CARE_CLI(ch_combined)
            model_trained=TRAIN_N2N_CARE_CLI.out.model
            config=TRAIN_N2N_CARE_CLI.out.config
            PREDICT_CLI(test_data.combine(TRAIN_N2N_CARE_CLI.out.model)
                         .map{ test,model -> tuple( test,model,file_extension)})
            prediction=PREDICT_CLI.out.predictions
    }
    else {
        error "Unknown model: ${params.model}. Supported models: ${modelHandlers.keySet().join(', ')}"
    }
    emit:
    config_careamics=config
    model_careamics=model_trained
    prediction_careamics=prediction

}


