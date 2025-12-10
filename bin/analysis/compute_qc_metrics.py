#!/usr/bin/env python3
import json
import logging
import HTSeq
from argparse import ArgumentParser
from pathlib import Path
from typing import List, Optional, Tuple
from collections import Counter
from os import fspath

import numpy as np
import anndata
import manhole
import pandas as pd
import scanpy as sc

from common import Assay


def write_scanpy_qc(adata: anndata.AnnData):
    qc_by_cell, qc_by_gene = sc.pp.calculate_qc_metrics(adata)

    qc_path = Path("qc_results.hdf5").absolute()
    print("Saving QC results to", qc_path)
    with pd.HDFStore(qc_path) as store:
        store["qc_by_cell"] = qc_by_cell
        store["qc_by_gene"] = qc_by_gene

def main(h5ad_primary: Path):
    expr_primary = anndata.read_h5ad(h5ad_primary)
    expr_primary.var_names_make_unique()

    write_scanpy_qc(expr_primary)


if __name__ == "__main__":
    manhole.install(activate_on="USR1")
    p = ArgumentParser()
    p.add_argument("h5ad_primary", type=Path)
    args = p.parse_args()

    main(args.h5ad_primary)
