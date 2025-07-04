#!/usr/bin/env python

from pathlib import Path
import numpy as np
import tifffile
from careamics import CAREamist
from careamics.config import create_n2v_configuration
import argparse
import os


def create_argparser_path():
    parser= argparse.ArgumentParser()
    parser.add_argument("--model_path",  help="Path to the train_folder")
    parser.add_argument("--test_path",  help="Path to the test folder")
    parser.add_argument("--axes", help="YX,ZYX,SYX,SZYX")
    parser.add_argument("--tile_size")
    parser.add_argument("--tile_overlap")
    return parser



if __name__=="__main__":
    parser = create_argparser_path()
    cli_args = parser.parse_args()
    axes_arg = cli_args.axes
    test_path=cli_args.test_path
    model_pathway = cli_args.model_path
    tilesize = tuple([int(tile) for tile in cli_args.tile_size.split(",")])
    tileoverlap = tuple([int(tile) for tile in cli_args.tile_overlap.split(",")])
    careamics_bmz= CAREamist(model_pathway)
    prediction = careamics_bmz.predict_to_disk(source=test_path, axes =axes_arg, tile_size=tilesize, tile_overlap=tileoverlap)


