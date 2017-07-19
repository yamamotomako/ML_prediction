library(dplyr)
library(ggplot2)
library(VGAM)

args <- commandArgs(trailingOnly = T)
outdir <- args[1]

d = read.csv(paste0(outdir, "/result_all.txt"), stringsAsFactors = TRUE, header = TRUE, sep="\t")

d <- dplyr::mutate(d, log_pvalue=-log10(dbetabinom.ab(variant, depth, shape1 = alpha, shape2 = beta)))
d <- dplyr::mutate(d, othersnp=ifelse(d$other_misrate == "", 0, 1))

d$dbsnp <- ifelse(d$dbsnp == "True",1,0)


p <- ggplot(d, aes(x=category, y=log_pvalue)) + geom_boxplot() + theme(axis.text.x = element_text(size=rel(2)), axis.text.y = element_text(size=rel(2)), axis.title.x = element_text(size=rel(2)), axis.title.y = element_text(size=rel(2)))
p + ylim(c(0,20))


print ("pvalue.png")
ggsave(paste0(outdir, "/img/pvalue.png"))


d$log_pvalue <- ifelse(d$other_misrate == "", 0, d$log_pvalue)

write.table(d, paste0(outdir, "/result_all_pvalue_tmp.txt"), row.names=FALSE, quote=FALSE, append=FALSE)




