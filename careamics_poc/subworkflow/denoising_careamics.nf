include {configuration as CONFIG_N2V; configuration as CONFIG_N2N; configuration as CONFIG_CARE } from './../modules/config.nf'  
include {training as TRAIN_N2V} from './../modules/train_n2v.nf'  
include { training as TRAIN_N2N; training as TRAIN_CARE } from './../modules/train_care_n2n.nf'  
include {prediction as PREDICT_N2V; prediction as PREDICT_N2N; prediction as PREDICT_CARE } from './../modules/predict.nf' 

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
            ch_images.view()
            CONFIG_N2V([model, exp_name, batch_size, patch_size, num_epochs, axes])
            config=CONFIG_N2V.out.config
            TRAIN_N2V(ch_images.combine(CONFIG_N2V.out.config))
            model_trained=TRAIN_N2V.out.model
            PREDICT_N2V(test_data.combine(TRAIN_N2V.out.model)
                                 .map{ test,model -> tuple( test,model)})
            prediction=PREDICT_N2V.out.predictions
    }
    else if (params.model == "care"){
            def ch_images = Channel.fromPath(input_csv, checkIfExists: true)
                                   .splitCsv(header:true)
                                   .map { row ->
                                        def meta = [:]
                                        meta.id = row.sample
                                        def image = file(row.image) 
                                        def image_target = file(row.image_target)
             return [meta, image, image_target]
         }
            ch_images.view()
            CONFIG_CARE([model, exp_name, batch_size, patch_size, num_epochs,axes])
            config=CONFIG_CARE.out.config
            TRAIN_CARE(ch_images.combine(CONFIG_CARE.out.config))
            model_trained=TRAIN_CARE.out.model
            input_pred=test_data.combine(TRAIN_CARE.out.model)
                                 .map{ test,model -> tuple(test,model)}
            input_pred.view()
            PREDICT_CARE(input_pred)
            prediction=PREDICT_CARE.out.predictions
    }
    else if (params.model == "n2n"){
            def ch_images = Channel.fromPath(input_csv, checkIfExists: true)
                                   .splitCsv(header:true)
                                   .map { row ->
                                        def meta = [:]
                                        meta.id = row.sample
                                        def image = file(row.image) 
                                        def image_target = file(row.image_target)
             return [meta, image, image_target]
         }
            ch_images.view()
            CONFIG_N2N([model, exp_name, batch_size, patch_size, num_epochs,axes])
            config=CONFIG_N2N.out.config
            TRAIN_N2N(ch_images.combine(CONFIG_N2N.out.config))
            model_trained=TRAIN_N2N.out.model
            PREDICT_N2N(test_data.combine(TRAIN_N2N.out.model)
                                 .map{test,model -> tuple( test,model)})
            prediction=PREDICT_N2N.out.predictions
    }
    else {
        error "Unknown model: ${params.model}. Supported models: ${modelHandlers.keySet().join(', ')}"
    }
    emit:
    config_careamics=config
    model_careamics=model_trained
    prediction_careamics=prediction

}


