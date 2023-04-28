dps = c("tidyverse","dabestr","UpSetR","RColorBrewer","ggbeeswarm","ggpmisc","xtable","foreach","BBmisc","EnvStats")           
sapply(dps,function(x){if(!require(x,character.only = T)){install.packages(x);library(x,character.only = T)}else{library(x,character.only = T)}})
setwd("C:/Nirmal_Data/Desktop/Downloads/Mitochondrial Assembly")
# install.packages("ggforce")
# library(ggforce)
install.library("plotly")
df <- read.csv(file="run_time.csv", header=T)
colnames(df)[1] <- "Tool"
df$Reads <- factor(df$Reads,levels=c("115K","175K","225K"))
df$Tool <- factor(df$Tool,levels=c("ARC","GetOrganelle","IOGA","MEANGS", "Mitobim", "MitoFlex", "MitoZ", "MToolBox","Novoplasty","Org.Asm"))
my_col=brewer.pal(10,"Set3")

# Computational Time
df %>% ggplot(aes(y=log(Time),x=Tool, color=as.factor(Threads))) +
  geom_quasirandom(size=1.9 ) + theme_bw()  + scale_color_manual(values=my_col[c(1,3,7,10)]) +
  geom_boxplot(notch=F,alpha=0.3,width=0.2,color="black",fill="#c0c0c0",outlier.shape=NA) +
  theme(text = element_text(size=15)) +  
  theme(axis.text.x=element_text(size=rel(0.8), angle=0)) +
  facet_grid(Reads~.) +
  guides(color=guide_legend(title="Threads")) +
  xlab("Assembler") +
  ylab("log(Execution Time (Seconds))")

# Peak CPU Usage

df2 <- read.csv(file="peak_cpu_usage.csv", header = T)
colnames(df2)[1] <- "Tool"
df2$Reads <- factor(df$Reads,levels=c("115K","175K","225K"))
df2$Tool <- factor(df$Tool,levels=c("ARC","GetOrganelle","IOGA","MEANGS", "Mitobim", "MitoFlex", "MitoZ", "MToolBox","Novoplasty","Org.Asm"))


custom_col <- c("#56B4E9", "#009E73", "#0072B2", "#CC79A7")

df2 %>% ggplot(aes(y=Peak.CPU.Usage, x=Tool, color = as.factor(Threads))) +
  geom_quasirandom(size=1.9 ) + theme_bw()  + scale_color_manual(values=my_col[c(1,3,7,10)]) +
  geom_boxplot(notch=F,alpha=0.3,width=0.2,color="black",fill="#c0c0c0",outlier.shape=NA) +
  theme(text = element_text(size=15)) +  
  theme(axis.text.x=element_text(size=rel(0.8), angle=0)) +
  facet_grid(Reads~.) +
  xlab("Assembler") + 
  ylab("Peak CPU Usage") +
  labs(color="Threads")
# Peak Memory Usage
df3 <- read.csv(file="peak_mem_usage.csv", header = T)
#colnames(df3)[1] <- "Tool"
df3$Reads <- factor(df$Reads,levels=c("115K","175K","225K"))
df3$Tool <- factor(df$Tool,levels=c("ARC","GetOrganelle","IOGA","MEANGS", "Mitobim", "MitoFlex", "MitoZ", "MToolBox","Novoplasty","Org.Asm"))
df3 %>%   ggplot(aes(y=Peak.Mem.Usage,color=as.factor(Threads), x=Tool)) + geom_quasirandom(size=1.9 ) + theme_bw()  + scale_color_manual(values=my_col[c(1,3,7,10)]) +
  geom_boxplot(notch=F,alpha=0.3,width=0.2,color="black",fill="#c0c0c0",outlier.shape=NA) +
  theme(text = element_text(size=15)) +  
  theme(axis.text.x=element_text(size=rel(0.8), angle=0)) +
  facet_grid(Reads~. , scales = "free_y") +
  xlab("Assembler") + 
  ylab("Peak Memory Usage (GB)") +
  labs(color="Threads") + ylim(0,20)

# Mitochondrial Assembly Scores

df5 <- read.csv(file="mean_cpu_usage.csv", header = T)
#colnames(df3)[1] <- "Tool"
df5$Reads <- factor(df5$Reads,levels=c("115K","175K","225K"))
df5$Tool <- factor(df5$Tool,levels=c("ARC","GetOrganelle","IOGA","MEANGS", "Mitobim", "MitoFlex", "MitoZ", "MToolBox","Novoplasty","Org.Asm"))
df5 %>%   ggplot(aes(y=Mean.CPU.Usage,color=as.factor(Threads), x=Tool)) + geom_quasirandom(size=1.9 ) + theme_bw()  + scale_color_manual(values=my_col[c(1,3,7,10)]) +
  geom_boxplot(notch=F,alpha=0.3,width=0.2,color="black",fill="#c0c0c0",outlier.shape=NA) +
  theme(text = element_text(size=15)) +  
  theme(axis.text.x=element_text(size=rel(0.8), angle=0)) +
  facet_grid(Reads~. , scales = "free_y") +
  xlab("Assembler") + 
  ylab("Mean CPU Usage") +
  labs(color="Threads")

df4 <- read.csv(file = "simulated_score.csv", header = T)
colnames(df4)[1] <- "Dataset"

out_tibble <- df4 %>% mutate(rep_res = exp(-abs(log(qry_cov/ref_cov)))) %>%
  mutate(score =  (1 - ((abs(1-ref_cov_frac)/4) + (abs(1-qry_cov_frac)/4) + (abs(1-rep_res)/4) + (abs(1-(1/contig_num))/4)))*100) %>% replace(is.na(.), 0)
ds_o = out_tibble %>% distinct(Dataset)  %>% pull
ass_o = out_tibble %>% distinct(Tool)  %>% pull
dummy_o = foreach(i = ds_o,.combine="rbind") %do% {
  foreach(j = ass_o,.combine="rbind") %do% {
    c(i,j,NA)
  } } %>% setColNames(c("Dataset","Tool","score"))

out_tibble = right_join(out_tibble,as_tibble(dummy_o),by = c("Dataset","Tool")) %>%
  mutate(score = score.x)
out_tibble$Tool <- factor(out_tibble$Tool,levels=c("ARC","GetOrganelle","IOGA","MEANGS", "Mitobim", "MitoFlex", "MitoZ", "MToolBox","Novoplasty","Org.Asm"))
simulated_score <- out_tibble[,c(1,2,3,16)]
View(simulated_score)
write.csv(simulated_score,file = "simulated_score.csv",row.names = FALSE)
out_tibble %>% replace(is.na(.), 0) %>%  ggplot(aes(y=score,x=Tool,color=Tool)) +
  geom_quasirandom(size=1.9 ) + theme_bw()  + scale_color_manual(values=my_col) +
  geom_boxplot(notch=F,alpha=0.3,width=0.2,color="black",fill="#c0c0c0",outlier.shape=NA) +
  theme(text = element_text(size=15)) +  
  theme(axis.text.x=element_text(size=rel(0.8), angle=0)) +
  xlab("Assembler") +
  ylab("Score") +
  labs(color="Assembler")
# UL  = out_tibble %>% filter(score>99)  %>% select(Dataset,Tool) %>% split(.$Tool) %>% lapply("[[",1)
# upset(fromList(UL), order.by = "freq",sets.bar.color=my_col[c(4,3,6,7,2,9,5,1,10,8)],
#       point.size=5,matrix.color = my_col[3],
#       shade.alpha = 0.5, text.scale = 1.5,nsets = 10)

# sequencing_depth <- read.csv(file="chrM_depth.csv", header = T)
# library(tidyverse)
# ggplot(data = sequencing_depth) +
#   geom_boxplot(aes(y=Sequencing.Depth)) +
#   scale_x_discrete()
# install.packages("plotly")
df6 <- read.csv(file="peak_disk_usage.csv", header = T)
#colnames(df3)[1] <- "Tool"
df6$Reads <- factor(df6$Reads,levels=c("115K","175K","225K"))
df6$Tool <- factor(df6$Tool,levels=c("ARC","GetOrganelle","IOGA","MEANGS", "Mitobim", "MitoFlex", "MitoZ", "MToolBox","Novoplasty","Org.Asm"))
df6 %>%   ggplot(aes(y=Disk_usage, x=Tool, color = Reads)) + geom_quasirandom(size=1.9 ) + theme_bw()  + scale_color_manual(values=my_col[c(1,3,7,10)]) +
  geom_boxplot(notch=F,alpha=0.3,width=0.2,color="black",fill="#c0c0c0",outlier.shape=NA) +
  theme(text = element_text(size=15)) +  
  theme(axis.text.x=element_text(size=rel(0.8), angle=0)) +
  # facet_grid(Reads~. , scales = "free_y") +
  xlab("Assembler") + 
  ylab("Peak Disk Usage (GB)") +
  labs(color="Number of Reads") +
  scale_y_log10()


simulated_score <- out_tibble[,c("Dataset", "Tool", "Reads", "contig_num", "score")]
fig <- plot_ly(labels = simulated_score$Tool, parents = simulated_score$Reads, values = simulated_score$score, type = "sunburst")
fig
real_data <- read.csv(file = "Real_data.csv", header = T)
out_tibble <- real_data %>% mutate(rep_res = exp(-abs(log(qry_cov/ref_cov)))) %>%
  mutate(score =  (1 - ((abs(1-ref_cov_frac)/4) + (abs(1-qry_cov_frac)/4) + (abs(1-rep_res)/4) + (abs(1-(1/contig_num))/4)))*100) %>% replace(is.na(.), 0)
ds_o = out_tibble %>% distinct(dataset)  %>% pull
ass_o = out_tibble %>% distinct(assembler)  %>% pull
dummy_o = foreach(i = ds_o,.combine="rbind") %do% {
  foreach(j = ass_o,.combine="rbind") %do% {
    c(i,j,NA)
  } } %>% setColNames(c("dataset","assembler","score"))

out_tibble = right_join(out_tibble,as_tibble(dummy_o),by = c("dataset","assembler")) %>%
  mutate(score = score.x)
out_tibble$assembler <- factor(out_tibble$assembler,levels=c("ARC","Getorganelle","IOGA","MEANGS", "Mitobim", "MitoFlex", "MitoZ", "MToolBox","Novoplasty","Org.Asm"))

out_tibble %>% replace(is.na(.), 0) %>%  ggplot(aes(y=score,x=assembler,color=assembler)) +
  geom_quasirandom(size=1.9 ) + theme_bw()  + scale_color_manual(values=my_col) +
  geom_boxplot(notch=F,alpha=0.3,width=0.2,color="black",fill="#c0c0c0",outlier.shape=NA) +
  theme(text = element_text(size=15)) +  
  theme(axis.text.x=element_text(size=rel(0.8), angle=0)) +
  xlab("Assembler") +
  ylab("Score") +
  labs(color="Assembler")
real_score <- out_tibble[,c("dataset", "assembler", "contig_num", "score")]

UL  = out_tibble %>% filter(score>99)  %>% select(dataset,assembler) %>% split(.$assembler) %>% lapply("[[",1)
upset(fromList(UL), order.by = "freq",sets.bar.color=my_col[c(4,3,6,7,2,9,5,1)],
      point.size=5,matrix.color = my_col[3],
      shade.alpha = 0.5, text.scale = 1.5,nsets = 10)

novel_data <- read.csv(file = "Novel_data.csv", header = T)
out_tibble <- novel_data %>% mutate(rep_res = exp(-abs(log(qry_cov/ref_cov)))) %>%
  mutate(score =  (1 - ((abs(1-ref_cov_frac)/4) + (abs(1-qry_cov_frac)/4) + (abs(1-rep_res)/4) + (abs(1-(1/contig_num))/4)))*100) %>% replace(is.na(.), 0)
ds_o = out_tibble %>% distinct(dataset)  %>% pull
ass_o = out_tibble %>% distinct(assembler)  %>% pull
dummy_o = foreach(i = ds_o,.combine="rbind") %do% {
  foreach(j = ass_o,.combine="rbind") %do% {
    c(i,j,NA)
  } } %>% setColNames(c("dataset","assembler","score"))

out_tibble = right_join(out_tibble,as_tibble(dummy_o),by = c("dataset","assembler")) %>%
  mutate(score = score.x)
out_tibble$assembler <- factor(out_tibble$assembler,levels=c("ARC","Getorganelle","IOGA","MEANGS", "Mitobim", "MitoFlex", "MitoZ", "MToolBox","Novoplasty","Org.Asm"))

out_tibble %>% replace(is.na(.), 0) %>%  ggplot(aes(y=score,x=assembler,color=assembler)) +
  geom_quasirandom(size=1.9 ) + theme_bw()  + scale_color_manual(values=my_col) +
  geom_boxplot(notch=F,alpha=0.3,width=0.2,color="black",fill="#c0c0c0",outlier.shape=NA) +
  theme(text = element_text(size=15)) +  
  theme(axis.text.x=element_text(size=rel(0.8), angle=0)) +
  xlab("Assembler") +
  ylab("Score") +
  labs(color="Assembler")
UL  = out_tibble %>% filter(score>99)  %>% select(dataset,assembler) %>% split(.$assembler) %>% lapply("[[",1)
upset(fromList(UL), order.by = "freq",sets.bar.color=my_col[c(4,3,6,7,2,9,5,1,10)],
      point.size=5,matrix.color = my_col[3],
      shade.alpha = 0.5, text.scale = 1.5,nsets = 10)
novel_score <- out_tibble[,c("dataset", "assembler", "contig_num", "score")]
