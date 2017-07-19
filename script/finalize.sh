#! /usr/bin/bash

outdir=$1

somatic_linecount=`cat ${outdir}/somatic.txt | wc -l`
tail -n +2 ${outdir}/germline.txt | shuf -n ${somatic_linecount} > ${outdir}/g.tmp

#tail -n +2 ${outdir}/others.txt | shuf -n ${somatic_linecount} > ${outdir}/o.tmp

cat ${outdir}/somatic.txt ${outdir}/g.tmp  > ${outdir}/result_all.txt

rm -r ${outdir}/g.tmp
#rm -r ${outdir}/o.tmp





