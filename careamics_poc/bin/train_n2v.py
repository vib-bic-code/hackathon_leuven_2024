#!/usr/bin/env python3

from pathlib import Path
from careamics import CAREamist
from careamics.config import create_n2v_configuration,  save_configuration
import argparse
from careamics.config.transformations import XYFlipModel
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

def create_config_strn2v(exp_name:str, datatype:str,ax:str, patchsize:tuple, batchsize:int, numepochs:int,structn2vaxis:str,structn2vspan:int):
    ''' create the config to train''' 
    config = create_n2v_configuration(
                experiment_name=exp_name,
                data_type=datatype,
                axes=ax,
                patch_size=patchsize,
                batch_size=batchsize,
                num_epochs=numepochs,
                struct_n2v_axis=structn2vaxis,
                struct_n2v_span=structn2vspan,
                augmentations=[])
    config.data_config.transforms.insert(
    0,XYFlipModel(flip_x=True, flip_y=False))
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
    parser.add_argument("--struct_n2v_axis", type=str, help="structure n2v axis")
    parser.add_argument("--struct_n2v_span", type=int,help="structure n2v span" )
    return parser

if __name__=="__main__":
    argparser = create_argparser_path()
    args= argparser.parse_args()
    axis,  batch, epoch, datatype, exp_name, output_path,  train_data, val_data, patch_size = args.axes, args.batch_size, args.num_epochs, args.data_type, args.experiment_name, args.output_path, args.train_data, args.val_data, args.patch_size
    patch=tuple([int(x) for x in patch_size.split(" ")])
    if args.model == "n2v":
        use_n2v2=bool(args.use_n2v2)
        config=create_config(exp_name, datatype,axis, patch, batch, epoch,use_n2v2)
    elif args.model == "structn2v":
        config=create_config_strn2v(exp_name, datatype,axis, patch,batch, epoch,args.struct_n2v_axis,args.struct_n2v_span)
    save_configuration(config, os.path.join(output_path, "config.yaml"))
    train_model(train_data, val_data,config)
