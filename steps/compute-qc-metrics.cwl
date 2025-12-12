cwlVersion: v1.0
class: CommandLineTool
label: Compute QC metrics
requirements:
  DockerRequirement:
    dockerPull: hubmap/10x-flex-analysis:0.1
baseCommand: /opt/compute_qc_metrics.py

inputs:
  h5ad_primary:
    type: File
    inputBinding:
      position: 1
outputs:
  scanpy_qc_results:
    type: File
    outputBinding:
      glob: qc_results.hdf5
