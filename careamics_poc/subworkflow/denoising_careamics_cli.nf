include {TRAIN_N2N_CARE} from './../modules/train_n2n_care/main.nf'
include {TRAIN_N2V} from './../modules/train_n2v/main.nf'
include {PREDICT} from './../modules/predict/main.nf'


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
            TRAIN_N2V(ch_combined)
            model_trained=TRAIN_N2V.out.model
            config=TRAIN_N2V.out.config
            PREDICT(test_data.combine(TRAIN_N2V.out.model)
                         .map{ test,model -> tuple( test,model,file_extension)})
            prediction=PREDICT.out.predictions
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
            TRAIN_N2N_CARE(ch_combined)
            model_trained=TRAIN_N2N_CARE.out.model
            config=TRAIN_N2N_CARE.out.config
            PREDICT(test_data.combine(TRAIN_N2N_CARE.out.model)
                         .map{ test,model -> tuple( test,model,file_extension)})
            prediction=PREDICT.out.predictions
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
            TRAIN_N2N_CARE(ch_combined)
            model_trained=TRAIN_N2N_CARE.out.model
            config=TRAIN_N2N_CARE.out.config
            PREDICT(test_data.combine(TRAIN_N2N_CARE_CLI.out.model)
                         .map{ test,model -> tuple( test,model,file_extension)})
            prediction=PREDICT.out.predictions
    }
    else {
        error "Unknown model: ${params.model}. Supported models: ${modelHandlers.keySet().join(', ')}"
    }
    emit:
    config_careamics=config
    model_careamics=model_trained
    prediction_careamics=prediction

}


