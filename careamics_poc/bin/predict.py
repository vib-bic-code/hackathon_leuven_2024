#!/usr/bin/env python3

from careamics import CAREamist
from pathlib import Path
import argparse


def prediction_careamist(testdata_path:Path,model_path:Path, tilesize:tuple, tileoverlap:tuple, ax:str, batchsize:int,writetype:str, datatype:str):
    ''' function to denoised a dataset according to a pretrained model using careamics'''
    data_path = Path(testdata_path)  
    careamics_pretrained= CAREamist(model_path) 
    careamics_pretrained.predict_to_disk(source=data_path, tile_size=tilesize, tile_overlap=tileoverlap, axes=ax, batch_size=batchsize, data_type=datatype, write_type=writetype)

def create_arguments():
    '''function collecting the arguments according to nextflow'''
    parser = argparse.ArgumentParser()
    parser.add_argument("--test_data",required=True, help="Path to folder with images")
    parser.add_argument("--trained_model", required=True, help="Path to pretrained model")
    parser.add_argument("--tile_size", help="tile size")
    parser.add_argument("--tile_overlap", help="tile overlap")
    parser.add_argument("--axes", help=" string to indicate the dimension of the dataset")
    parser.add_argument("--batch_size", help=" int to indicate the batch_size")
    parser.add_argument("--write_type")
    parser.add_argument("--data_type")
    return parser


if __name__=="__main__":
    argparser = create_arguments()
    argparser= argparser.parse_args()
    test_data_path, model_path, tilesize, tileoverlap, ax, batch_size, writetype, datatype = argparser.test_data, argparser.trained_model, argparser.tile_size, argparser.tile_overlap, argparser.axes, argparser.batch_size,argparser.write_type, argparser.data_type
    tuple_tilesize=tuple([int(x) for x in tilesize.split(" ")])
    tuple_tileoverlap=tuple([int(x) for x in tileoverlap.split(" ")])
    print(test_data_path,model_path, tuple_tilesize, tuple_tileoverlap, ax, int(batch_size), datatype, writetype)
    prediction_careamist(test_data_path,model_path, tuple_tilesize, tuple_tileoverlap, ax, int(batch_size), datatype, writetype)