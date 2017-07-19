#! /bin/bash

samplepath=$1
outdir=$2


rm -f -r ${outdir}
mkdir -p ${outdir}


rm -f ${outdir}/sample_TN_list.csv
rm -f ${outdir}/sample_N_list.csv
rm -f ${outdir}/sample_T_list.csv

samplepathfile=`basename ${samplepath}`

cp ${samplepath} ${outdir}/${samplepathfile}


for line in `cat ${outdir}/${samplepathfile}`; do
    TEXT=${line}
    IFS=','
    set -- $TEXT
    if [ ${1: -2} = "NT" ]; then
        rep=`echo $1 | sed s/NT/T/g`
        echo ${rep},$2 >> ${outdir}/sample_TN_list.csv
    elif [ ${1: -1} = "N" ]; then
        echo $1,$2 >> ${outdir}/sample_N_list.csv
    else
        echo $1,$2 >> ${outdir}/sample_T_list.csv
    fi
done



