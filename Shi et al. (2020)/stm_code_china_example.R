#本文件为简化后的案例代码样例，使用时请根据个人数据特征进行调整

#Loading necessary packages
library(stm) #structural topic modeling package

#load the data
data<-read.csv("washed_china_data.csv")

#extract the answer texts
tweet_text<-as.character(data$cleaned_tweet)
identity<-as.character(data$identity)
retweet<-as.numeric(data$retweet)

#load the stopword list
cstop<-readLines("stopwords.txt")

#preprocessing 
tweet_text=gsub("^ ","",tweet_text)
tweet_text=gsub("[^a-zA-Z]"," ",tweet_text)
tweet_text=gsub("\""," ",tweet_text)
tweet_text=gsub("\'","",tweet_text)
tweet_text=gsub("\\/","",tweet_text)
tweet_text=gsub("?","",tweet_text)
processed<-textProcessor(tweet_text, metadata=data,stem = FALSE,language="en",customstopwords = cstop)
out<-prepDocuments(processed$documents,processed$vocab,processed$meta)
save(out, file=paste("out_china.Rdata"))
load(file=paste("out_china.Rdata"))
docs<-out$documents
vocab<-out$vocab
meta<-out$meta


#stm_12<-stm(out$documents,out$vocab,K=12,prevalence=~identity,init.type='Spectral',max.em.its = 200,data=out$meta,seed=2013)
save(stm_8, file=paste(8,"cov_china.Rdata"))
#load model
load(file=paste(8,"cov_china.Rdata"))

labelTopics(stm_8,n=15)


#prevalence topic
dev.new()
plot(prep, covariate='identity', method="difference",cov.value1='Bot', cov.value2='Human', xlab='Human...Bot',xlim=c(-0.1,0.1), moderator="binaryvar", moderator.value=0,labeltype="custom",custom.labels=c('Topic1','Topic2','Topic3','Topic4','Topic5','Topic6','Topic7','Topic8'))
