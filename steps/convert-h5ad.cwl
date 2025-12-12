cwlVersion: v1.0
class: CommandLineTool
requirements:
  DockerRequirement:
    dockerPull: hubmap/10x-flex-analysis:0.1
  ResourceRequirement:
    ramMin: 28672
baseCommand: /opt/convert_h5ad.py
label: Convert vendor matrix in h5 formta to h5ad

# arguments are hardcoded in quantification.py

inputs:
  data_directory:
    type: Directory
    inputBinding:
      position: 1

outputs:
  h5ad_file:
    type: File?
    outputBinding:
      glob: 'expr.h5ad'
