#! /usr/bin/bash


outdir=$1

mkdir -p ${outdir}/merge
mkdir -p ${outdir}/merge/A ${outdir}/merge/B ${outdir}/merge/C

python ./merge.py ${outdir}/mutation_result_categorize/A ${outdir}/exac/A ${outdir}/beta_binomial/A ${outdir}/merge/A
python ./merge.py ${outdir}/mutation_result_categorize/B ${outdir}/exac/B ${outdir}/beta_binomial/B ${outdir}/merge/B
#python ./merge.py ${outdir}/mutation_result_categorize/C ${outdir}/exac/C ${outdir}/beta_binomial/C ${outdir}/merge/C







