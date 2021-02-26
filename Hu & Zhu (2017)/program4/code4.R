# 导入网络数据pk和maxDeNode。
# pk为每个节点的度值；maxDeNode为度值最大的100个节点的编号
load("InitialData.RData")
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
# 计算持观点1的固执节点的加权比例temp1和持观点2的固执节点的加权比例temp2
temp1 <- sum(pk[Decided1,1])/sum(pk[,1])     
temp2 <- sum(pk[Decided2,1])/sum(pk[,1])
# 设置媒体强度从0到1变化
media <- seq(0, 1, by = 0.01)
# 初始化持有观点1和2的节点比例和加权比例
q1InfinityP <- rep(0, 101)
q2InfinityP <- rep(0, 101)
q3InfinityP <- rep(0, 101)
q1Infinity <- rep(0, 101)
q2Infinity <- rep(0, 101)
q3Infinity <- rep(0, 101)
for (i in 1:101)
{ # 根据式(16)得到稳态时观点为1的节点的加权比例 
  q1InfinityP[i]=temp1/(media[i]+(1-media[i])*(temp1+temp2))
  # 根据式(16)得到稳态时观点为2的节点的加权比例
  q2InfinityP[i]=temp2/(media[i]+(1-media[i])*(temp1+temp2))
  # 根据式(24)得到稳态时观点为3的节点的加权比例
  q3InfinityP[i]=(media[i]*(1-temp1-temp2))/(media[i] + (1-media[i])*(temp1+temp2))
  
  # 根据式(17)得到稳态时观点为1的节点的比例
  q1Infinity[i]=(1-0.5)*(1-media[i])*q1InfinityP[i]+0.3
  # 根据式(17)得到稳态时观点为2的节点的比例
  q2Infinity[i]=(1-0.5)*(1-media[i])*q2InfinityP[i]+0.2
  # 根据式(25)得到稳态时观点为3的节点的比例
  q3Infinity[i]=(1-0.5)*(media[i]+(1-media[i])*q3InfinityP[i])
}

# 可视化运行结果
# 数据准备。将输出数据转化为方便可视化的数据
data<-cbind(media,q1Infinity,q1InfinityP,q2Infinity,q2InfinityP, q3Infinity,q3InfinityP)
data<-as.data.frame(data)
# 可视化结果
library(ggplot2)
shapes=c(q1Infinity=0,q1InfinityP=15,q2Infinity=1,q2InfinityP=16,q3Infinity=2,q3InfinityP=17)
ggplot(data,aes(x=media))+geom_point(aes(y=q1Infinity,shape='q1Infinity'),size=1.5)+geom_point(aes(y=q1InfinityP,shape="q1InfinityP"),size=1.5)+geom_point(aes(y=q2Infinity,shape="q2Infinity"),size=1.5)+geom_point(aes(y=q2InfinityP,shape="q2InfinityP"),size=1.5)+geom_point(aes(y=q3Infinity,shape="q3Infinity"),size=1.5)+geom_point(aes(y=q3InfinityP,shape="q3InfinityP"),size=1.5)+labs(x = "P", y = "qi, qiw")+scale_shape_manual(values = shapes,labels=c("q1","q1w","q2","q2w","q3","q3w"))+labs(shape='')+theme(axis.text = element_text(size = 15))+ theme(axis.title = element_text(size = 15))+theme(legend.text = element_text(size = 12))
