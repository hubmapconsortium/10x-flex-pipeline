#!/usr/bin/env python3
import json
import logging
from argparse import ArgumentParser
from pathlib import Path
from typing import List, Optional, Tuple, Iterable
from collections import Counter
from os import fspath, walk

import numpy as np
import anndata
import manhole
import pandas as pd
import scanpy as sc

from common import Assay

pattern = "raw_feature_bc_matrix.h5"

def find_file(directory: Path, pattern: str) -> Path:
    for dirpath_str, dirnames, filenames in walk(directory):
        dirpath = Path(dirpath_str)
        for filename in filenames:
            filepath = dirpath / filename
            if filepath.match(pattern):
                return filepath

def find_h5_file(data_directory: Path):
    return find_file(data_directory, pattern)

def main(data_directory: Path):
    h5_file = find_h5_file(data_directory)
    adata = sc.read_10x_h5(h5_file)
    adata.write('expr.h5ad')

if __name__ == "__main__":
    manhole.install(activate_on="USR1")
    p = ArgumentParser()
    p.add_argument("data_directory", type=Path)
    args = p.parse_args()

    main(args.data_directory)
