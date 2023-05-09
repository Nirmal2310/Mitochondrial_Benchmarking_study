required_tools = c("tidyverse","dabestr","UpSetR","RColorBrewer","ggbeeswarm","ggpmisc","xtable","foreach","BBmisc","EnvStats")           
sapply(required_tools,function(x){if(!require(x,character.only = T)){install.packages(x);library(x,character.only = T)}else{library(x,character.only = T)}})

##Original

res_real_original <- read.delim("Original.tsv", sep = "\t")
mutated_real_original <- res_real_original %>% mutate(rep_res = exp(-abs(log(qry_cov/ref_cov)))) %>%
  mutate(score =  (1 - ((abs(1-ref_cov_frac)/4) + (abs(1-qry_cov_frac)/4) + (abs(1-rep_res)/4) + (abs(1-(1/contig_num))/4)))*100) %>% replace(is.na(.), 0)
ds_real_original_list = mutated_real_original %>% distinct(dataset)  %>% pull
assembler_real_original_list = mutated_real_original %>% distinct(assembler)  %>% pull
template_real_original = foreach(i = ds_real_original,.combine="rbind") %do% {
  foreach(j = assembler_real_Original,.combine="rbind") %do% {
    c(i,j,NA)
  } } %>% setColNames(c("dataset","assembler","score"))
mutated_real_Original = right_join(mutated_real_Original,as_tibble(template_real_Original),by = c("dataset","assembler")) %>%
  mutate(score = score.x)
mutated_real_Original$assembler_f <- factor(mutated_real_Original$assembler, levels=c("ARC","Getorganelle","IOGA","MEANGS", "Mitobim", "MitoFlex", "MitoZ", "MToolBox","Novoplasty","Org.Asm"))
original_score <- mutated_real_Original[,c(1,2,13)]
write.csv(original_score, file = "original_score_only.csv", row.names = FALSE)
my_col_real=c("#1B9E77","#D95F02","#7570B3","#C14C32","#59c7d6","#E6AB02","#666666","#1F78B4","#884DFF","#FF0000")
mutated_real_Original %>% replace(is.na(.), 0) %>%  ggplot(aes(y=score,x=assembler_f,color=assembler_f)) +
  geom_quasirandom(size=1.9 ) + theme_bw()  + scale_color_manual(values=my_col_real) +
  geom_boxplot(notch=F,alpha=0.3,width=0.2,color="black",fill="#c0c0c0",outlier.shape=NA) +
  theme(axis.title.x = element_blank(),text = element_text(size=15), legend.title=element_blank()) 

mutated_real_Original <- mutated_real_Original[,-12]
n_obs = paste0("n=", mutated_real_Original %>% drop_na %>% group_by(assembler) %>%  tally() %>% select(n) %>% unlist)
n_obs

original_perfect <- mutated_real_Original %>% filter(score.x>99) %>% select(dataset,assembler)
write.csv(original_perfect,file = "original_score.csv",row.names = FALSE)

#Upset plot

UL  = mutated_real_Original %>% filter(score.x>99)  %>% select(dataset,assembler) %>% split(.$assembler) %>% lapply("[[",1)
upset(fromList(UL), order.by = "freq",sets.bar.color=my_col_real[c(2,3,4,6,7,8,9,10)],
      point.size=5,matrix.color = my_col_real[3],
      shade.alpha = 0.5, text.scale = 1.5,nsets = 10)


dev.off()


score_summary <- mutated_real_Original %>% drop_na(score.x) %>%
  select(assembler, score.x) %>% group_by(assembler) %>%
  summarize(Median=median(score.x), IQR = iqr((score.x)), N_perfect = length(which(score.x > 99)),
            N_tot = length(score.x))
Original_score <- xtable(score_summary)
print.xtable(Original_score, type="html", file="original_score.html")

#40X

res_real_40X <- read.delim("40X.tsv", sep = "\t")
mutated_real_40X <- res_real_40X %>% mutate(rep_res = exp(-abs(log(qry_cov/ref_cov)))) %>%
  mutate(score =  (1 - ((abs(1-ref_cov_frac)/4) + (abs(1-qry_cov_frac)/4) + (abs(1-rep_res)/4) + (abs(1-(1/contig_num))/4)))*100) %>% replace(is.na(.), 0)
ds_real_40X_list = mutated_real_40X %>% distinct(dataset)  %>% pull
assembler_real_40X_list = mutated_real_40X %>% distinct(assembler)  %>% pull
template_real_40X = foreach(i = ds_real_40X_list,.combine="rbind") %do% {
  foreach(j = assembler_real_40X_list,.combine="rbind") %do% {
    c(i,j,NA)
  } } %>% setColNames(c("dataset","assembler","score"))
mutated_real_40X = right_join(mutated_real_40X,as_tibble(template_real_40X),by = c("dataset","assembler")) %>%
  mutate(score = score.x)
mutated_real_40X$assembler_f <- factor(mutated_real_40X$assembler, levels=c("ARC","Getorganelle","IOGA","MEANGS", "Mitobim", "MitoFlex", "MitoZ", "MToolBox","Novoplasty","Org.Asm"))
my_col_real=c("#1B9E77","#D95F02","#7570B3","#C14C32","#59c7d6","#E6AB02","#666666","#1F78B4","#884DFF","#FF0000")
score_40X <- mutated_real_40X[,c(1,2,13)]
write.csv(score_40X, file = "40X_score_only.csv", row.names = FALSE)
mutated_real_40X %>% replace(is.na(.), 0) %>%  ggplot(aes(y=score,x=assembler_f,color=assembler_f)) +
  geom_quasirandom(size=1.9 ) + theme_bw()  + scale_color_manual(values=my_col_real) +
  geom_boxplot(notch=F,alpha=0.3,width=0.2,color="black",fill="#c0c0c0",outlier.shape=NA) +
  theme(axis.title.x = element_blank(),text = element_text(size=15), legend.title=element_blank()) 

mutated_real_40X <- mutated_real_40X[,-12]
n_obs_40X = paste0("n=", mutated_real_40X %>% drop_na %>% group_by(assembler) %>%  tally() %>% select(n) %>% unlist)
n_obs_40X

#Upset plot

perfect_40X <- mutated_real_40X %>% filter(score.x>99)  %>% select(dataset,assembler)
write.csv(perfect_40X,file = "40X_perfect.csv", row.names = FALSE)
UL  = mutated_real_40X %>% filter(score.x>99)  %>% select(dataset,assembler) %>% split(.$assembler) %>% lapply("[[",1)
upset(fromList(UL), order.by = "freq",sets.bar.color=my_col_real[c(2,3,4,6,7,8,9,10)],
      point.size=5,matrix.color = my_col_real[3],
      shade.alpha = 0.5, text.scale = 1.5,nsets = 10)


dev.off()


score_summary_40X <- mutated_real_40X %>% drop_na(score.x) %>%
  select(assembler, score.x) %>% group_by(assembler) %>%
  summarize(Median=median(score.x), IQR = iqr((score.x)), N_perfect = length(which(score.x > 99)),
            N_tot = length(score.x))
score_40X <- xtable(score_summary_40X)
print.xtable(score_40X, type="html", file="40X_score.html")

#30X

res_real_30X <- read.delim("30X.tsv", sep = "\t")
mutated_real_30X <- res_real_30X %>% mutate(rep_res = exp(-abs(log(qry_cov/ref_cov)))) %>%
  mutate(score =  (1 - ((abs(1-ref_cov_frac)/4) + (abs(1-qry_cov_frac)/4) + (abs(1-rep_res)/4) + (abs(1-(1/contig_num))/4)))*100) %>% replace(is.na(.), 0)
ds_real_30X_list = mutated_real_30X %>% distinct(dataset)  %>% pull
assembler_real_30X_list = mutated_real_30X %>% distinct(assembler)  %>% pull
template_real_30X = foreach(i = ds_real_30X_list,.combine="rbind") %do% {
  foreach(j = assembler_real_30X_list,.combine="rbind") %do% {
    c(i,j,NA)
  } } %>% setColNames(c("dataset","assembler","score"))
mutated_real_30X = right_join(mutated_real_30X,as_tibble(template_real_30X),by = c("dataset","assembler")) %>%
  mutate(score = score.x)
mutated_real_30X$assembler_f <- factor(mutated_real_30X$assembler, levels=c("ARC","Getorganelle","IOGA","MEANGS", "Mitobim", "MitoFlex", "MitoZ", "MToolBox","Novoplasty","Org.Asm"))
my_col_real=c("#1B9E77","#D95F02","#7570B3","#C14C32","#59c7d6","#E6AB02","#666666","#1F78B4","#884DFF","#FF0000")
score_30X <- mutated_real_30X[,c(1,2,13)]
write.csv(score_30X, file = "30X_score_only.csv", row.names = FALSE)
mutated_real_30X %>% replace(is.na(.), 0) %>%  ggplot(aes(y=score,x=assembler_f,color=assembler_f)) +
  geom_quasirandom(size=1.9 ) + theme_bw()  + scale_color_manual(values=my_col_real) +
  geom_boxplot(notch=F,alpha=0.3,width=0.2,color="black",fill="#c0c0c0",outlier.shape=NA) +
  theme(axis.title.x = element_blank(),text = element_text(size=15), legend.title=element_blank()) 

mutated_real_30X <- mutated_real_30X[,-12]
n_obs_30X = paste0("n=", mutated_real_30X %>% drop_na %>% group_by(assembler) %>%  tally() %>% select(n) %>% unlist)
n_obs
perfect_40X <- mutated_real_30X %>% filter(score.x>99)  %>% select(dataset,assembler)
write.csv(perfect_40X,file = "40X_perfect.csv", row.names = FALSE)


#Upset plot

UL  = mutated_real_30X %>% filter(score.x>99)  %>% select(dataset,assembler) %>% split(.$assembler) %>% lapply("[[",1)
upset(fromList(UL), order.by = "freq",sets.bar.color=my_col_real[c(2,3,4,6,7,8,9,10)],
      point.size=5,matrix.color = my_col_real[3],
      shade.alpha = 0.5, text.scale = 1.5,nsets = 10)


dev.off()


score_summary_30X <- mutated_real_30X %>% drop_na(score.x) %>%
  select(assembler, score.x) %>% group_by(assembler) %>%
  summarize(Median=median(score.x), IQR = iqr((score.x)), N_perfect = length(which(score.x > 99)),
            N_tot = length(score.x))
score_30X <- xtable(score_summary_30X)
print.xtable(score_30X, type="html", file="30X_score.html")

#20X

res_real_20X <- read.delim("20X.tsv", sep = "\t")
mutated_real_20X <- res_real_20X %>% mutate(rep_res = exp(-abs(log(qry_cov/ref_cov)))) %>%
  mutate(score =  (1 - ((abs(1-ref_cov_frac)/4) + (abs(1-qry_cov_frac)/4) + (abs(1-rep_res)/4) + (abs(1-(1/contig_num))/4)))*100) %>% replace(is.na(.), 0)
ds_real_20X_list = mutated_real_20X %>% distinct(dataset)  %>% pull
assembler_real_20X_list = mutated_real_20X %>% distinct(assembler)  %>% pull
template_real_20X = foreach(i = ds_real_20X_list,.combine="rbind") %do% {
  foreach(j = assembler_real_20X_list,.combine="rbind") %do% {
    c(i,j,NA)
  } } %>% setColNames(c("dataset","assembler","score"))
mutated_real_20X = right_join(mutated_real_20X,as_tibble(template_real_20X),by = c("dataset","assembler")) %>%
  mutate(score = score.x)
mutated_real_20X$assembler_f <- factor(mutated_real_20X$assembler, levels=c("ARC","Getorganelle","IOGA","MEANGS", "Mitobim", "MitoFlex", "MitoZ", "MToolBox","Novoplasty","Org.Asm"))
my_col_real=c("#1B9E77","#D95F02","#7570B3","#C14C32","#59c7d6","#E6AB02","#666666","#1F78B4","#884DFF","#FF0000")
score_20X <- mutated_real_20X[,c(1,2,13)]
write.csv(score_20X, file = "20X_score_only.csv", row.names = FALSE)
mutated_real_20X %>% replace(is.na(.), 0) %>%  ggplot(aes(y=score,x=assembler_f,color=assembler_f)) +
  geom_quasirandom(size=1.9 ) + theme_bw()  + scale_color_manual(values=my_col_real) +
  geom_boxplot(notch=F,alpha=0.3,width=0.2,color="black",fill="#c0c0c0",outlier.shape=NA) +
  theme(axis.title.x = element_blank(),text = element_text(size=15), legend.title=element_blank()) 

mutated_real_20X <- mutated_real_20X[,-12]
n_obs = paste0("n=", mutated_real_20X %>% drop_na %>% group_by(assembler) %>%  tally() %>% select(n) %>% unlist)
n_obs
perfect_40X <- mutated_real_20X %>% filter(score.x>99)  %>% select(dataset,assembler)
write.csv(perfect_40X,file = "40X_perfect.csv", row.names = FALSE)

#Upset plot

UL  = mutated_real_20X %>% filter(score.x>99)  %>% select(dataset,assembler) %>% split(.$assembler) %>% lapply("[[",1)
upset(fromList(UL), order.by = "freq",sets.bar.color=my_col_real[c(2,3,4,6,7,8,9,10)],
      point.size=5,matrix.color = my_col_real[3],
      shade.alpha = 0.5, text.scale = 1.5,nsets = 10)


dev.off()


score_summary_20X <- mutated_real_20X %>% drop_na(score.x) %>%
  select(assembler, score.x) %>% group_by(assembler) %>%
  summarize(Median=median(score.x), IQR = iqr((score.x)), N_perfect = length(which(score.x > 99)),
            N_tot = length(score.x))
score_20X <- xtable(score_summary_20X)
print.xtable(score_20X, type="html", file="20X_score.html")

#10X

res_real_10X <- read.delim("10X.tsv", sep = "\t")
mutated_real_10X <- res_real_10X %>% mutate(rep_res = exp(-abs(log(qry_cov/ref_cov)))) %>%
  mutate(score =  (1 - ((abs(1-ref_cov_frac)/4) + (abs(1-qry_cov_frac)/4) + (abs(1-rep_res)/4) + (abs(1-(1/contig_num))/4)))*100) %>% replace(is.na(.), 0)
ds_real_10X_list = mutated_real_10X %>% distinct(dataset)  %>% pull
assembler_real_10X_list = mutated_real_10X %>% distinct(assembler)  %>% pull
template_real_10X = foreach(i = ds_real_10X_list,.combine="rbind") %do% {
  foreach(j = assembler_real_10X_list,.combine="rbind") %do% {
    c(i,j,NA)
  } } %>% setColNames(c("dataset","assembler","score"))
mutated_real_10X = right_join(mutated_real_10X,as_tibble(template_real_10X),by = c("dataset","assembler")) %>%
  mutate(score = score.x)
mutated_real_10X$assembler_f <- factor(mutated_real_10X$assembler, levels=c("ARC","Getorganelle","IOGA","MEANGS", "Mitobim", "MitoFlex", "MitoZ", "MToolBox","Novoplasty","Org.Asm"))
my_col_real=c("#1B9E77","#D95F02","#7570B3","#C14C32","#59c7d6","#E6AB02","#666666","#1F78B4","#884DFF","#FF0000")
score_10X <- mutated_real_10X[,c(1,2,13)]
write.csv(score_10X, file = "10X_score_only.csv", row.names = FALSE)
mutated_real_10X %>% replace(is.na(.), 0) %>%  ggplot(aes(y=score,x=assembler_f,color=assembler_f)) +
  geom_quasirandom(size=1.9 ) + theme_bw()  + scale_color_manual(values=my_col_real) +
  geom_boxplot(notch=F,alpha=0.3,width=0.2,color="black",fill="#c0c0c0",outlier.shape=NA) +
  theme(axis.title.x = element_blank(),text = element_text(size=15), legend.title=element_blank()) 

mutated_real_10X <- mutated_real_10X[,-12]
n_obs = paste0("n=", mutated_real_10X %>% drop_na %>% group_by(assembler) %>%  tally() %>% select(n) %>% unlist)
n_obs

perfect_40X <- mutated_real_10X %>% filter(score.x>99)  %>% select(dataset,assembler)
write.csv(perfect_40X,file = "40X_perfect.csv", row.names = FALSE)

#Upset plot

UL  = mutated_real_10X %>% filter(score.x>99)  %>% select(dataset,assembler) %>% split(.$assembler) %>% lapply("[[",1)
upset(fromList(UL), order.by = "freq",sets.bar.color=my_col_real[c(2,3,4,6,7,8,9,10)],
      point.size=5,matrix.color = my_col_real[3],
      shade.alpha = 0.5, text.scale = 1.5,nsets = 10)


dev.off()


score_summary_10X <- mutated_real_10X %>% drop_na(score.x) %>%
  select(assembler, score.x) %>% group_by(assembler) %>%
  summarize(Median=median(score.x), IQR = iqr((score.x)), N_perfect = length(which(score.x > 99)),
            N_tot = length(score.x))
score_10X <- xtable(score_summary_10X)
print.xtable(score_10X, type="html", file="10X_score.html")

# F Score Plot
f_score_matrix <- read.table(file="SNP calling Analysis.csv", sep = ",", header = TRUE)
f_score_matrix %>% ggplot(aes(y=F.score,x=Assembler, color=as.factor(Assembler))) +
  geom_quasirandom(size=1.9 ) + theme_bw()  + scale_color_manual(values=my_col_real[c(2,3,4,6,7,8,9,10)]) +
  geom_boxplot(notch=F,alpha=0.3,width=0.2,color="black",fill="#c0c0c0",outlier.shape=NA) +
  theme(text = element_text(size=15)) +  
  theme(axis.text.x=element_text(size=rel(0.8), angle=0)) +
  facet_grid(as.factor(Depth)~.) +
  guides(color=guide_legend(title="Assembler")) +
  ylab("F1 Score")
