library(rpart)
library(VGAM)
library(dplyr)

#data import
d_somatic = read.csv("/Users/yamamoto/work/result_new/somatic.txt", stringsAsFactors = TRUE, header = TRUE, sep="\t")
d_germline = read.csv("/Users/yamamoto/work/result_new/germline.txt", stringsAsFactors = TRUE, header = TRUE, sep="\t")

#convert dbsnp into boolean
d_somatic$dbsnp <- ifelse(d_somatic$dbsnp == "True",1,0)
d_germline$dbsnp <- ifelse(d_germline$dbsnp == "True",1,0)

#convert category into boolean
#somatic: 0, germline: 1
#d_somatic$category <- 0
#d_germline$category <- 1

#add column other_snp
d_somatic <- dplyr::mutate(d_somatic, othersnp=ifelse(d_somatic$other_misrate == "", 0, 1))
d_germline <- dplyr::mutate(d_germline, othersnp=ifelse(d_germline$other_misrate == "", 0, 1))

#add column log_pvalue
d_somatic <- dplyr::mutate(d_somatic, log_pvalue=-log10(dbetabinom.ab(variant, depth, shape1 = alpha, shape2 = beta)))
d_somatic$log_pvalue <- ifelse(d_somatic$other_misrate == "", 0, d_somatic$log_pvalue)

d_germline <- dplyr::mutate(d_germline, log_pvalue=-log10(dbetabinom.ab(variant, depth, shape1 = alpha, shape2 = beta)))
d_germline$log_pvalue <- ifelse(d_germline$other_misrate == "", 0, d_germline$log_pvalue)

#define random
set.seed(sample.int(1000,1))
tmp_s <- sample(1:nrow(d_somatic), round(nrow(d_somatic)*0.9, digits=0))
tmp_g <- sample(1:nrow(d_germline), round(nrow(d_germline)*0.9, digits=0))

#divide data into train and test
train_s <- d_somatic[tmp_s,]
test_s <- d_somatic[-tmp_s,]
train_g <- d_germline[tmp_g,]
test_g <- d_germline[-tmp_g,]

#filter exac <= 0.01
train_s_exac <- filter(train_s, exac<=0.01)
train_g_exac <- filter(train_g, exac<=0.01)

#make training data
train_data <- rbind(train_s_exac, train_g_exac)

#training
#tree
tree_model <- rpart(category ~ dbsnp + cosmic + misrate + depth + variant + log_pvalue + exac + cohort_count + othersnp, data=train_data)
plot.new(); par(xpd=T); plot(tree_model)
text(tree_model, use.n = T, digits=getOption("digits"))

#logistic
log_model = glm(category ~ dbsnp + cosmic + misrate + depth + variant + log_pvalue + exac + cohort_count + othersnp, data=train_data, family = binomial(link="logit"))
summary(log_model)


#define test data (exac >= 0.01) is germline
#d_result <- rbind(filter(test_s, exac>=0.01), filter(test_g, exac>=0.01))
#d_result <- dplyr::mutate(d_result, predict=1)

#make test data
test_s_other <- filter(test_s, exac<0.01)
test_g_other <- filter(test_g, exac<0.01)

test_all_other <- rbind(test_s_other, test_g_other)

#predict
#tree (type is class)
tree_pred <- predict(tree_model, test_all_other, type="class")
tree_table <- table(test_all_other$category, tree_pred)
tree_table
tree_eva <- round((tree_table[2]+tree_table[3])/(tree_table[1]+tree_table[2]+tree_table[3]+tree_table[4])*100, digit=3)
tree_eva

#logistic (type is response)
log_pred <- round(predict(log_model, test_all_other, type="response"))
log_pred_conv <- ifelse(log_pred=="1", "germline", "somatic")
log_table <- table(test_all_other$category, log_pred_conv)
log_table
log_eva <- round((log_table[1]+log_table[4])/(log_table[1]+log_table[2]+log_table[3]+log_table[4])*100, digit=3)
log_eva

