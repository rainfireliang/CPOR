library(systemfit)  
library(forecast)
library(tseries)
library(ggplot2)
weibo<-readRDS("weibo.rds")
eventshort<-readRDS("eventshort.rds")

names(weibo)
##  [1] "date"    "corru_v" "infra_v" "tax_v"   "sowel_v" 
##  [6] "corru_p" "infra_p" "tax_p"   "sowel_p" "corru_m" 
##  [11] "infra_m" "tax_m"   "sowel_m" "event"

ggplot(weibo)+
  geom_rect(aes(xmin=start, xmax=end, fill=dum), #使用蓝色高亮出焦点事件发生的时间段
            ymin=-Inf,ymax=Inf,alpha=0.2,
            data=eventshort)+
  geom_line(aes(date,corru_v), size=0.45)+  #使用折线画出认证用户讨论量
  xlab("Date") + ylab("Number of Posts on Government Administration \nand Political Corruption by Verified Users")+
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=14,face="bold"))
ggplot(weibo)+
  geom_rect(aes(xmin=start, xmax=end, fill=dum), 
            ymin=-Inf,ymax=Inf,alpha=0.2,
            data=eventshort)+
  geom_line(aes(date,log(corru_v)), size=0.45)+  #呈现讨论量的对数的变化趋势
  xlab("Date") + ylab("Log Number of Posts on Government Administration \nand Political Corruption by Verified Users")+
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=14,face="bold"))

ggplot(weibo)+
  geom_rect(aes(xmin=start, xmax=end, fill=dum),#使用蓝色高亮标记出焦点事件发生的时间段
            ymin=-Inf,ymax=Inf,alpha=0.2,
            data=eventshort)+
  geom_line(aes(date,corru_p), size=0.45)+ #使用折线画出普通用户讨论量
  xlab("Date") + ylab("Number of Posts on Government Administration \nand Political Corruption by Unverified Users")+
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=14,face="bold"))
ggplot(weibo)+
  geom_rect(aes(xmin=start, xmax=end, fill=dum), 
            ymin=-Inf,ymax=Inf,alpha=0.2,
            data=eventshort)+
  geom_line(aes(date,log(corru_p)), size=0.45)+ #呈现讨论量的对数的变化趋势  xlab("Date") + ylab("Log Number of Posts on Government Administration \nand Political Corruption by Unverified Users")+
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=14,face="bold"))

other_v<-rowSums(weibo[,c('infra_v','tax_v','sowel_v')])
other_p<-rowSums(weibo[,c('infra_p','tax_p','sowel_p')])
other_m<-rowSums(weibo[,c('infra_m','tax_m','sowel_m')])

p_ov<-weibo[,'corru_p']*other_v
m_ov<-weibo[,'corru_m']*other_v
v_op<-weibo[,'corru_v']*other_p
v_om<-weibo[,'corru_v']*other_m
p_om<-weibo[,'corru_p']*other_m
m_op<-weibo[,'corru_m']*other_p
int<-cbind.data.frame(p_ov,m_ov,v_op,v_om,p_om,m_op)



inds <- seq(as.Date("2013-10-01"), as.Date("2014-10-31"), by = "day")
intts <- ts(int,   
            start = c(2013, as.numeric(format(inds[1], "%j"))),
            frequency = 365)
intts_lag1<-stats::lag(intts,-1)
lagfuldf<-as.data.frame(cbind(intts,intts_lag1)[1:396,])
names(lagfuldf)[7:12]<-c("p_ov.l1","m_ov.l1","v_op.l1","v_om.l1",
                         "p_om.l1","m_op.l1")

polv<-ts(weibo[,'corru_v'],
         start = c(2013, as.numeric(format(inds[1], "%j"))),
         frequency = 7) #在此考虑数据的周季节性，将频率设置为7
polp<-ts(weibo[,'corru_p'],
         start = c(2013, as.numeric(format(inds[1], "%j"))),
         frequency = 7) #在此考虑数据的周季节性，将频率设置为7

kpss.test(log(polv))
kpss.test(log(polp))


res_v<-auto.arima(diff(log(polv)),max.p=14,max.q = 14,seasonal=TRUE,stepwise = FALSE,approximation = FALSE)
res_p<-auto.arima(diff(log(polp)),max.p=14,max.q = 14,seasonal=TRUE,stepwise = FALSE,approximation = FALSE)
checkresiduals(res_v)
checkresiduals(res_p)



main1<-res_v$residuals~
  log(lagfuldf$p_ov.l1)[1:395]+log(lagfuldf$m_ov.l1)[1:395]+
  log(lagfuldf$v_op.l1)[1:395]+log(lagfuldf$v_om.l1)[1:395]+
  weibo[1:395,'event']
main2<-res_p$residuals~
  log(lagfuldf$v_op.l1)[1:395]+log(lagfuldf$m_op.l1)[1:395]+
  log(lagfuldf$p_ov.l1)[1:395]+log(lagfuldf$p_om.l1)[1:395]+
  weibo[1:395,'event']
system<-list(v=main1,p=main2)
fitsur<-systemfit(system,method="SUR")
summary(fitsur)
dwtest(main1)
dwtest(main2)
