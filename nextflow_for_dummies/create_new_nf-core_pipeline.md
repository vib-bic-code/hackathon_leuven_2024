# nf-core pipeline

## Tool Installation and configuration

### Conda installation of nf-core tools
```bash
conda create -n nf python=3.12 nextflow nf-core -c bioconda
```

### Activate the nf conda environmment 
```bash
conda activate nf
```

## Run the pipeline creation
```bash
nf-core pipelines create
```
![image](https://github.com/user-attachments/assets/27179563-fa2c-4739-8746-901580e67197)

### Configuration

- Click on `Let's Go`
![image](https://github.com/user-attachments/assets/2f9ccd90-932f-4c48-9423-93bc260e1110)

- Select `Custom`

> [!CAUTION]
> Workflow name should be lowercase and only alpha numerical character (so e..g. no `-`)

Populate the fields:
- Workflow Name : nfcore_myworflow
- Description
- Name of authors
  
=> `Next`

Keep only:
- Add configuration file
- Use code linter
- Incude citation
- Incude a gitpod environment
- Use nf-core components
- Add a change log
- Use nf-schema
- Add a license file
- Add documentation
- Add testing profiles
  
=> `Continue`
Leave default
=> `Finish`

This will create the skeleton pre-filled with example from fastq of a new workflow
=> `Continue`

Select `Finish withut creating a repo`

We will be able to add it to a github repo by doing:
```bash
cd pipeline_directory
git remote add origin git@github.com:<username>/<repo_name>.git
git push --all origin
```

### Check if github is configured
```bash
git config -l --global command
```
If not do:
```bash
git config --global user.name 'Benjamin Pavie'
git config --global user.email 'benjamin.pavie@gmail.com'
```

Go to github an create a new github repository, e.g. https://github.com/bpavie/test_pipeline_nfcore

Add this to you github repository
```bash
cd nf-core-my-worflow
git remote add origin https://github.com/bpavie/test-nf-core-workflow.git
git push --all origin
```

If you use `https`, you get a message from github:
![image](https://github.com/user-attachments/assets/813bcd65-75d1-47d8-9dd8-f3821342be86)

If you follow the instruction, it will give the authorization to VSCOde to connect for you to your github account

Copy and continue to github


## Adapt the skeleton to your own pipeline

After the creation of the piepeline skeleton, you get:
- `main.nf` is the main nextflow script that gets run → Includes the workflow of the pipeline.
- `workflows/` → x
- `subworkflows/local` → here you can add aditional validation of your inputs.

#### Search the modules available in:

(Search for the module) [https://nf-co.re/modules/]

## Add an existing module :

```bash
nf-core modules install <module_name>
```
e.g.:
```bash
nf-core modules install molkartgarage/clahe



                                          ,--./,-.
          ___     __   __   __   ___     /,-._.--~\ 
    |\ | |__  __ /  ` /  \ |__) |__         }  {
    | \| |       \__, \__/ |  \ |___     \`-._,-`-,
                                          `._,._,'

    nf-core/tools version 3.0.2 - https://nf-co.re


WARNING  'repository_type' not defined in .nf-core.yml                                                                                               
? Is this repository an nf-core pipeline or a fork of nf-core/modules? (Use arrow keys)
 » Pipeline
   nf-core/modules
```
Select `Pipeline`
```bash
INFO     To avoid this prompt in the future, add the 'repository_type' key to your .nf-core.yml file.                                                
? Would you like me to add this config now? [y/n] (y):
```
Enter `y`

## Edit `nf-core-my-worflow/workflows/myworflow.nf`
Include the module
```bash
include { paramsSummaryMap       } from 'plugin/nf-schema'

include { softwareVersionsToYAML } from '../subworkflows/nf-core/utils_nfcore_pipeline'
include { methodsDescriptionText } from '../subworkflows/local/utils_nfcore_myworflow_pipeline'
```

```bash
include { paramsSummaryMap       } from 'plugin/nf-schema'

include { MOLKARTGARAGE_CLAHE } from '../modules/nf-core/molkartgarage/clahe/main'
include { softwareVersionsToYAML } from '../subworkflows/nf-core/utils_nfcore_pipeline'
include { methodsDescriptionText } from '../subworkflows/local/utils_nfcore_myworflow_pipeline'
```
and call the module in the workflow 
```bash
    ch_versions = Channel.empty()
    //
    // Collate and save software versions
    //
    softwareVersionsToYAML(ch_versions)
```
```bash
    ch_versions = Channel.empty()
    
    MOLKARTGARAGE_CLAHE(ch_samplesheet)
    //
    // Collate and save software versions
    //
    softwareVersionsToYAML(ch_versions)
```
> [NOTE]
> What happend in the workflow is described in the `nf-core-my-worflow/workflows/myworflow.nf` file
> ```bash
>  workflow MYWORFLOW {
>     // Desribe the input, here a spreasheet
>     take:
>     ch_samplesheet // channel: samplesheet read in from --input
>     
>     main:
> 
>     ch_versions = Channel.empty()
> 
>     //Here,declare all the module run in your workflow 
>     MOLKARTGARAGE_CLAHE(ch_samplesheet)
> 
>     //
>     // Collate and save software versions for each module
>     //
>     softwareVersionsToYAML(ch_versions)
>         .collectFile(
>             storeDir: "${params.outdir}/pipeline_info",
>             name:  ''  + 'pipeline_software_' +  ''  + 'versions.yml',
>             sort: true,
>             newLine: true
>         ).set { ch_collated_versions }
> 
> 
>     emit:
>     versions       = ch_versions                 // channel: [ path(versions.yml) ]
> ```
}

## Check for existing dataset sample for this module
- Go to https://github.com/nf-core/test-datasets
- Switch for module and grab a ome.tiff images, e.g.
in https://github.com/nf-core/test-datasets/tree/modules/data/imaging/tiff and copy/paste a link, e.g.
`https://github.com/nf-core/test-datasets/raw/refs/heads/modules/data/imaging/ome-tiff/cycif-tonsil-cycle1.ome.tif`

## Adapt the `assets/samplesheet.csv`.
### Using the URL 
```bash
sample,fastq_1,fastq_2
SAMPLE_PAIRED_END,/path/to/fastq/files/AEG588A1_S1_L002_R1_001.fastq.gz,/path/to/fastq/files/AEG588A1_S1_L002_R2_001.fastq.gz
SAMPLE_SINGLE_END,/path/to/fastq/files/AEG588A4_S4_L003_R1_001.fastq.gz,
```
```bash
sample,image
sample0,https://github.com/nf-core/test-datasets/raw/refs/heads/modules/data/imaging/ome-tiff/cycif-tonsil-cycle1.ome.tif
```

### Using local files
Alternatively, we could download the image and store it indot a new folder:
!!! Only for non-NF-core pipeline, otherwise dataset must be in https://github.com/nf-core/test-datasets/tree/pipeline/, create a new branch with your piepleine name and store the dataset there!!!
```bash
mkdir ../test
cd ../test
wget https://github.com/nf-core/test-datasets/raw/refs/heads/modules/data/imaging/ome-tiff/cycif-tonsil-cycle1.ome.tif ./
cd ..
vim assets/samplesheet.csv

sample,image
sample0,../test/cycif-tonsil-cycle1.ome.tif
```

## Edit the `main.nf` file to modify the workflow name
```bash
NFCORE_MY-WORFLOW (
        PIPELINE_INITIALISATION.out.samplesheet
    )
```
```bash
NFCORE-PIPELINE-TEST (
        PIPELINE_INITIALISATION.out.samplesheet
    )
```
## Edit the `assets/schema_inputs.json` file to modify the workflow name
CHange from
```bash
            "fastq_1": {
                "type": "string",
                "format": "file-path",
                "exists": true,
                "pattern": "^\\S+\\.f(ast)?q\\.gz$",
                "errorMessage": "FastQ file for reads 1 must be provided, cannot contain spaces and must have extension '.fq.gz' or '.fastq.gz'"
            },
            "fastq_2": {
                "type": "string",
                "format": "file-path",
                "exists": true,
                "pattern": "^\\S+\\.f(ast)?q\\.gz$",
                "errorMessage": "FastQ file for reads 2 cannot contain spaces and must have extension '.fq.gz' or '.fastq.gz'"
          }
        },
        "required": ["sample", "fastq_1"]
```
To
```bash
            "image": {
                "type": "string",
                "format": "file-path",
                "exists": true,
                "pattern": "^\\S+\\.tif(f)?$",
                "errorMessage": "Tiff file image must be provided, containing no space and must have extension 'tif' or '.tiff'"
          }
        },
        "required": ["sample", "image"]
```

## Modify the file `nf-core-my-worflow/subworkflows/local/utils_nfcore_myworflow_pipeline/main.nf`
Replace
```bash
Channel
        .fromList(samplesheetToList(params.input, "${projectDir}/assets/schema_input.json"))
        .map {
            meta, fastq_1, fastq_2 ->
                if (!fastq_2) {
                    return [ meta.id, meta + [ single_end:true ], [ fastq_1 ] ]
                } else {
                    return [ meta.id, meta + [ single_end:false ], [ fastq_1, fastq_2 ] ]
                }
        }
        .groupTuple()
        .map { samplesheet ->
            validateInputSamplesheet(samplesheet)
        }
        .map {
            meta, fastqs ->
                return [ meta, fastqs.flatten() ]
        }
        .set { ch_samplesheet }
```
by
```bash
Channel
    .fromList(samplesheetToList(params.input, "${projectDir}/assets/schema_input.json"))
    .map { samplesheet ->
      validateInputSamplesheet(samplesheet)
    }
    .set { ch_samplesheet }
```

and
```bash
def validateInputSamplesheet(input) {
    def (metas, fastqs) = input[1..2]

    // Check that multiple runs of the same sample are of the same datatype i.e. single-end / paired-end
    def endedness_ok = metas.collect{ meta -> meta.single_end }.unique().size == 1
    if (!endedness_ok) {
        error("Please check input samplesheet -> Multiple runs of a sample must be of the same datatype i.e. single-end or paired-end: ${metas[0].id}")
    }

    return [ metas[0], fastqs ]
}
```
by
```bash

def validateInputSamplesheet(input) {
    return input
}
```


> [!CAUTION]
> Before to test the workflow with the module using container, on VSC we can run only Singularity container, so you need
> to set the apptainer tmp and cache dir
> ```bash
> cd /tmp/
> chmod a+rwx . 
> export APPTAINER_CACHEDIR=/tmp/
> export APPTAINER_TMPDIR=/tmp/
> ```
> We could also define a tmp dir for the cache:
> ```bash
> NXF_SINGULARITY_CACHEDIR=/tmp/
> ```

## Test to debug if everything is OK
After that, check if it complains by running. Ideally you will be constantly running this so you can debug. Here, we test with singularity since the added module as configuration for container only
```bash
nextflow run .  --input ./assets/samplesheet.csv --outdir my_output_dir -profile test,singularity
```

You could have the following errors:

#### Singularity error
```bash
(nf) [vsc33625@gpu513 nf-core-my-worflow]$ nextflow run .  --input ./assets/samplesheet.csv --outdir my_output_dir -profile test,singularity

 N E X T F L O W   ~  version 24.10.2

Launching `./main.nf` [lonely_jang] DSL2 - revision: 8ff465adea

Input/output options
  input                     : ./assets/samplesheet.csv
  outdir                    : .

Institutional config options
  config_profile_name       : Test profile
  config_profile_description: Minimal test dataset to check pipeline function

Core Nextflow options
  runName                   : lonely_jang
  containerEngine           : singularity
  launchDir                 : /vscmnt/leuven_icts/_data_leuven/336/vsc33625/nf-core-pipeline-test/nf-core-my-worflow
  workDir                   : /vscmnt/leuven_icts/_data_leuven/336/vsc33625/nf-core-pipeline-test/nf-core-my-worflow/work
  projectDir                : /vscmnt/leuven_icts/_data_leuven/336/vsc33625/nf-core-pipeline-test/nf-core-my-worflow
  userName                  : vsc33625
  profile                   : test,singularity
  configFiles               : 

!! Only displaying parameters that differ from the pipeline defaults !!
------------------------------------------------------
executor >  local (1)
[b2/99d23c] NFCORE_MYWORFLOW:MYWORFLOW:MOLKARTGARAGE_CLAHE (sample0) [  0%] 0 of 1
ERROR ~ Error executing process > 'NFCORE_MYWORFLOW:MYWORFLOW:MOLKARTGARAGE_CLAHE (sample0)'

Caused by:
  Process `NFCORE_MYWORFLOW:MYWORFLOW:MOLKARTGARAGE_CLAHE (sample0)` terminated with an error exit status (255)


Command executed:

  python /local/scripts/molkart_clahe.py         --input cycif-tonsil-cycle1.ome.tif         --output sample0.tiff         
  
  cat <<-END_VERSIONS > versions.yml
  "NFCORE_MYWORFLOW:MYWORFLOW:MOLKARTGARAGE_CLAHE":
      molkart_clahe: $(python /local/scripts/molkart_clahe.py --version)
executor >  local (1)
[b2/99d23c] NFCORE_MYWORFLOW:MYWORFLOW:MOLKARTGARAGE_CLAHE (sample0) [100%] 1 of 1, failed: 1 ✘
Execution cancelled -- Finishing pending tasks before exit
ERROR ~ Error executing process > 'NFCORE_MYWORFLOW:MYWORFLOW:MOLKARTGARAGE_CLAHE (sample0)'

Caused by:
  Process `NFCORE_MYWORFLOW:MYWORFLOW:MOLKARTGARAGE_CLAHE (sample0)` terminated with an error exit status (255)


Command executed:

  python /local/scripts/molkart_clahe.py         --input cycif-tonsil-cycle1.ome.tif         --output sample0.tiff         
  
  cat <<-END_VERSIONS > versions.yml
  "NFCORE_MYWORFLOW:MYWORFLOW:MOLKARTGARAGE_CLAHE":
      molkart_clahe: $(python /local/scripts/molkart_clahe.py --version)
      scikit-image: 0.19.2
  END_VERSIONS

executor >  local (1)
[b2/99d23c] NFCORE_MYWORFLOW:MYWORFLOW:MOLKARTGARAGE_CLAHE (sample0) [100%] 1 of 1, failed: 1 ✘
Execution cancelled -- Finishing pending tasks before exit
-[nf-core/my-worflow] Pipeline completed with errors-
ERROR ~ Error executing process > 'NFCORE_MYWORFLOW:MYWORFLOW:MOLKARTGARAGE_CLAHE (sample0)'

Caused by:
  Process `NFCORE_MYWORFLOW:MYWORFLOW:MOLKARTGARAGE_CLAHE (sample0)` terminated with an error exit status (255)


Command executed:

  python /local/scripts/molkart_clahe.py         --input cycif-tonsil-cycle1.ome.tif         --output sample0.tiff         
  
  cat <<-END_VERSIONS > versions.yml
  "NFCORE_MYWORFLOW:MYWORFLOW:MOLKARTGARAGE_CLAHE":
      molkart_clahe: $(python /local/scripts/molkart_clahe.py --version)
      scikit-image: 0.19.2
  END_VERSIONS

executor >  local (1)
[b2/99d23c] NFCORE_MYWORFLOW:MYWORFLOW:MOLKARTGARAGE_CLAHE (sample0) [100%] 1 of 1, failed: 1 ✘
Execution cancelled -- Finishing pending tasks before exit
-[nf-core/my-worflow] Pipeline completed with errors-
ERROR ~ Error executing process > 'NFCORE_MYWORFLOW:MYWORFLOW:MOLKARTGARAGE_CLAHE (sample0)'

Caused by:
  Process `NFCORE_MYWORFLOW:MYWORFLOW:MOLKARTGARAGE_CLAHE (sample0)` terminated with an error exit status (255)


Command executed:

  python /local/scripts/molkart_clahe.py         --input cycif-tonsil-cycle1.ome.tif         --output sample0.tiff         
  
  cat <<-END_VERSIONS > versions.yml
  "NFCORE_MYWORFLOW:MYWORFLOW:MOLKARTGARAGE_CLAHE":
      molkart_clahe: $(python /local/scripts/molkart_clahe.py --version)
      scikit-image: 0.19.2
  END_VERSIONS

Command exit status:
  255

Command output:
  (empty)

Command error:
  INFO:    Environment variable SINGULARITYENV_TMPDIR is set, but APPTAINERENV_TMPDIR is preferred
  INFO:    Environment variable SINGULARITYENV_NXF_TASK_WORKDIR is set, but APPTAINERENV_NXF_TASK_WORKDIR is preferred
  INFO:    Environment variable SINGULARITYENV_NXF_DEBUG is set, but APPTAINERENV_NXF_DEBUG is preferred
  FATAL:   apptainer image is not in an allowed configured path

Work dir:
  /vscmnt/leuven_icts/_data_leuven/336/vsc33625/nf-core-pipeline-test/nf-core-my-worflow/work/b2/99d23c9bbfc29c778cbbca581454bc

Container:
  /vscmnt/leuven_icts/_data_leuven/336/vsc33625/nf-core-pipeline-test/nf-core-my-worflow/work/singularity/ghcr.io-schapirolabor-molkart-local-v0.1.1.img

Tip: view the complete command output by changing to the process work dir and entering the command `cat .command.out`

 -- Check '.nextflow.log' file for details
ERROR ~ Pipeline failed. Please refer to troubleshooting docs: https://nf-co.re/docs/usage/troubleshooting

 -- Check '.nextflow.log' file for details
```

Measn that you have to run your singularity container in some specific place, here in the scratch.
TO do this, add the `-w` argument to your nextflow command, e.g.:
```bash
-w $VSC_SCRATCH_PROJECTS_BASE/2024_300/bpavie/nextflow_workdir/
```

#### Parameters error:

```bash
(nf) [vsc33625@gpu513 nf-core-my-worflow]$ nextflow run . --input ./assets/samplesheet.csv --outdir my_output_dir -profile test,singularity -w $VSC_SCRATCH_PROJEC
TS_BASE/2024_300/bpavie/nextflow_workdir/

 N E X T F L O W   ~  version 24.10.2

Launching `./main.nf` [elegant_shaw] DSL2 - revision: 8ff465adea

Input/output options
  input                     : ./assets/samplesheet.csv
  outdir                    : .

Institutional config options
  config_profile_name       : Test profile
  config_profile_description: Minimal test dataset to check pipeline function

Core Nextflow options
  runName                   : elegant_shaw
  containerEngine           : singularity
  launchDir                 : /vscmnt/leuven_icts/_data_leuven/336/vsc33625/nf-core-pipeline-test/nf-core-my-worflow
  workDir                   : /dodrio/scratch/projects/2024_300/bpavie/nextflow_workdir
  projectDir                : /vscmnt/leuven_icts/_data_leuven/336/vsc33625/nf-core-pipeline-test/nf-core-my-worflow
  userName                  : vsc33625
  profile                   : test,singularity
  configFiles               : 

!! Only displaying parameters that differ from the pipeline defaults !!
------------------------------------------------------
executor >  local (1)
[b3/22991a] NFCORE_MYWORFLOW:MYWORFLOW:MOLKARTGARAGE_CLAHE (sample0) [  0%] 0 of 1
ERROR ~ Error executing process > 'NFCORE_MYWORFLOW:MYWORFLOW:MOLKARTGARAGE_CLAHE (sample0)'

Caused by:
  Process `NFCORE_MYWORFLOW:MYWORFLOW:MOLKARTGARAGE_CLAHE (sample0)` terminated with an error exit status (2)


Command executed:

  python /local/scripts/molkart_clahe.py         --input cycif-tonsil-cycle1.ome.tif         --output sample0.tiff         
  
  cat <<-END_VERSIONS > versions.yml
  "NFCORE_MYWORFLOW:MYWORFLOW:MOLKARTGARAGE_CLAHE":
      molkart_clahe: $(python /local/scripts/molkart_clahe.py --version)
      scikit-image: 0.19.2
  END_VERSIONS
executor >  local (1)
[b3/22991a] NFCORE_MYWORFLOW:MYWORFLOW:MOLKARTGARAGE_CLAHE (sample0) [100%] 1 of 1, failed: 1 ✘
Execution cancelled -- Finishing pending tasks before exit
ERROR ~ Error executing process > 'NFCORE_MYWORFLOW:MYWORFLOW:MOLKARTGARAGE_CLAHE (sample0)'

Caused by:
  Process `NFCORE_MYWORFLOW:MYWORFLOW:MOLKARTGARAGE_CLAHE (sample0)` terminated with an error exit status (2)


Command executed:

  python /local/scripts/molkart_clahe.py         --input cycif-tonsil-cycle1.ome.tif         --output sample0.tiff         
  
  cat <<-END_VERSIONS > versions.yml
  "NFCORE_MYWORFLOW:MYWORFLOW:MOLKARTGARAGE_CLAHE":
      molkart_clahe: $(python /local/scripts/molkart_clahe.py --version)
      scikit-image: 0.19.2
  END_VERSIONS

Command exit status:
  2
executor >  local (1)
[b3/22991a] NFCORE_MYWORFLOW:MYWORFLOW:MOLKARTGARAGE_CLAHE (sample0) [100%] 1 of 1, failed: 1 ✘
Execution cancelled -- Finishing pending tasks before exit
-[nf-core/my-worflow] Pipeline completed with errors-
ERROR ~ Error executing process > 'NFCORE_MYWORFLOW:MYWORFLOW:MOLKARTGARAGE_CLAHE (sample0)'

Caused by:
  Process `NFCORE_MYWORFLOW:MYWORFLOW:MOLKARTGARAGE_CLAHE (sample0)` terminated with an error exit status (2)


Command executed:

  python /local/scripts/molkart_clahe.py         --input cycif-tonsil-cycle1.ome.tif         --output sample0.tiff         
  
  cat <<-END_VERSIONS > versions.yml
  "NFCORE_MYWORFLOW:MYWORFLOW:MOLKARTGARAGE_CLAHE":
      molkart_clahe: $(python /local/scripts/molkart_clahe.py --version)
      scikit-image: 0.19.2
  END_VERSIONS

Command exit status:
  2
executor >  local (1)
[b3/22991a] NFCORE_MYWORFLOW:MYWORFLOW:MOLKARTGARAGE_CLAHE (sample0) [100%] 1 of 1, failed: 1 ✘
Execution cancelled -- Finishing pending tasks before exit
-[nf-core/my-worflow] Pipeline completed with errors-
ERROR ~ Error executing process > 'NFCORE_MYWORFLOW:MYWORFLOW:MOLKARTGARAGE_CLAHE (sample0)'

Caused by:
  Process `NFCORE_MYWORFLOW:MYWORFLOW:MOLKARTGARAGE_CLAHE (sample0)` terminated with an error exit status (2)


Command executed:

  python /local/scripts/molkart_clahe.py         --input cycif-tonsil-cycle1.ome.tif         --output sample0.tiff         
  
  cat <<-END_VERSIONS > versions.yml
  "NFCORE_MYWORFLOW:MYWORFLOW:MOLKARTGARAGE_CLAHE":
      molkart_clahe: $(python /local/scripts/molkart_clahe.py --version)
      scikit-image: 0.19.2
  END_VERSIONS

Command exit status:
  2

Command output:
  (empty)

Command error:
  INFO:    Environment variable SINGULARITYENV_TMPDIR is set, but APPTAINERENV_TMPDIR is preferred
  INFO:    Environment variable SINGULARITYENV_NXF_TASK_WORKDIR is set, but APPTAINERENV_NXF_TASK_WORKDIR is preferred
  INFO:    Environment variable SINGULARITYENV_NXF_DEBUG is set, but APPTAINERENV_NXF_DEBUG is preferred
  usage: molkart_clahe.py [-h] -r INPUT -o OUTPUT --cliplimit CLIP
                          [--kernel KERNEL] [--nbins NBINS] [-p PIXEL_SIZE]
                          [--tile-size TILE_SIZE] [--version]
  molkart_clahe.py: error: the following arguments are required: --cliplimit

Work dir:
  /dodrio/scratch/projects/2024_300/bpavie/nextflow_workdir/b3/22991a4ea793166069d4c73f8783c8

Container:
  /dodrio/scratch/projects/2024_300/bpavie/nextflow_workdir/singularity/ghcr.io-schapirolabor-molkart-local-v0.1.1.img

Tip: you can try to figure out what's wrong by changing to the process work dir and showing the script file named `.command.sh`

 -- Check '.nextflow.log' file for details
ERROR ~ Pipeline failed. Please refer to troubleshooting docs: https://nf-co.re/docs/usage/troubleshooting

 -- Check '.nextflow.log' file for details
```

This error come from that some parameters are required by the module clahe, to fix this you need to add the required parameters to your `nextflow.config` and `conf/modules.config` :

1. edit `nextflow.config`
after
```bash
nf-core-my-worflow/nextflow.config
```
add
```bash

    //Clahe module params
    clahe_pyramid_tile          = 48
    clahe_cliplimit             = 0.01
    clahe_pixel_size            = 0.138
```
> [!NOTE]
> Parameters value can be retrieve from the test nextflow.config of the module itself, in `modules/nf-core/molkartgarage/clahe/tests/nextflow.config`


2. Edit  `conf/modules.config`
after
```bash
    publishDir = [
        path: { "${params.outdir}/${task.process.tokenize(':')[-1].tokenize('_')[0].toLowerCase()}" },
        mode: params.publish_dir_mode,
        saveAs: { filename -> filename.equals('versions.yml') ? null : filename }
    ]

```
add
```bash

    withName : "CLAHE"
    ext.args  = [ "",
            params.clahe_pyramid_tile ? "--tile-size ${params.clahe_pyramid_tile}" : "",
            params.clahe_cliplimit    ? "--cliplimit ${params.clahe_cliplimit}"    : "",
            params.clahe_pixel_size   ? "--pixel-size ${params.clahe_pixel_size}"  : ""

        ].join(" ").trim()
```


If everything fine, you should see
```bash
nextflow run . --input ./assets/samplesheet.csv --outdir my_output_dir -profile test,singularity -w $VSC_SCRATCH_PROJECTS_BASE/2024_300/bpavie/nextflow_workdir/

 N E X T F L O W   ~  version 24.10.2

Launching `./main.nf` [sad_gutenberg] DSL2 - revision: 8ff465adea

Input/output options
  input                     : ./assets/samplesheet.csv
  outdir                    : .

Institutional config options
  config_profile_name       : Test profile
  config_profile_description: Minimal test dataset to check pipeline function

Core Nextflow options
  runName                   : sad_gutenberg
  containerEngine           : singularity
  launchDir                 : /vscmnt/leuven_icts/_data_leuven/336/vsc33625/nf-core-pipeline-test/nf-core-my-worflow
  workDir                   : /dodrio/scratch/projects/2024_300/bpavie/nextflow_workdir
  projectDir                : /vscmnt/leuven_icts/_data_leuven/336/vsc33625/nf-core-pipeline-test/nf-core-my-worflow
  userName                  : vsc33625
  profile                   : test,singularity
  configFiles               : 

!! Only displaying parameters that differ from the pipeline defaults !!
------------------------------------------------------
WARN: The following invalid input values have been detected:

* --clahe_cliplimit: 0.01
* --clahe_pixel_size: 0.138
* --clahe_pyramid_tile: 48


executor >  local (1)
[ec/7d65fc] NFCORE_MYWORFLOW:MYWORFLOW:MOLKARTGARAGE_CLAHE (sample0) [100%] 1 of 1 ✔
-[nf-core/my-worflow] Pipeline completed successfully-
```

Results are in the --outdir params value, e.g. in `my_output_dir`. In this example, a subfolder is created by the module clahe, so the image is located in `output_dir/molkartgarage/sample0.tiff`

This is define in `conf/modules.config`
```bash
        path: { "${params.outdir}/${task.process.tokenize(':')[-1].tokenize('_')[0].toLowerCase()}" },
```

## Links
- [Miguel for peipleine creation](https://shy-cold-a09.notion.site/How-to-NF-Core-Pipelines-151c473124348078a0edeed3a7db0a03)

- [Miguel doc for module creation](https://shy-cold-a09.notion.site/How-to-NF-Core-Pipelines-151c473124348078a0edeed3a7db0a03)
