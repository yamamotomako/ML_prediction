#! /usr/bin/bash

outdir=$1

mkdir -p ${outdir}/img


Rscript --vanilla ./make_basic_plot.R ${outdir}

Rscript --vanilla ./make_pvalue_plot.R ${outdir}
sed -e "s/ /\t/g" ${outdir}/result_all_pvalue_tmp.txt > ${outdir}/result_all_pvalue.txt
rm -r ${outdir}/result_all_pvalue_tmp.txt



