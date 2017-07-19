#! /usr/bin/bash


outdir=$1


python ./choose_feature_column.py "A" ${outdir}/merge/A ${outdir}/somatic.txt
python ./choose_feature_column.py "B" ${outdir}/merge/B ${outdir}/germline.txt
#python ./choose_feature_column.py "C" ${outdir}/merge/C ${outdir}/others.txt



