library(dplyr)
library(ggplot2)

args <- commandArgs(trailingOnly = T)
outdir <- args[1]

#outdir <- "/Users/yamamoto/work/result_new_2"

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


aaa <- sub("RCC","",data_all$sample)
aaa <- sub(" ","",aaa)
aaa <- as.integer(aaa)

aaa <- unique(aaa)
aaa <- sort(aaa)
axis_name <- NULL

for(a in aaa){
    b <- paste0("RCC", a)
    axis_name <- c(axis_name, b)
}


p <- ggplot(data_all, aes(x=sample, y=mcount, fill=type)) + geom_bar(stat="identity")
p + theme(axis.text.x = element_text(angle = 90, size = rel(2)),
          axis.text.y = element_text(size=rel(3)),
          axis.title.x = element_text(size = rel(2)),
          axis.title.y = element_blank(),
          axis.line = element_line(color="black"),
          panel.background = element_rect(fill = "white"),
          panel.grid.major = element_line(color = "gray", linetype = "dashed"),
          legend.text = element_text(size = rel(1.5)),
          legend.title = element_blank()
          ) + 
    scale_fill_manual(values=c("#9ecae1","#fdae6b"), labels=c("germline","somatic"), name="category") + 
    scale_x_discrete(breaks=axis_name) + 
    #scale_fill_discrete(labels=c("germline","somatic"), name="category") +
    scale_y_log10(breaks=c(1,10,100,1000,10000), labels=c("1","10","100","1,000","10,000")) +
    ylab("counts of mutation") +
    xlab("sample")


ggsave(paste0(outdir, "/img/mutation_count.png"))



print ("building dbsnp, cosmic, exac...")
data <- read.table(paste0(outdir, "/result_all.txt"), stringsAsFactors = FALSE, header = TRUE, sep="\t")

data$cosmic <- as.numeric(data$cosmic)
data$exac <- as.numeric(data$exac)
data$misrate <- data$misrate * 100

X <- data %>% group_by(category, dbsnp) %>% summarize(count = n())
Y <- data %>% group_by(category) %>% summarize(count = n())

X <- dplyr::inner_join(X, Y, by="category")
X <- X %>% mutate(ratio = count.x / count.y * 100)

label <- c("somatic","germline")

p <- ggplot(X, aes(x=category, y=ratio, fill=dbsnp)) + geom_bar(stat="identity", width=0.7)
p + scale_x_discrete(limits=label) + 
    theme(axis.text.x = element_text(size = rel(4)),
              axis.text.y = element_text(size=rel(4)),
              axis.line = element_line(color="black"),
              panel.background = element_rect(fill = "white"),
              panel.grid.major = element_line(color = "gray", linetype = "dashed", size = 1),
              axis.title.x = element_blank(),
              axis.title.y = element_text(size = rel(2)),
              legend.text = element_text(size = rel(3)),
              legend.title = element_text(size = rel(3))
    ) + 
    scale_fill_manual(labels=c("not recorded","recorded"), name="dbSNP", values=c("#9ecae1","#fdae6b")) +
    ylab("ratio (%)") +
    xlab("category")

print ("dbsnp.png...")
ggsave(paste0(outdir, "/img/dbsnp.png"))



p <- ggplot(data, aes(x=category, y=cosmic, fill=category)) + geom_boxplot(fill="#2166ac", outlier.shape = 16, outlier.size = 4, size=rel(1))
p + scale_x_discrete(limits=label) + 
    theme(axis.text.x = element_text(size = rel(4)),
          axis.text.y = element_text(size=rel(4)),
          axis.title.y = element_text(size = rel(2.5)),
          axis.title.x = element_blank(),
          axis.line = element_line(color="black"),
          panel.background = element_rect(fill = "white"),
          panel.grid.major = element_line(color = "gray", linetype = "dashed", size = 1),
          legend.text = element_text(size = rel(3)),
          legend.title = element_text(size = rel(3))
    ) + 
    ylab("Counts of COSMIC") +
    xlab("category")

print ("cosmic.png...")
ggsave(paste0(outdir, "/img/cosmic.png"))


library(scales)

p <- ggplot(data, aes(x=category, y=-log10(exac+1e-6))) + geom_boxplot(fill="#9ecae1", ooutlier.shape = 16, outlier.size = 4, size=rel(1))
p + scale_x_discrete(limits=label) + 
    #scale_y_log10(labels=trans_format("log10",math_format(10^.x))) + 
    scale_fill_discrete(limits=label) +
    theme(axis.text.x = element_text(size = rel(4)),
          axis.text.y = element_text(size=rel(4)),
          axis.title.x = element_blank(),
          axis.line = element_line(color="black"),
          panel.background = element_rect(fill = "white"),
          panel.grid.major = element_line(color = "gray", linetype = "dashed", size = 1),
          axis.title.y = element_text(size = rel(2)),
          legend.text = element_text(size = rel(2)),
          legend.title = element_text(size = rel(2))
    ) + 
    ylab("-log10 ( ratio of ExAC (%) + 10-6)") + 
    xlab("category")



print ("exac.png...")
ggsave(paste0(outdir, "/img/exac.png"))


p <- ggplot(data, aes(x = category, y=cohort_count)) + geom_boxplot(fill="#9ecae1", ooutlier.shape = 16, outlier.size = 4, size=rel(1))
p + scale_x_discrete(limits=label) + 
    #scale_y_log10(labels=trans_format("log10",math_format(10^.x))) + 
    scale_fill_discrete(limits=label) +
    theme(axis.text.x = element_text(size = rel(4)),
          axis.text.y = element_text(size=rel(4)),
          axis.title.x = element_blank(),
          axis.line = element_line(color="black"),
          panel.background = element_rect(fill = "white"),
          panel.grid.major = element_line(color = "gray", linetype = "dashed", size = 1),
          axis.title.y = element_text(size = rel(2)),
          legend.text = element_text(size = rel(2)),
          legend.title = element_text(size = rel(2))
    ) + 
    ylab("counts of same mutation pattern") + 
    xlab("category")
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


p <- ggplot(data, aes(x = category, y=misrate)) + geom_boxplot(fill="#9ecae1", outlier.shape = 16, outlier.size = 4, size=rel(1))
p + scale_x_discrete(limits=label) + 
    #scale_y_log10(labels=trans_format("log10",math_format(10^.x))) + 
    scale_fill_discrete(limits=label) +
    theme(axis.text.x = element_text(size = rel(3)),
          axis.text.y = element_text(size=rel(4)),
          axis.title.x = element_blank(),
          axis.line = element_line(color="black"),
          panel.background = element_rect(fill = "white"),
          panel.grid.major = element_line(color = "gray", linetype = "dashed", size = 1),
          axis.title.y = element_text(size = rel(2)),
          legend.text = element_text(size = rel(2)),
          legend.title = element_text(size = rel(2))
    ) + 
    ylab("Mismatch ratio (%)") + 
    xlab("category")
print ("misrate.png...")
ggsave(paste0(outdir, "/img/misrate.png"))





