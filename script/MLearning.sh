#! /usr/bin/bash

outdir=$1
omatic_linecount=`cat ${outdir}/somatic.txt | wc -l`

mkdir -p ${outdir}/MLresult

Rscript --vanilla ./MLearning_tree.R ${outdir} ${somatic_linecount}

Rscript --vanilla ./MLearning_logistic.R ${outdir} ${somatic_linecount}

