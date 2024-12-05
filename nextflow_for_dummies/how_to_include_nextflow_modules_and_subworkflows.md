# How to include a nextflow module or sub-workflow into a custom pipeline

During the Leuven 2025 hackathon we explored how to re-use existing nextflow modules and sub-workflows. In this document we report what we did. It is written in a way such that it should be reproducible by any interested reader. Please note that you may have to slightly adapt certain things depending on your IT infrastructure. For example, on some HPC you may not be allowed to use docker but may be required to use singularity.

Please note that this document is hacked and does not attempt to be a proper documentation.

## Tested

### Module: spotiflow, docker, macOS 13.5, Apple M2
 
- Tester: Tischi
- It works
- Issue: Spotiflow runs for 6 minutes to decode a 400x400 pixel uint8 image; this is probably the case because the container image was not build for this CPU architecture

### Module: cellpose, singularity, GNU/Linux, x86_64

- Tester: Arif
- It works

### Module: ilastik_pixelclassification, singularity, GNU/Linux, x86_64

- Tester: Arif
- It works

### Module: spotiflow, singularity, GNU/Linux, x86_64

- Tester: Tischi
- It works
- It ran fast: Spotiflow ran the prediction on one 400x400 pixel image in 6 seconds

### Subworkflow: tiled_spotiflow, singularity, GNU/Linux, x86_64

- Tester: Tischi
- Not working yet: OSError: [Errno 30] Read-only file system: '/models/general/last.pt'
- https://github.com/weigertlab/spotiflow/issues/23

## Issues

- https://github.com/nf-core/modules/issues/7159

## Finding nf-core image analysis modules:

- Go to: https://nf-co.re/modules/
- Type: image into the search bar

## Prerequisites

- conda
- docker, singularity or some other container engine

## Nextflow & nf-core installation

```
conda create --name nextflow python=3.12 nf-core nextflow
conda activate nextflow
```

## Create a working directory

Make sure that there is no file named “.nf-core.yml” in current directory

```
mkdir my-workflow
cd my-workflow
```

## Prepare input image data

```
mkdir example-data
curl -L -o example-data/data000.tif https://github.com/NEUBIAS/training-resources/raw/refs/heads/master/image_data/xy_8bit__spots_local_background.tif
```

Of course, you could use any other image data; you can also add more then one image to the folder. Nextflow will then analyze all of them.

## Download the module or sub-workflow of choice

### Download an nf-core module (example: spotiflow)...

```
nf-core modules install spotiflow
```

### ...or download a custom subworkflow (example: tiled_spotiflow from Tong Li)...

Check which subworkflows are available in a custom repo:

```
nf-core subworkflows -g https://github.com/BioinfoTongLI/modules.git -b develop list remote
```

Install tiled_spotiflow

```
nf-core subworkflows -g https://github.com/BioinfoTongLI/modules.git -b develop install tiled_spotiflow
```

### ...for both installing a module or subworkflow 

Running the above `nf-core` command will ask you some questions, please answer:
- Pipeline
- y
- y

Troubleshooting:

- If you don't get the above choices, ‘but an error, this means there is a `.nf-core.yml` in the parent directory.
Consider if this file is necessary otherwise please delete it. If you need to keep the file, please start from the top in a new folder that does not have an `.nf-core.yml` it its parent

Check that it worked

``` 
ls 
```

There should be a `modules` and/or `subworkflows` folder containing subfolders with the downloaded material. 

## Inspect the module...

```
cat modules/nf-core/spotiflow/main.nf
```

Important observations:
- The name of the process is SPOTIFLOW
- It needs two inputs: `val(meta)` and `path(image_2d)`
- The module tag is `$meta.id`, which means that `meta` must be a map with at least the `id` key
- The SPOTIFLOW code is provided via a container

## ...or inspect the subworkflow

```
cat subworkflows/sanger/tiled_spotiflow/main.nf
```

To figure out what the input and outputs of the subworkflow are please inspect a `meta.yml` file in the folder structure.

## Create a minimal nextflow.config file

```
vim nextflow.config
```

Add this code to tell nextflow to use docker for fetching the dependencies:

```
process{
    publishDir = [
        path: {"${params.outdir}"},
        mode: 'copy'
    ]
}

profiles{
    docker.enabled          = true    
}
```

### Using singularity

Alternatively, instead of `docker`, you may use singularity as a container engine, in this case you need:

```
profiles{
    singularity.enabled          = true    
}
```

Moreover, spotiflow is downloading a model and thus needs access to a writable directory. To configure this you need to add to within the `process{ }` the following lines (**adapt** the paths):

```
    withName: SPOTIFLOW {
        containerOptions = "-B /path/to/my/writable/cache/singularity:$HOME"
    }
```

So, in total your `nextflow.config` should look like this:

```
process{
    publishDir = [
        path: {"${params.outdir}"},
        mode: 'copy'
    ]

    withName: SPOTIFLOW {
        containerOptions = "/path/to/my/writable/cache/singularity:$HOME""
    }
}

profiles{
    singularity.enabled          = true    
}
```


## Create a minimal main.nf file

```
vim main.nf
```

Add this content:

```
nextflow.enable.dsl=2

include { SPOTIFLOW } from './modules/nf-core/spotiflow'

workflow {
    input_images = Channel.fromPath(“${params.inputPath}/*.tif”)
                        .map{ path ->
                            def meta = [id: path.getBaseName()]
                            tuple(meta, path)
                        }
    SPOTIFLOW(input_images)
}
```

## Run the workflow

```
nextflow run . --inputPath ./example-data/ --outdir ./output
```

IMP: this code would only work for the TIFF (`*.tif`) images in the “--inputPath”

Check that you got the output CSV:

```
ls -la output
```

## Additional notes

### Singularity

If you run the modules using Apptainer/Singularity please consider the following commands

```
export SINGULARITY_CACHEDIR=/g/cba/cache/singularity
export NXF_SINGULARITY_CACHEDIR=/g/cba/cache/singularity
```















