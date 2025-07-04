#!/usr/bin/env python

from careamics.config import create_n2v_configuration, create_care_configuration, create_n2n_configuration
import argparse
import os
from careamics.config import save_configuration


def config_n2v2(axis, patch, batch, epoch, datatype, exp_name)-> tuple:
    config = create_n2v_configuration(
    experiment_name=exp_name,
    data_type=datatype,
    axes=axis,
    patch_size=patch,
    batch_size=batch,
    num_epochs=epoch,
    use_n2v2=True
)
    return config

def config_n2v(axis, patch, batch, epoch,datatype, exp_name)-> tuple:
    config = create_n2v_configuration(
    experiment_name=exp_name,
    data_type=datatype,
    axes=axis,
    patch_size=patch,
    batch_size=batch,
    num_epochs=epoch
)
    return config

def config_strn2v(axis, patch, batch, epoch,datatype, exp_name)-> tuple:
    config = create_n2v_configuration(
    experiment_name=exp_name,
    data_type=datatype,
    axes=axis,
    patch_size=patch,
    batch_size=batch,
    num_epochs=epoch,
    struct_n2v_axis="horizontal",
    struct_n2v_span=11,
    # disable augmentations because of the noise correlations
    augmentations=[],
)
    return config

def config_n2n(axis, patch, batch, epoch,datatype, exp_name)-> tuple:
    config = create_n2n_configuration(
    experiment_name=exp_name,
    data_type=datatype,
    axes=axis,
    patch_size=patch,
    batch_size=batch,
    num_epochs=epoch
)
    return config

def config_care(axis, patch, batch, epoch,datatype, exp_name)-> tuple:
    config = create_care_configuration(
    experiment_name= exp_name,
    data_type=datatype,
    axes=axis,
    patch_size=patch,
    batch_size=batch,
    num_epochs=epoch
)
    return config

def create_argparser_path():
    parser= argparse.ArgumentParser()
    parser.add_argument("--model",  help="n2v or n2v2")
    parser.add_argument("--exp_name",  help="tif or tiff")
    parser.add_argument ("--batch_size", help="1D")
    parser.add_argument("--patch_size", help ="2D or 3D")
    parser.add_argument("--num_epochs", help="[100-300]")
    parser.add_argument ("--axis_train")
    parser.add_argument("--data_type")
    parser.add_argument("--output_path", help="Path to save the output files")
    return parser

argparser = create_argparser_path()
argparser= argparser.parse_args()
axis,  batch, epoch, datatype, exp_name, output_path = argparser.axis_train, argparser.batch_size, argparser.num_epochs, argparser.data_type, argparser.exp_name, argparser.output_path
patch=tuple([int(patch) for patch in argparser.patch_size.split(",")])
if argparser.model == "n2v":
    config = config_n2v(axis, patch, batch, epoch, datatype, exp_name)
elif argparser.model == "n2v2":     
    config = config_n2v2(axis, patch, batch, epoch, datatype, exp_name)
elif argparser.model == "strn2v":
    config = config_strn2v(axis, patch, batch, epoch, datatype, exp_name)
elif argparser.model == "n2n":   
    config = config_n2n(axis, patch, batch, epoch, datatype, exp_name)          
elif argparser.model == "care":
    config = config_care(axis, patch, batch, epoch, datatype, exp_name) 
else:
    raise ValueError("Model not recognized. Please choose between n2v, n2v2, strn2v, n2n or care.")

save_configuration(config, os.path.join(output_path, "config.yaml"))
