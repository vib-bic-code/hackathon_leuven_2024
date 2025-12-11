#!/usr/bin/env python3

from pathlib import Path
from careamics import CAREamist
from careamics.config import create_n2n_configuration, save_configuration, create_care_configuration
import argparse
import os

def create_config(model:str,exp_name:str, datatype:str,ax:str, patchsize:tuple, batchsize:int, numepochs:int,loss:str):
    # add type of config
    ''' create the config to train''' 
    if model=="n2n":
        config = create_n2n_configuration(
                experiment_name=exp_name,
                data_type=datatype,
                axes=ax,
                patch_size=patchsize,
                batch_size=batchsize,
                num_epochs=numepochs,
                loss=loss)
    elif model=="care":
        config = create_care_configuration(
                experiment_name=exp_name,
                data_type=datatype,
                axes=ax,
                patch_size=patchsize,
                batch_size=batchsize,
                num_epochs=numepochs, 
                loss=loss)
    else:
        raise NameError
    return config

def train_model(trainpath:Path, valpath: Path, config):
    ''' function to train a model'''
    careamist = CAREamist(source=config)
    careamist.train(train_source=trainpath,train_target=valpath)

def create_argparser_path():
    ''' function to gather arguments'''
    parser= argparse.ArgumentParser()
    parser.add_argument("--model")
    parser.add_argument("--experiment_name",  type=str,help="name of the experiment")
    parser.add_argument ("--batch_size", type=int)
    parser.add_argument("--patch_size", nargs='+', help ="2D or 3D")
    parser.add_argument("--num_epochs", type=int)
    parser.add_argument ("--axes", type=str)
    parser.add_argument("--data_type", type=str)
    parser.add_argument("--output_path", help="Path to save the output files")
    parser.add_argument("--train_data", help="train_data")
    parser.add_argument("--train_target",  help="target_data")
    parser.add_argument("--loss")
    return parser

if __name__=="__main__":
    argparser = create_argparser_path()
    argparser= argparser.parse_args()
    model,axis,  batch, epoch, datatype, exp_name, output_path, train_data, train_target, loss = argparser.model,argparser.axes, argparser.batch_size, argparser.num_epochs, argparser.data_type, argparser.experiment_name, argparser.output_path, argparser.train_data, argparser.train_target, argparser.loss
    patch=argparser.patch_size
    config=create_config(model,exp_name, datatype,axis, patch, batch, epoch,loss)
    save_configuration(config, os.path.join(output_path, "config.yaml"))
    train_model(train_data, train_target,config)
