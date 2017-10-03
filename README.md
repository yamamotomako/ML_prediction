<h3>Somatic mutation detection without matched control data</h3>

Identification of somatic mutation in cancer genome is a key step for clinical sequencing.
However there are various difficulties for obtaining matched control because of
legacy samples, ethical problems, and high sequencing cost and so on.
Then machine learning approach will be effective for classifying somatic mutation 
from germline and sequencing errors in the condition of no matched control.
This tools enables you to predict somatic from germline and gives graphs of feature and learning results.

Input data is tab-separated text format after mutation call.
Also the setting sheet is required, the path of bam files of 20 samples are specified as the example.
In and after mutation call by software, depth, variant alelle frequency, base quality, exon and splicing are filtered.
Supervised data are specified using the result of mutation, tumor samples with normal control are set to be somatic, 
normal sample are to be germline mutation.
The features used for machine learning are 9 types.
Among the feature, the valus calculated from third party database (dbSNP, COSMIC, ExAC) are validated.
Other features are calculated in the process of runnning scripts, the counts of mutation pattern in the cohort, 
pvalue of mismatch ratio supposed fitted on binomial distribution, flags of other snp around mutation.
Then the feature quantities are visualized statisticaly for checking valid parameters.
Two machine learning methods are applied, decition tree and logistic regression.
Logistic regression is introduced because of its lineality, decision tree is because of easiness for visualization.
The final outputs are graphs of learning, prediction mismatch ratio.

Scripting languages are unix shell, python, and R.
Main running flow is written in unix shell, generating graph and library of machine learning are in R, 
and other processing (text reading etc) are in python.




<h4>Usage</h4>

Plese execute...<br><br>
git clone https://github.com/yamamotomako/ML_prediction.git<br>
cd ./script<br>
bash ./runall.sh ../sample_list.csv ../result_directory<br>

ONLY one step is required for generating final results.<br>

Then in the result_directory (you choosen), plots(barplot, boxplot) of the basical quantities will be made, and results of the machine learning will be calculated.







