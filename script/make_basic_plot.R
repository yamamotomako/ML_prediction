library(dplyr)
library(ggplot2)

args <- commandArgs(trailingOnly = T)
outdir <- args[1]

#outdir <- "/Users/yamamoto/work/plot_renew"

print ("building mutation count...")
data_tn <- read.table(paste0(outdir, "/filt_tn_1.txt"), stringsAsFactors = FALSE, header = FALSE, sep="\t")
data_n <- read.table(paste0(outdir, "/filt_n_1.txt"), stringsAsFactors = FALSE, header = FALSE, sep="\t")
data_tn <- data_tn %>% dplyr::mutate(type="TN")
data_n <- data_n %>% dplyr::mutate(type="N")

colnames(data_tn) <- c("sample","mcount", "type")
colnames(data_n) <- c("sample","mcount", "type")

data_all <- rbind(data_tn, data_n)
data_all$sample <- gsub("T_TN", " ", data_all$sample)
data_all$sample <- gsub("N_N", "", data_all$sample)

p <- ggplot(data_all, aes(x=sample, y=mcount, fill=type)) + geom_bar(stat="identity")
p + theme(axis.text.x = element_text(angle = 90, size = rel(1.3)),
          axis.text.y = element_text(size=rel(1.5)),
          axis.title.x = element_text(size = rel(1.5)),
          axis.title.y = element_text(size = rel(1.5)),
          legend.text = element_text(size = rel(1.3)),
          legend.title = element_text(size = rel(1.5))
          ) + 
    scale_fill_discrete(labels=c("germline","somatic"), name="cancer type") +
    scale_y_log10(breaks=c(10,100,1000,10000), labels=c("1","2","3","4")) +
    ylab("log10(mutation count)") +
    xlab("sample name")





ggsave(paste0(outdir, "/img/mutation_count.png"))



#plot of dbsnp, cosmic, exac with ABC
print ("building dbsnp, cosmic, exac...")
data <- read.table(paste0(outdir, "/result_all.txt"), stringsAsFactors = FALSE, header = TRUE, sep="\t")

data$cosmic <- as.numeric(data$cosmic)
data$exac <- as.numeric(data$exac)


X <- data %>% group_by(category, dbsnp) %>% summarize(count = n())
Y <- data %>% group_by(category) %>% summarize(count = n())

X <- dplyr::inner_join(X, Y, by="category")
X <- X %>% mutate(ratio = count.x / count.y * 100)

label <- c("somatic","germline","others")

p <- ggplot(X, aes(x=category, y=ratio, fill=dbsnp)) + geom_bar(stat="identity")
p + scale_x_discrete(limits=label)
print ("dbsnp.png...")
ggsave(paste0(outdir, "/img/dbsnp.png"))

p <- ggplot(data, aes(x=category, y=cosmic, fill=category)) + geom_boxplot()
p + scale_x_discrete(limits=label) + scale_fill_discrete(limits=label)
print ("cosmic.png...")
ggsave(paste0(outdir, "/img/cosmic.png"))

p <- ggplot(data, aes(x=category, y=-log10(exac+1e-6), fill=category)) + geom_boxplot()
p + scale_x_discrete(limits=label) + scale_fill_discrete(limits=label)
print ("exac.png...")
ggsave(paste0(outdir, "/img/exac.png"))


p <- ggplot(data, aes(x = category, y=cohort_count)) + geom_boxplot()
p + scale_x_discrete(limits=label)
print ("cohort_count.png...")
ggsave(paste0(outdir, "/img/cohort_count.png"))


p <- ggplot(data, aes(x = category, y=depth)) + geom_boxplot()
p + scale_x_discrete(limits=label)
print ("depth.png...")
ggsave(paste0(outdir, "/img/depth.png"))


p <- ggplot(data, aes(x = category, y=variant)) + geom_boxplot()
p + scale_x_discrete(limits=label)
print ("variant.png...")
ggsave(paste0(outdir, "/img/variant.png"))


p <- ggplot(data, aes(x = category, y=misrate)) + geom_boxplot()
p + scale_x_discrete(limits=label)
print ("misrate.png...")
ggsave(paste0(outdir, "/img/misrate.png"))





