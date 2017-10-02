<h3>Somatic mutation detection without matched control data</h3>

Identification of somatic mutation in cancer genome is a key step for clinical sequencing.
However there are various difficulties for obtaining matched control because of
legacy samples, ethical problems, and high sequencing cost and so on.
Then machine learning approach will be effective for classifying somatic mutation 
from germline and sequencing errors in the condition of no matched control.
This tools enables you to predict somatic from germline and gives graphs of feature and learning results.

Input data is tab-separated text format after mutation call.
Also the setting sheet is required, in this repository the path of bam files of 20 samples are specified.
Depth, variant alelle frequency, quality control are filtered in and after the mutation call.

<h4>Usage</h4>

Plese execute...<br><br>
git clone https://github.com/yamamotomako/ML_prediction.git<br>
cd ./script<br>
bash ./runall.sh ../sample_list.csv ../result_directory<br>

ONLY one step is required for working.<br>

Then in the result_directory (you choosen), plots(barplot, boxplot) of the basical quantities will be made, and results of the machine learning will be calculated.







