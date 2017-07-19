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
tree_train <- rpart(category ~ dbsnp + cosmic + exac + misrate + log_pvalue + othersnp + variant + depth + cohort_count, data=x)
png(paste0(outdir, "/MLresult/tree.png"))
plot.new(); par(xpd=T); plot(tree_train)
text(tree_train, use.n = T, digits=getOption("digits"))
dev.off()


#predict
tree_pred <- predict(tree_train, y, type="class")
table(y$category, tree_pred)


#result table
result <- cbind(y, tree_pred)
mismatch_result <- result %>% filter(result$category != result$tree_pred)
mismatch_result %>% dplyr::select(category, tree_pred, chr, start, dbsnp, cosmic, exac, cohort_count)

print ("making decision tree result...")
write.table(table, paste0(outdir, "/MLresult/tree_table.txt"), row.names=FALSE, quote=FALSE, append=FALSE)
write.table(mismatch_result, paste0(outdir, "/MLresult/tree_mismatch.txt.tmp"), row.names=FALSE, quote=FALSE, append=FALSE)


