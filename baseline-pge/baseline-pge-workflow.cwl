#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
$namespaces:
  cwltool: http://commonwl.org/cwltool#
hints:
  "cwltool:Secrets":
    secrets:
      - workflow_aws_access_key_id
      - workflow_aws_secret_access_key
      - workflow_aws_session_token
inputs:
  workflow_input_url: string
  workflow_input_file: string
  workflow_product_id: string
  workflow_min_sleep: int
  workflow_max_sleep: int
  workflow_aws_access_key_id: string
  workflow_aws_secret_access_key: string
  workflow_aws_session_token: string
  workflow_base_dataset_url: string

outputs:
  stdout_stage-in:
    type: File
    outputSource: stage-in/stdout_file
  stderr_stage-in:
    type: File
    outputSource: stage-in/stderr_file

steps:
  stage-in:
    run: stage-in.cwl
    in:
      input_url: workflow_input_url
      input_file: workflow_input_file
    out:
    - localized_file:
        type: File
        outputBinding:
          glob: $(inputs.input_file)
    - stdout_file
    - stderr_file
