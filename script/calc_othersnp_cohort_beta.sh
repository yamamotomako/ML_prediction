#! /usr/bin/bash


outdir=$1



mkdir -p ${outdir}/exac ${outdir}/addsnp ${outdir}/ccount ${outdir}/beta_binomial

mkdir -p ${outdir}/exac/A ${outdir}/exac/B ${outdir}/exac/C
mkdir -p ${outdir}/addsnp/A ${outdir}/addsnp/B ${outdir}/addsnp/C
mkdir -p ${outdir}/ccount/A ${outdir}/ccount/B ${outdir}/ccount/C
mkdir -p ${outdir}/beta_binomial/A ${outdir}/beta_binomial/B ${outdir}/beta_binomial/C



python ./calc_cosmic_dbsnp_exac.py "A" ${outdir}/mutation_result_categorize/A ${outdir}/exac/A
python ./calc_cosmic_dbsnp_exac.py "B" ${outdir}/mutation_result_categorize/B ${outdir}/exac/B
#python ./calc_cosmic_dbsnp_exac.py "C" ${outdir}/mutation_result_categorize/C ${outdir}/exac/C




#SNP情報を付与
python ./calc_othersnp.py ${outdir}/mutation_result_categorize/A ${outdir}/filt_bgzip ${outdir}/addsnp/A
python ./calc_othersnp.py ${outdir}/mutation_result_categorize/B ${outdir}/filt_bgzip ${outdir}/addsnp/B
#python ./calc_othersnp.py ${outdir}/mutation_result_categorize/C ${outdir}/filt_bgzip ${outdir}/addsnp/C


#コホート情報を付与
python ./calc_cohort_count.py ${outdir}/addsnp/A ${outdir}/ccount/A ${outdir}/cohort_count_tumor_normal.txt
python ./calc_cohort_count.py ${outdir}/addsnp/B ${outdir}/ccount/B ${outdir}/cohort_count_normal.txt
#python ./calc_cohort_count.py ${outdir}/addsnp/C ${outdir}/ccount/C ${outdir}/cohort_count_normal.txt


#alpha, betaを付与
python ./calc_alpha_beta.py ${outdir}/ccount/A ${outdir}/beta_binomial/A
python ./calc_alpha_beta.py ${outdir}/ccount/B ${outdir}/beta_binomial/B
#python ./calc_alpha_beta.py ${outdir}/ccount/C ${outdir}/beta_binomial/C

