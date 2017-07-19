#! /usr/bin/bash

outdir=$1
somatic_linecount=`cat ${outdir}/somatic.txt | wc -l`


mkdir -p ${outdir}/MLresult

Rscript --vanilla ./MLearning_tree.R ${outdir} ${somatic_linecount}

Rscript --vanilla ./MLearning_logistic.R ${outdir} ${somatic_linecount}


sed -e 's/ /\t/g' ${outdir}/MLresult/tree_mismatch.txt.tmp > ${outdir}/MLresult/tree_mismatch.txt
rm -f ${outdir}/MLresult/tree_mismatch.txt.tmp

sed -e 's/ /\t/g' ${outdir}/MLresult/logistic_mismatch.txt.tmp > ${outdir}/MLresult/logistic_mismatch.txt
rm -f ${outdir}/MLresult/logistic_mismatch.txt.tmp

