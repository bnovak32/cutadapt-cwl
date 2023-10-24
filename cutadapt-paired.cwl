cwlVersion: v1.2
class: CommandLineTool

label: Cutadapt (v4.5)
doc: |
  Run cutadapt to trim adapters from paired-end fastq files. Outputs log/stats 
  in both json and text formats. See complete documentation for cutadapt on 
  the cutadapt website: https://cutadapt.readthedocs.io/en/v4.5/
  (Note: All available options have not been included.)

requirements:
  DockerRequirement:
    dockerPull: bnovak32/cutadapt:4.5

baseCommand: cutadapt

arguments:
  - prefix: "-o"
    valueFrom: $(inputs.output_basename)_R1.trimmed.fastq.gz
  - prefix: "-p"
    valueFrom: $(inputs.output_basename)_R2.trimmed.fastq.gz
  - prefix: "--json"
    valueFrom: $(inputs.output_basename).cutadapt_report.json
  
inputs:
  read1:
    label: Read1 FASTQ file
    type: File
    format:
      - edam:format_1930 # FASTQ (no quality score encoding specified)
      - edam:format_1931 # FASTQ-Illumina
      - edam:format_1932 # FASTQ-Sanger
      - edam:format_1933 # FASTQ-Solexa
    inputBinding: 
      position: 200

  read2:
    label: Read2 FASTQ file
    type: File
    format:
      - edam:format_1930 # FASTQ (no quality score encoding specified)
      - edam:format_1931 # FASTQ-Illumina
      - edam:format_1932 # FASTQ-Sanger
      - edam:format_1933 # FASTQ-Solexa
    inputBinding:
      position: 201

  output_basename:
    label: Basename for output files
    type: string
    doc: Output files will be named {output_basename}_R{1|2}.trimmed.fastq.gz

  pair_adapters:
    label: Pair adapters?
    type: boolean?
    doc: Treat adapters as pairs. Either both or neither are removed from each read pair.
    inputBinding: 
      prefix: "--pair-adapters"

  minlen:
    label: Minimum adapter overlap
    type: int
    default: 3
    doc: |
      Required overlap between read and adapter for an adapter to be found. 
      Default: 3
    inputBinding:
      prefix: "-O"

  qual_trim:
    label: Quality trimming threshold 
    type: int?
    doc: |
      Trim low quality bases from 5' and/or 3' ends of each read before adapter 
      removal. applied to both reads if data is paired. 
    inputBinding:
      prefix: "-q"

  nextseq_trim:
    label: Quality trimming for Illumina 2-color instruments
    type: int?
    doc: |
      Illumina 2-color instrument specific quality trimming (each read). Trims 
      dark cycles appearing as high quality G bases from 3' end of reads. Works 
      like standard quality trimming. Quality threshold is applied for A/C/T, 
      but qualities of G bases are ignored.
    inputBinding:
      prefix: "--nextseq-trim="
      separate: False

  adapter3pR1:
    label: 3' Read1 adapter
    type: string
    doc: |
      Sequence of adapter ligated to the 3' end of read1. The adapter and 
      subsequent bases are trimmed. If '$' is appended ('anchoring'), the 
      adapter is only found if it is a suffix of the read.
    inputBinding:
      prefix: "-a"
  
  adapter3pR2:
    label: 3' Read2 adapter
    type: string
    doc: |
      Sequence of adapter ligated to the 3' end of read2. The adapter and 
      subsequent bases are trimmed. If '$' is appended ('anchoring'), the 
      adapter is only found if it is a suffix of the read.
    inputBinding:
      prefix: "-A"

  adapter5pR1:
    label: 5' Read1 adapter
    type: string?
    doc: |
      Sequence of adapter ligated to the 5' end of read1. The adapter and any 
      preceding bases are trimmed. If '^' is prepended ('anchoring'), the adapter 
      is only found if it is a prefix of the read.
    inputBinding:
      prefix: "-g"

  adapter5pR2:
    label: 5' Read2 adapter
    type: string?
    doc: |
      Sequence of adapter ligated to the 5' end of read2. The adapter and any 
      preceding bases are trimmed. If '^' is prepended ('anchoring'), the adapter 
      is only found if it is a prefix of the read.
    inputBinding:
      prefix: "-G"

  revcomp:
    label: Reverse Complement adapters
    type: boolean?
    doc: |
      Check both the read and its reverse complement for adapter matches. If 
      match is on reverse-complemented version, output that one. 
      Default: check sequence as provided only.
    inputBinding: 
      prefix: "--revcomp"

outputs:
  read1_trimmed_fastq:
    type: File
    format: $(inputs.read1.format)
    outputBinding:
      glob: $(inputs.output_basename)_R1.trimmed.fastq.gz
  read2_trimmed_fastq:
    type: File
    format: $(inputs.read2.format)
    outputBinding:
      glob: $(inputs.output_basename)_R2.trimmed.fastq.gz
  json_report:
    type: File
    format: edam:format_3464
    outputBinding: 
      glob: $(inputs.output_basename).cutadapt_report.json
  text_report:
    type: File
    streamable: true
    outputBinding:
      glob: $(inputs.output_basename).cutadapt_report.txt

stdout: $(inputs.output_basename).cutadapt_report.txt

$namespaces:
  edam: http://edamontology.org/
$schemas:
  - https://edamontology.org/EDAM_1.25.owl

