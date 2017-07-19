#! /usr/bin/bash

outdir=$1

python ./make_cohort_count.py ${outdir}/sample_TN_list.csv ${outdir}/cohort_count_tumor_normal.txt
python ./make_cohort_count.py ${outdir}/sample_N_list.csv ${outdir}/cohort_count_normal.txt






