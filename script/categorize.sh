#! /bin/bash

outdir=$1

mkdir -p ${outdir}
mkdir -p ${outdir}/filt_tn_1
mkdir -p ${outdir}/filt_n_1
mkdir -p ${outdir}/filt_n_2_ok
mkdir -p ${outdir}/filt_n_2_ng


#filter by exonic, misrate, indel
#with control
echo "filtering by exon misrate indel TN..."
python ./filter_by_exonic_misrate_indel.py ${outdir}/sample_TN_list.csv ${outdir}/filt_tn_1 ${outdir}/filt_tn_1.txt "TN"

#without control
echo "filtering by exon misrate indel N..."
python ./filter_by_exonic_misrate_indel.py ${outdir}/sample_N_list.csv ${outdir}/filt_n_1 ${outdir}/filt_n_1.txt "N"


#filter by depth, vaf
#without control
echo "filtering secondly by depth N..."
python ./filter_by_depth_vaf.py ${outdir}/filt_n_1 ${outdir}/filt_n_2_ok ${outdir}/filt_n_2_ng "N"



#rename
mkdir -p ${outdir}/mutation_result_categorize


mv -f ${outdir}/filt_tn_1 ${outdir}/mutation_result_categorize/A
mv -f ${outdir}/filt_n_2_ok ${outdir}/mutation_result_categorize/B
mv -f ${outdir}/filt_n_2_ng ${outdir}/mutation_result_categorize/C



