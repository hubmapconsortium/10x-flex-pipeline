#!/usr/bin/env cwl-runner

class: Workflow
cwlVersion: v1.0
label: scRNA-seq pipeline using Salmon and Alevin
requirements:
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}
inputs:
  data_directory:
    label: "Directory containing 10x h5 file"
    type: Directory
  assay:
    label: "scRNA-seq assay"
    type: string
    default: "10x_v3"

outputs:
  count_matrix_h5ad:
    outputSource: convert_h5ad/h5ad_file
    type: File
    label: "Unfiltered count matrix from BWA and umi_tools, converted to H5AD, spliced and unspliced counts"
  scanpy_qc_results:
    outputSource: compute_qc_results/scanpy_qc_results
    type: File
    label: "Quality control metrics from Scanpy"
  dispersion_plot:
    outputSource: scanpy_analysis/dispersion_plot
    type: File
    label: "Gene expression dispersion plot"
  umap_plot:
    outputSource: scanpy_analysis/umap_plot
    type: File
    label: "UMAP dimensionality reduction plot"
  umap_density_plot:
    outputSource: scanpy_analysis/umap_density_plot
    type: File
    label: "UMAP dimensionality reduction plot, colored by cell density"
  spatial_plot:
    outputSource: scanpy_analysis/spatial_plot
    type: File?
    label: "Slide-seq bead plot, colored by Leiden cluster"
  filtered_data_h5ad:
    outputSource: scanpy_analysis/filtered_data_h5ad
    type: File
    label: Full data set of filtered results
    doc: >-
      Full data set of filtered results: expression matrix, coordinates in
      dimensionality-reduced space (PCA and UMAP), cluster assignments via
      the Leiden algorithm, and marker genes for one cluster vs. rest
  marker_gene_plot_t_test:
    outputSource: scanpy_analysis/marker_gene_plot_t_test
    type: File
    label: "Cluster marker genes, t-test"
  marker_gene_plot_logreg:
    outputSource: scanpy_analysis/marker_gene_plot_logreg
    type: File
    label: "Cluster marker genes, logreg method"
steps:
  convert_h5ad:
    in:
      data_directory:
        source: data_directory
    out:
      - h5ad_file
    run: steps/convert-h5ad.cwl
  scanpy_analysis:
    in:
      assay:
        source: assay
      h5ad_file:
        source: convert_h5ad/h5ad_file
    out:
      - filtered_data_h5ad
      - umap_plot
      - marker_gene_plot_t_test
      - marker_gene_plot_logreg
      - dispersion_plot
      - umap_density_plot
      - spatial_plot
    run: salmon-rnaseq/steps/scanpy-analysis.cwl
    label: "Secondary analysis via ScanPy"
  compute_qc_results:
    in:
      h5ad_primary:
        source: convert_h5ad/h5ad_file
    out:
      - scanpy_qc_results
    run: steps/compute-qc-metrics.cwl
    label: "Compute QC metrics"

