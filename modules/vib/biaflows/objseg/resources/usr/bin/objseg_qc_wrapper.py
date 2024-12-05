#!/usr/bin/env python3
from biaflows.metrics import *
import fire

version = "0.9.3"


def main(prediction_image, ground_truth, o, T):
    # TODO: Implement the main function
    print(prediction_image)


if __name__ == '__main__':
    options = {
        "run": main,
        "version": version,
    }
    fire.Fire(options)