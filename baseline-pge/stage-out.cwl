#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
$namespaces:
  cwltool: http://commonwl.org/cwltool#
hints:
  "cwltool:Secrets":
    secrets:
      - aws_access_key_id
      - aws_secret_access_key
      - aws_session_token
  DockerRequirement:
    dockerPull: pymonger/aws-cli
requirements:
  InitialWorkDirRequirement:
    listing:
      - entryname: .aws/credentials
        entry: |
          [default]
          output = json
          region = us-gov-west-1
          aws_access_key_id = $(inputs.aws_access_key_id)
          aws_secret_access_key = $(inputs.aws_secret_access_key)
          aws_session_token = $(inputs.aws_session_token)

# the following baseCommand and arguments work on docker but not singularity
#baseCommand: [aws]
#arguments: [
#  "s3",
#  "cp",
#  "--recursive",
#]

# the following baseCommand and arguments work on both docker and singularity
baseCommand: [sh]
arguments:
- -c
- if [ ! -d $HOME/.aws ]; then cp -rp .aws $HOME/; fi &&
  aws s3 cp --recursive $(inputs.dataset_dir.path) $(inputs.base_dataset_url)/$(inputs.dataset_dir.basename)

inputs:
  aws_access_key_id: string
  aws_secret_access_key: string
  aws_session_token: string
  dataset_dir:
    type: Directory
    # uncomment these if using baseCommand: [aws]
    #inputBinding:
    #  position: 1
  base_dataset_url:
    type: string
    # uncomment these if using baseCommand: [aws]
    #inputBinding:
    #  position: 2
outputs:
  stdout_file:
    type: stdout
  stderr_file:
    type: stderr
stdout: stdout_stage-out.txt
stderr: stderr_stage-out.txt
