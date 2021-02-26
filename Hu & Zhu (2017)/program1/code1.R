# 媒体观点为m = 2
# 导入网络数据adj、pk和maxDeNode。adj为网络的邻接列表，每一行代表一条边的两个端点；
# pk为每个节点的度值；maxDeNode为度值最大的100个节点的编号
load("InitialData.RData")
# 设置媒体强度
media=0.6
# N为网络节点总数
N=10000
# pk第二列为均匀分布的随机数，据此将为每个节点生成初始观点
pk<-cbind(pk,runif(N))
# 初始化每个节点的观点，不同的观点数I为5
# pk第二列中取值在(0.95, 1]的随机数置换为5，表明对应的节点初始观点为5，
# 这意味着初始时观点为5的节点数约为(1-0.95)*10000=500
pk[pk[,2]>0.95 & pk[,2]<=1,2] <- 5
# 初始时观点为4的节点数约为(0.95-0.85)*10000=1000
pk[pk[,2]>0.85 & pk[,2]<=0.95,2] <- 4
# 初始时观点为3的节点数约为(0.85-0.7)*10000=1500
pk[pk[,2]>0.7 & pk[,2]<=0.85,2] <- 3
# 初始时观点为2的节点数约为(0.7-0.45)*10000=2500
pk[pk[,2]>0.45 & pk[,2]<=0.7,2] <- 2
# 初始时观点为1的节点数约为0.45*10000=4500
pk[pk[,2]<=0.45,2] <- 1
# 度值最大的100个节点持观点1
pk[maxDeNode,2] <- 1
# 分配固执节点
# 找到持有观点2的个体
NodeWithOpi2 <- which(pk[,2] == 2)
# 从持观点2的节点中随机选择2000个，将其设为固执者
Decided2 <- sample(NodeWithOpi2, 2000,replace = FALSE)
# 找到持有观点1的节点
NodeWithOpi1 <- which(pk[,2] == 1)
# 排除掉度值最大的100个节点
NodeWithOpi1Aval <- setdiff(NodeWithOpi1,maxDeNode)
# 从持观点1的节点中随机选择2900个，将其设为固执者
Decided1 <- sample(NodeWithOpi1Aval, 2900,replace = FALSE)
# 度值最大的100个节点也是持观点1的固执者，最终持观点1的固执者数量为3000
Decided1 <- union(maxDeNode,Decided1)
# 得到所有固执者的集合
Decided=union(Decided1,Decided2)

# 根据式(16)得到稳态时观点为1的节点的加权比例
q1InfinityP=(sum(pk[Decided1,1])/sum(pk[,1]))/(media+(1-media)*(sum((sum(pk[Decided1,1])/sum(pk[,1]))+(sum(pk[Decided2,1])/sum(pk[,1])))))
# 根据式(24)得到稳态时观点为2的节点的加权比例
q2InfinityP=((sum(pk[Decided2,1])/sum(pk[,1]))+media*(1-sum((sum(pk[Decided1,1])/sum(pk[,1]))+(sum(pk[Decided2,1])/sum(pk[,1])))))/(media+(1-media)*sum((sum(pk[Decided1,1])/sum(pk[,1]))+(sum(pk[Decided2,1])/sum(pk[,1]))))

# 根据式(17)得到稳态时观点为1的节点的比例
q1Infinity=(1-0.5)*(1-media)*q1InfinityP+0.3
# 根据式(25)得到稳态时观点为2的节点的比例
q2Infinity=(1-0.5)*(media+(1-media)*q2InfinityP)+0.2


opinion=pk[,2]

# 初始化结果数据
qi_old=matrix(0, nrow = 20, ncol = 5)
qi_weighted_old=matrix(0, nrow = 20, ncol = 5)
qi=matrix(0, nrow = 20, ncol = 5)
qi_weighted=matrix(0, nrow = 20, ncol = 5)

Newqi1=matrix(0, nrow = 100, ncol = 20)
Newqi2=matrix(0, nrow = 100, ncol = 20)
Newqi3=matrix(0, nrow = 100, ncol = 20)
Newqi4=matrix(0, nrow = 100, ncol = 20)
Newqi5=matrix(0, nrow = 100, ncol = 20)
  
Newqi_weighted1=matrix(0, nrow = 100, ncol = 20)
Newqi_weighted2=matrix(0, nrow = 100, ncol = 20)
Newqi_weighted3=matrix(0, nrow = 100, ncol = 20)
Newqi_weighted4=matrix(0, nrow = 100, ncol = 20)
Newqi_weighted5=matrix(0, nrow = 100, ncol = 20)

# 从相同的初始条件开始，运行100次数值模拟
for (main_cycle in 1:100)
  { 
  pk[,2]=opinion
  
  # 计算初始时持有不同观点的节点的比例 
  qi[1,1]=length(which(pk[,2] == 1))/10000
  qi[1,2]=length(which(pk[,2] == 2))/10000
  qi[1,3]=length(which(pk[,2] == 3))/10000
  qi[1,4]=length(which(pk[,2] == 4))/10000
  qi[1,5]=1-qi[1,1]-qi[1,2]-qi[1,3]-qi[1,4]
  
  tempt6=sum(pk[,1])
  # 计算初始时持有不同观点的节点的加权比例
  qi_weighted[1,1]=sum(pk[pk[,2]==1,1])/tempt6
  qi_weighted[1,2]=sum(pk[pk[,2]==2,1])/tempt6
  qi_weighted[1,3]=sum(pk[pk[,2]==3,1])/tempt6
  qi_weighted[1,4]=sum(pk[pk[,2]==4,1])/tempt6
  qi_weighted[1,5]=1-qi_weighted[1,1]-qi_weighted[1,2]-qi_weighted[1,3]-qi_weighted[1,4]
  
  
  for (i in 2:20)
  {
    # 循环次数，及j的取值范围，意味着平均而言每个普通节点更新一次状态
    for (j in 1:round(N/(1-length(Decided)/N)))
    {
      # 从网络中随机选择一个节点n1
      n1=sample(N,1)
      # 判断该节点是否为固执节点，如果不是，则更新状态
      if (!(n1 %in% Decided))
      {
        medianetwork=runif(1)
        # 以概率0.6选择媒体观点2作为自己的新观点
        if (medianetwork<media)
          pk[n1,2]=2     
        else
        {
          # 以概率1-0.6=0.4随机选择一个邻居节点，并将新观点设为与该节点一致
          temp2=union(adj[adj[,1]==n1,2],adj[adj[,2]==n1,1]) # 找到n1的邻居节点
          pk[n1,2]=pk[sample(temp2,1),2] # 从邻居节点中随机选择一个，并将n1的新观点设为与该节点一致
        }
      }
    }
    
    qi[i,1]=length(which(pk[,2] == 1))/10000
    qi[i,2]=length(which(pk[,2] == 2))/10000
    qi[i,3]=length(which(pk[,2] == 3))/10000
    qi[i,4]=length(which(pk[,2] == 4))/10000
    qi[i,5]=1-qi[i,1]-qi[i,2]-qi[i,3]-qi[i,4]
    
    qi_weighted[i,1]=sum(pk[pk[,2]==1,1])/tempt6
    qi_weighted[i,2]=sum(pk[pk[,2]==2,1])/tempt6
    qi_weighted[i,3]=sum(pk[pk[,2]==3,1])/tempt6
    qi_weighted[i,4]=sum(pk[pk[,2]==4,1])/tempt6
    qi_weighted[i,5]=1-qi_weighted[i,1]-qi_weighted[i,2]-qi_weighted[i,3]-qi_weighted[i,4]
    
    # 显示运行进度
    cat("main_cycle=",main_cycle,sep = "")
    cat("i=",i,sep = "")
  }
  # qi_old和qi_weighted_old分别为随时间i的增加各观点的比例和加权比例100次运行结果之和，
  # 将它们除以100就可以得到100次运行结果的平均值
  qi_old=qi_old+qi
  qi_weighted_old=qi_weighted_old+qi_weighted
  
  # Newqi1到Newqi5分别保存了所有100次运行的结果中观点1到5的比例，Newqi_weighted1到Newqi_weighted5
  # 分别保存了所有100次运行的结果中观点1到5的加权比例，据此不仅可以得到100次运行结果的均值，
  # 还可以得到标准差
  
  Newqi1[main_cycle,]=qi[,1]
  Newqi2[main_cycle,]=qi[,2]
  Newqi3[main_cycle,]=qi[,3]
  Newqi4[main_cycle,]=qi[,4]
  Newqi5[main_cycle,]=qi[,5]
  
  Newqi_weighted1[main_cycle,]=qi_weighted[,1]
  Newqi_weighted2[main_cycle,]=qi_weighted[,2]
  Newqi_weighted3[main_cycle,]=qi_weighted[,3]
  Newqi_weighted4[main_cycle,]=qi_weighted[,4]
  Newqi_weighted5[main_cycle,]=qi_weighted[,5]
}


# 可视化运行结果
# 数据准备。将输出数据转化为方便可视化的数据
data <- data.frame(T=1:20,meanqi1=rep(0,20),meanqi2=rep(0,20),meanqi3=rep(0,20),meanqi4=rep(0,20),meanqi5=rep(0,20),sdqi1=rep(0,20),sdqi2=rep(0,20),sdqi3=rep(0,20),sdqi4=rep(0,20),sdqi5=rep(0,20),meanqi_weighted1=rep(0,20),meanqi_weighted2=rep(0,20),meanqi_weighted3=rep(0,20),meanqi_weighted4=rep(0,20),meanqi_weighted5=rep(0,20),sdqi_weighted1=rep(0,20),sdqi_weighted2=rep(0,20),sdqi_weighted3=rep(0,20),sdqi_weighted4=rep(0,20),sdqi_weighted5=rep(0,20))


for (i in 1:20)
{
  data[i,2]=mean(Newqi1[,i])
  data[i,3]=mean(Newqi2[,i])
  data[i,4]=mean(Newqi3[,i])
  data[i,5]=mean(Newqi4[,i])
  data[i,6]=mean(Newqi5[,i])
  
  data[i,7]=sd(Newqi1[,i])
  data[i,8]=sd(Newqi2[,i])
  data[i,9]=sd(Newqi3[,i])
  data[i,10]=sd(Newqi4[,i])
  data[i,11]=sd(Newqi5[,i])
  
  data[i,12]=mean(Newqi_weighted1[,i])
  data[i,13]=mean(Newqi_weighted2[,i])
  data[i,14]=mean(Newqi_weighted3[,i])
  data[i,15]=mean(Newqi_weighted4[,i])
  data[i,16]=mean(Newqi_weighted5[,i])
  
  data[i,17]=sd(Newqi_weighted1[,i])
  data[i,18]=sd(Newqi_weighted2[,i])
  data[i,19]=sd(Newqi_weighted3[,i])
  data[i,20]=sd(Newqi_weighted4[,i])
  data[i,21]=sd(Newqi_weighted5[,i])
}

Newdata <- data.frame(Variable=rep("<q1>",20),T=1:20,Opinion=data[,2],sd=data[,7])

Newdata<-rbind(Newdata,data.frame(Variable=rep("<q2>",20),T=1:20,Opinion=data[,3],sd=data[,8]),data.frame(Variable=rep("<q3>",20),T=1:20,Opinion=data[,4],sd=data[,9]),data.frame(Variable=rep("<q4>",20),T=1:20,Opinion=data[,5],sd=data[,10]),data.frame(Variable=rep("<q5>",20),T=1:20,Opinion=data[,6],sd=data[,11]),data.frame(Variable=rep("<q1w>",20),T=1:20,Opinion=data[,12],sd=data[,17]),data.frame(Variable=rep("<q2w>",20),T=1:20,Opinion=data[,13],sd=data[,18]),data.frame(Variable=rep("<q3w>",20),T=1:20,Opinion=data[,14],sd=data[,19]),data.frame(Variable=rep("<q4w>",20),T=1:20,Opinion=data[,15],sd=data[,20]),data.frame(Variable=rep("<q5w>",20),T=1:20,Opinion=data[,16],sd=data[,21]))
# 可视化均值和标准差，并与理论预测的稳态值作比较
library(ggplot2)
ggplot(Newdata, aes(x=T, y=Opinion, colour=Variable, group=Variable, shape = Variable)) + geom_point(size=3,)+ geom_line(linetype="dotted") + geom_errorbar(aes(ymin=Opinion-sd, ymax=Opinion+sd), width=.6,size=0.25, colour="black")+scale_shape_manual(values = c(0,15,1,16,2,17,5,18,3,4))+scale_colour_manual(values = c(rgb(0.85,0.16,0.00),rgb(0.04,0.52,0.78),rgb(0.85,0.16,0.00),rgb(0.04,0.52,0.78),rgb(0.85,0.16,0.00),rgb(0.04,0.52,0.78),rgb(0.85,0.16,0.00),rgb(0.04,0.52,0.78),rgb(0.85,0.16,0.00),rgb(0.04,0.52,0.78)))+ labs(x = "T", y = "<qi>, <qiw>")+ labs(colour='',shape = '')+ theme(axis.text = element_text(size = 12))+ theme(axis.title = element_text(size = 12))+ theme(legend.text = element_text(size = 9))+geom_abline(intercept = q1Infinity, slope = 0, size=0.35,linetype="dashed")+geom_abline(intercept = q1InfinityP, slope = 0, size=0.35,linetype="dashed")+geom_abline(intercept = q2Infinity, slope = 0, size=0.35,linetype="dashed")+geom_abline(intercept = q2InfinityP, slope = 0, size=0.35,linetype="dashed")+geom_abline(intercept = 0, slope = 0, size=0.35,linetype="dashed")