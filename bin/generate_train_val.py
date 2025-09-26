#!/usr/bin/env python3

import numpy as np
from skimage import io
from pathlib import Path
import tifffile
import pandas as pd
import random
import os
import argparse
import glob
from pathlib import Path

def generate_random_crops_from_files(
    file_list,
    n_crops=10,
    crop_size=512,
    max_zero_frac=0.8,
    output_path="xxxx_training.tif",
    rng=None
):
    """
    Generate random crops from a list of 2D image files.
    Ensures at most 1 crop per image, but total = n_crops (if possible).
    
    Parameters
    ----------
    file_list : list of str or Path
        List of file paths to 2D images.
    n_crops : int
        Total number of crops to extract (max 1 per image).
    crop_size : int
        Height/width of square crop.
    max_zero_frac : float
        Maximum allowed fraction of zeros in a crop.
    output_path : str or Path
        File path where the crop stack will be saved (e.g., 'xxxx_training.tif').
    rng : np.random.Generator or None
        Random number generator for reproducibility.
        
    Returns
    -------
    crops_stack : np.ndarray
        Array of shape (num_crops, crop_size, crop_size).
    crop_info : pd.DataFrame
        DataFrame with crop metadata: [crop_id, source_file, y0, x0, height, width].
    """
    if rng is None:
        rng = np.random.default_rng()

    crops = []
    crop_info = []

    # Shuffle file list so we try images in random order
    shuffled_files = random.sample(file_list, len(file_list))

    for filepath in shuffled_files:
        if len(crops) >= n_crops:
            break  # stop once we reached desired number

        img = io.imread(filepath)
        if img.ndim != 2:
            raise ValueError(f"Image {filepath} is not 2D (shape={img.shape})")

        Y, X = img.shape

        # Try multiple attempts to find a valid crop
        for attempt in range(100):
            y0 = rng.integers(0, Y - crop_size + 1)
            x0 = rng.integers(0, X - crop_size + 1)
            crop = img[y0:y0+crop_size, x0:x0+crop_size]

            zero_frac = np.mean(crop == 0)
            if zero_frac <= max_zero_frac:
                crops.append(crop)
                crop_info.append({
                    "crop_id": len(crops)-1,
                    "source_file": Path(filepath).name,
                    "y0": y0,
                    "x0": x0,
                    "height": crop_size,
                    "width": crop_size
                })
                break  # only one crop per image

    if not crops:
        raise RuntimeError("No valid crops were found!")

    # Stack crops
    crops_stack = np.stack(crops, axis=0)

    # Save TIFF
    output_path = Path(output_path)
    tifffile.imwrite(output_path, crops_stack.astype(np.uint16))

    # Save metadata CSV
    csv_path = output_path.with_suffix(".csv")
    df_info = pd.DataFrame(crop_info)
    df_info.to_csv(csv_path, index=False)


    return crops_stack, df_info





def create_argparser_inference():
    parser = argparse.ArgumentParser()

    parser.add_argument("--input_folder", nargs='+',required=True, help="Path to folder with images")
    parser.add_argument("--output_folder", required=True, help="output directory")
    parser.add_argument("--file_extension", required=True, help="File extension (e.g. tif, tiff)")
    
    parser.add_argument("--n_training_crops", required=True, type=int, help="number of crop for training")
    parser.add_argument("--n_validation_crops", required=True, type=int, help="number of crop for validation")

    parser.add_argument("--crop_size", required=True, type=int, help="Crop size in width/height, e.g. 256")
    parser.add_argument("--max_zero_fraction", type=float, required=True, help="max ralative number of pixel with value 0, to avoid to take background with no noise")
    parser.add_argument("--finaldir", help="final directory to save input.csv")
    
    return parser

'''
pip install numpy scikit-image tifffile pandas

python generate_training_validation_stack_patch.py --input_folder L:/GBW-0004_CMEVIB_OMERO/0001_LIMONE/Tatiana/prealignment/ --output_folder C:/Users/u0094799/Documents/PROJECTS/Leuven/HeleneR/crop_dataset_for_denoising/test --file_extension tif --n_training_crops 10 --n_validation_crops 2 --crop_size 256 --max_zero_fraction 0.3
'''

if __name__ == "__main__":
    parser = create_argparser_inference()
    cli_args = parser.parse_args()
    input_folder =  os.path.commonpath(cli_args.input_folder) 
    if not Path(input_folder).is_dir():
        raise FileNotFoundError(f"Image folder not found: {input_folder}")
    
    output_folder = cli_args.output_folder
    if not Path(output_folder).is_dir():
        raise FileNotFoundError(f"output folder not found: {output_folder}")

    file_extension=cli_args.file_extension
    n_training_crops=cli_args.n_training_crops
    n_validation_crops=cli_args.n_validation_crops
    crop_size = cli_args.crop_size
    max_zero_frac=cli_args.max_zero_fraction
    finaldir=cli_args.finaldir

    if not os.path.exists(output_folder):
        os.makedirs(output_folder)
    
    cwd=os.getcwd()
    files = [os.path.join(cwd,"amst",f) for f in os.listdir(input_folder) if f.endswith(file_extension)]
    files.sort()  

    crops, info = generate_random_crops_from_files(
        files,
        n_crops=n_training_crops,
        crop_size=crop_size,
        max_zero_frac=max_zero_frac,
        output_path=os.path.join(output_folder,"train.tif")
    )

    crops, info = generate_random_crops_from_files(
        files,
        n_crops=n_validation_crops,
        crop_size=crop_size,
        max_zero_frac=max_zero_frac,
        output_path=os.path.join(output_folder,"val.tif")
    )
    summary_csv_path = os.path.join(output_folder, "input.csv")
    df_summary = pd.DataFrame([{
        "sample": 0,
        # a changer car hard coder, ce que cela devrait etre os.path.join(finaldir,"prepare","train.tif")
        "image": os.path.join("/dodrio/scratch/projects/2024_300/twoller/results/EM_workflow","prepare","train.tif"),
        "image_val": os.path.join("/dodrio/scratch/projects/2024_300/twoller/results/EM_workflow","prepare","val.tif")
    }])
    df_summary.to_csv(summary_csv_path, index=False)
    
