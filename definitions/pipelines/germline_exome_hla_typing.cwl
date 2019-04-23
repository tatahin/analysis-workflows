#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: "exome alignment and germline variant detection, with optitype for HLA typing"
requirements:
    - class: SchemaDefRequirement
      types:
          - $import: ../types/labelled_file.yml
    - class: SubworkflowFeatureRequirement
inputs:
    reference: string
    bams:
        type: File[]
    readgroups:
        type: string[]
    mills:
        type: File
        secondaryFiles: [.tbi]
    known_indels:
        type: File
        secondaryFiles: [.tbi]
    dbsnp_vcf:
        type: File
        secondaryFiles: [.tbi]
    bqsr_intervals:
        type: string[]?
    bait_intervals:
        type: File
    target_intervals:
        type: File
    per_base_intervals:
        type: ../types/labelled_file.yml#labelled_file[]
    per_target_intervals:
        type: ../types/labelled_file.yml#labelled_file[]
    summary_intervals:
        type: ../types/labelled_file.yml#labelled_file[]
    omni_vcf:
        type: File
        secondaryFiles: [.tbi]
    picard_metric_accumulation_level:
        type: string
    emit_reference_confidence:
        type: string
    gvcf_gq_bands:
        type: string[]
    intervals:
        type:
            type: array
            items:
                type: array
                items: string
    vep_cache_dir:
        type: string
    synonyms_file:
        type: File?
    annotate_coding_only:
        type: boolean?
    custom_gnomad_vcf:
        type: File?
        secondaryFiles: [.tbi]
    qc_minimum_mapping_quality:
        type: int?
    qc_minimum_base_quality:
        type: int?
    custom_clinvar_vcf:
        type: File?
        secondaryFiles: [.tbi]
    optitype_name:
        type: string?
outputs:
    cram:
        type: File
        outputSource: germline_exome_wf/cram
    mark_duplicates_metrics:
        type: File
        outputSource: germline_exome_wf/mark_duplicates_metrics
    insert_size_metrics:
        type: File
        outputSource: germline_exome_wf/insert_size_metrics
    insert_size_histogram:
        type: File
        outputSource: germline_exome_wf/insert_size_histogram
    alignment_summary_metrics:
        type: File
        outputSource: germline_exome_wf/alignment_summary_metrics
    hs_metrics:
        type: File
        outputSource: germline_exome_wf/hs_metrics
    per_target_coverage_metrics:
        type: File[]
        outputSource: germline_exome_wf/per_target_coverage_metrics
    per_target_hs_metrics:
        type: File[]
        outputSource: germline_exome_wf/per_target_hs_metrics
    per_base_coverage_metrics:
        type: File[]
        outputSource: germline_exome_wf/per_base_coverage_metrics
    per_base_hs_metrics:
        type: File[]
        outputSource: germline_exome_wf/per_base_hs_metrics
    summary_hs_metrics:
        type: File[]
        outputSource: germline_exome_wf/summary_hs_metrics
    flagstats:
        type: File
        outputSource: germline_exome_wf/flagstats
    verify_bam_id_metrics:
        type: File
        outputSource: germline_exome_wf/verify_bam_id_metrics
    verify_bam_id_depth:
        type: File
        outputSource: germline_exome_wf/verify_bam_id_depth
    gvcf:
        type: File[]
        outputSource: germline_exome_wf/gvcf
    final_vcf:
        type: File
        outputSource: germline_exome_wf/final_vcf
        secondaryFiles: [.tbi]
    coding_vcf:
        type: File
        outputSource: germline_exome_wf/coding_vcf
        secondaryFiles: [.tbi]
    limited_vcf:
        type: File
        outputSource: germline_exome_wf/limited_vcf
        secondaryFiles: [.tbi]
    vep_summary:
        type: File
        outputSource: germline_exome_wf/vep_summary
    optitype_tsv:
        type: File
        outputSource: optitype/optitype_tsv
    optitype_plot:
        type: File
        outputSource: optitype/optitype_plot
steps:
    germline_exome_wf:
        run: germline_exome.cwl
        in:
            reference: reference
            bams: bams
            readgroups: readgroups
            mills: mills
            known_indels: known_indels
            dbsnp_vcf: dbsnp_vcf
            bqsr_intervals: bqsr_intervals
            bait_intervals: bait_intervals
            target_intervals: target_intervals
            per_base_intervals: per_base_intervals
            per_target_intervals: per_target_intervals
            summary_intervals: summary_intervals
            omni_vcf: omni_vcf
            picard_metric_accumulation_level: picard_metric_accumulation_level
            emit_reference_confidence: emit_reference_confidence
            gvcf_gq_bands: gvcf_gq_bands
            intervals: intervals
            vep_cache_dir: vep_cache_dir
            synonyms_file: synonyms_file
            annotate_coding_only: annotate_coding_only
            custom_gnomad_vcf: custom_gnomad_vcf
            qc_minimum_mapping_quality: qc_minimum_mapping_quality
            qc_minimum_base_quality: qc_minimum_base_quality
            custom_clinvar_vcf: custom_clinvar_vcf
        out:
            [cram, mark_duplicates_metrics, insert_size_metrics, insert_size_histogram, alignment_summary_metrics, hs_metrics, per_target_coverage_metrics, per_target_hs_metrics, per_base_coverage_metrics, per_base_hs_metrics, summary_hs_metrics, flagstats, verify_bam_id_metrics, verify_bam_id_depth, gvcf, final_vcf, coding_vcf, limited_vcf, vep_summary]
    optitype:
        run: ../tools/optitype_dna.cwl
        in:
            optitype_name: optitype_name
            cram: germline_exome_wf/cram
        out:
            [optitype_tsv, optitype_plot]
