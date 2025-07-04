#!/usr/bin/env python

from careamics import CAREamist
import argparse
from pathlib import Path
from careamics.config import  load_configuration
import tifffile
import os
import numpy as np

def create_argparser_path():
    parser= argparse.ArgumentParser()
    # a ajouter experiment name
    parser.add_argument("--train_path",  help="Path to the training folder")
    parser.add_argument("--val_path",  help="Path to the validation folder")
    parser.add_argument("--test_path",  help="Path to the test folder")
    parser.add_argument("--output_path",  help="Path to the output folder")
    parser.add_argument("--config_path", help="Path to the configuration file")
    return parser



if __name__=="__main__":
    parser = create_argparser_path()
    cli_args = parser.parse_args()
    train_path=Path(cli_args.train_path)
    val_path = Path(cli_args.val_path) 
    test_path = Path(cli_args.test_path) 
    output_folder = Path(cli_args.output_path)
    config_path = Path(cli_args.config_path)
   
    config= load_configuration(config_path)
  
    careamist= CAREamist(source=config)
    careamist.train(
        train_source=train_path,
        val_source=val_path,
    )
    # a changer dans le nom
    # noises = tifffile.imread(train_path)
    # careamist.export_to_bmz(
    #     path_to_archive=os.path.join(output_folder, "training","test_n2v2.zip"),
    #     friendly_model_name="SEM N2V2 denoising with careamics",
    #     input_array=noises[0][np.newaxis, :256, :256].astype(np.float32),
    #     authors=[{"name": "TW and BP", "affiliation": "VIB BIC"}],
    #     general_description="text",
    #     data_description="une description")

