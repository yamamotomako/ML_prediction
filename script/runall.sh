#! /bin/bash

samplepath=$1
outdir=$2


write_usage(){
    echo ""
    echo "bash ./runall.sh 'path of sample and path list(after mutation call, result.filt.txt)' 'path of output directory'"
    echo ""
}



if [ $# -ne 2 ]; then
    echo ""
    write_usage
    exit
fi

if [ ! -e ${samplepath} ]; then
    echo "samplepath file does not exist."
    write_usage
    exit
fi



#ディレクトリ作成、ファイルコピーetc
bash ./prepare.sh ${samplepath} ${outdir} || echo "failed in prepare.sh"


#mutation結果をカテゴライズ
bash ./categorize.sh ${outdir} || echo "failed in make_category.sh"




#snp database indexを作成（今回はtumorから）
bash ./make_snp_db.sh ${outdir}/sample_T_list.csv ${outdir} || echo "failed in make_snp_db.sh"



#コホート中で同一変異の座標染色位置をカウント
bash ./make_cohort_count.sh ${outdir}





#周辺SNP, コホート情報、alpha-betaをmutation-resultに付与
bash ./calc_othersnp_cohort_beta.sh ${outdir}



#結果をgenomon resultにmerge
bash ./merge.sh ${outdir}


#特徴量を結果ファイルから抽出
bash ./choose_feature_column.sh ${outdir}


#結果ファイルの整理
bash ./finalize.sh ${outdir}



#プロットの描画
bash ./make_plot.sh ${outdir}



#機械学習
bash ./MLearning.sh ${outdir}






