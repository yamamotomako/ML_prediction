<h3>Somatic mutation detection without matched control data</h3>

<h4>Introduction</h4>
Identification of somatic mutation in cancer genome is a key step for clinical sequencing.<br>
However there are various difficulties for obtaining matched control because of<br>
legacy samples, ethical problems, and high sequencing cost and so on.<br>
Then machine learning approach will be effective for classifying somatic mutation <br>
from germline and sequencing errors in the condition of no matched control.<br>
This tools enables you to predict somatic from germline and gives graphs of feature and learning results.<br>

<h4>Material</h4>
Input data is tab-separated text format after mutation call.<br>
Also the setting sheet is required, the path of bam files of 20 samples are specified as the example.<br>
In and after mutation call by software, depth, variant alelle frequency, base quality, exon and splicing are filtered.<br>
Supervised data are specified using the result of mutation, tumor samples with normal control are set to be somatic, <br>
normal sample are to be germline mutation.<br>
<br>

<h4>Methods</h4>
The features used for machine learning are 9 types.<br>
    -Depth<br>
    -Variant lead<br>
    -Mismatch ratio<br>
    -dbSNP<br>
    -ExAC ratio<br>
    -COSMIX count<br>
    -counts of the same mutation pattern in the cohort<br>
    -Other snp<br>
    -p value of mismatch ratio<br>
Among the feature, the valus calculated from third party database (dbSNP, COSMIC, ExAC) are validated.<br>
Other features are calculated in the process of runnning scripts, the counts of mutation pattern in the cohort, <br>
pvalue of mismatch ratio supposed fitted on binomial distribution, flags of other snp around mutation.<br>
Then the feature quantities are visualized statisticaly for checking valid parameters.<br>
Two machine learning methods are applied, decition tree and logistic regression.<br>
Logistic regression is introduced because of its lineality, decision tree is because of easiness for visualization.<br>
The final outputs are graphs of learning, prediction mismatch ratio.<br>

Scripting languages are unix shell, python, and R.<br>
Main running flow is written in unix shell, generating graph and library of machine learning are in R, <br>
and other processing (text reading etc) are in python.<br>




<h4>Usage</h4>

Please execute...<br><br>
git clone https://github.com/yamamotomako/ML_prediction.git<br>
cd ./script<br>
bash ./runall.sh ../sample_list.csv ../result_directory<br>

ONLY one step is required for generating final results.<br>

Then in the result_directory (you choosen), plots(barplot, boxplot) of the basical quantities will be made, and results of the machine learning will be calculated.







