library(dplyr)
library(ggplot2)
library(rpart)

args <- commandArgs(trailingOnly = T)
outdir <- args[1]
somatic_num <- args[2]


d <- read.csv(paste0(outdir, "/result_all_pvalue.txt"), stringsAsFactors = TRUE, header = TRUE, sep="\t")


#data split
set.seed(sample.int(1000,1))

s_num <- as.integer(somatic_num) * 2
ten_p <- round(s_num * 0.9)
tmp <- sample(1:s_num, ten_p)


#x:train, y:predict
x <- d[tmp,]
y <- d[-tmp,]


#training
train_model = glm(category ~ dbsnp + cosmic + exac + cohort + misrate, data=x, family = binomial(link="logit"))
summary(train_model)

test_predict <- round(predict(train_model, y, type="response"))
result_tbl <- table(y$category, test_predict)

result <- cbind(y, test_predict)
mismatch_result <- result %>% filter(result$category != result$test_predict)

print ("making logistic regression result...")
write.table(summary, paste0(outdir, "/MLresult/logistic_summary.txt"), row.names=FALSE, quote=FALSE. append=FALSE)
write.table(result_tbl, paste0(outdir, "/MLresult/logistic_table.txt"), row.names=FALSE, quote=FALSE, append=FALSE)
write.table(mismatch_result, paste0(outdir, "/MLresult/logistic_mismatch.txt"), row.names=FALSE, quote=FALSE, append=FALSE)


