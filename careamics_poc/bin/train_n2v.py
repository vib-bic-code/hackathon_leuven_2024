#!/usr/bin/env python3

from pathlib import Path
from careamics import CAREamist
from careamics.config import create_n2v_configuration
import argparse
from careamics.config import save_configuration
import os

def create_config(exp_name:str, datatype:str,ax:str, patchsize:tuple, batchsize:int, numepochs:int,n2v2:bool):
    ''' create the config to train''' 
    config = create_n2v_configuration(
                experiment_name=exp_name,
                data_type=datatype,
                axes=ax,
                patch_size=patchsize,
                batch_size=batchsize,
                num_epochs=numepochs,
                use_n2v2=n2v2)
    return config

def train_model(trainpath:Path, valpath: Path, config):
    ''' function to train a model'''
    careamist = CAREamist(source=config)
    careamist.train(train_source=trainpath,val_source=valpath)

def create_argparser_path():
    ''' function to gather arguments'''
    parser= argparse.ArgumentParser()
    parser.add_argument("--model")
    parser.add_argument("--experiment_name",  type=str,help="name of the experiment")
    parser.add_argument ("--batch_size", type=int)
    parser.add_argument("--patch_size", help ="2D or 3D")
    parser.add_argument("--num_epochs", type=int)
    parser.add_argument ("--axes", type=str)
    parser.add_argument("--data_type", type=str)
    parser.add_argument("--output_path", help="Path to save the output files")
    parser.add_argument("--use_n2v2", type=str, help="True or False")
    parser.add_argument("--train_data", help="train_data")
    parser.add_argument("--val_data",  help="val_data")
    return parser

if __name__=="__main__":
    argparser = create_argparser_path()
    argparser= argparser.parse_args()
    axis,  batch, epoch, datatype, exp_name, output_path, use_n2v2, train_data, val_data, patch_size = argparser.axes, argparser.batch_size, argparser.num_epochs, argparser.data_type, argparser.experiment_name, argparser.output_path, argparser.use_n2v2, argparser.train_data, argparser.val_data, argparser.patch_size
    patch=tuple([int(x) for x in patch_size.split(" ")])
    use_n2v2=bool(use_n2v2)
    config=create_config(exp_name, datatype,axis, patch, batch, epoch,use_n2v2)
    save_configuration(config, os.path.join(output_path, "config.yaml"))
    train_model(train_data, val_data,config)
