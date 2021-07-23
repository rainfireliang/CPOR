```python
# mid 	retweet.mid	layer	origi.mid	retweet.time	origi.time
# 3.56E+15	3.56E+15	1	3.56E+15	4/2/2013 4:31:45	4/1/2013 23:08:30
# 3.56E+15	3.56E+15	1	3.56E+15	4/1/2013 23:53:06	4/1/2013 23:08:30
# 3.56E+15	3.56E+15	1	3.56E+15	4/1/2013 23:11:39	4/1/2013 23:08:30
# 3.56E+15	3.56E+15	1	3.56E+15	4/1/2013 23:10:00	4/1/2013 23:08:30
# 3.56E+15	3.56E+15	1	3.56E+15	4/2/2013 0:10:29	4/1/2013 23:08:46
# 3.56E+15	3.56E+15	1	3.56E+15	4/2/2013 0:10:26	4/1/2013 23:08:46
# 3.56E+15	3.57E+15	1	3.56E+15	4/11/2013 1:22:56	4/1/2013 23:09:40
# 3.56E+15	3.57E+15	1	3.56E+15	4/10/2013 2:10:27	4/1/2013 23:09:40

import numpy as np
import pandas as pd
from pandas import DataFrame
origi.mid_list=[]
origi.mid_list=np.unique(list(df['origi.mid']))       
df=pd.DataFrame({"origi.mid":origi.mid_list})
df.to_excel('/Users/zihengzhang/Desktop/origi.mid.xls')
#存成id表

```

```python
for i in range(len(list(ef['origi.mid']))):
    temp_df=df[df['origi.mid']==ef['origi.mid'][i]]
    temp_df.to_csv('/Users/zihengzhang/Desktop/network_graph/graph{}.csv'.format(i))
#经过筛选并重新存储，我们得到4169个csv文件。也就是4169个网络图。

import networkx as nx
G=nx.Graph()#添加一个空表
nx.draw_networkx(G)

G=nx.Graph()
df=pd.read_csv('/Users/***/Desktop/network_graph/graph{}.csv'.format(j))
for i in range(len(df['mid'])):
  if df['layer'][i]<=1:
    G.add_edge(df['mid'][i],df['retweet.mid'][i])
  else: G.add_edges_from([(df['mid'][i],df['retweet.mid'][i]),(df['origi.mid'][i],df['mid'][i])])
          

#       mid            retweet.mid	  layer	 origi.mid
# 3661582535617200	3661700492441480	1	3661582535617200
# 3661582535617200	3661633072903230	1	3661582535617200
# 3661582535617200	3661596804885960	1	3661582535617200
# 3661582535617200	3661593222858840	1	3661582535617200
# 3661582535617200	3661591152081250	1	3661582535617200
# 3661582535617200	3661588844259640	1	3661582535617200
# 3661582535617200	3661587427032610	1	3661582535617200
# 3661582535617200	3661585610298820	1	3661582535617200
# 3661582535617200	3661584674690460	1	3661582535617200
# 3661582535617200	3661582825889150	1	3661582535617200
      
#     mid	   retweet.mid layer origi.mid
#3.66168E+15	3.66194E+15	1	3.66168E+15
#3.66168E+15	3.66173E+15	1	3.66168E+15
#3.66168E+15	3.66168E+15	1	3.66168E+15
#3.66168E+15	3.66168E+15	1	3.66168E+15
#3.66168E+15	3.66168E+15	1	3.66168E+15
#3.66168E+15	3.66168E+15	1	3.66168E+15
#3.66168E+15	3.66168E+15	1	3.66168E+15
#3.66168E+15	3.66168E+15	1	3.66168E+15
#3.66168E+15	3.66168E+15	1	3.66168E+15
#3.66168E+15	3.66168E+15	1	3.66168E+15
#3.66168E+15	3.66168E+15	1	3.66168E+15
#3.66168E+15	3.66168E+15	1	3.66168E+15
#3.66168E+15	3.66168E+15	1	3.66168E+15

      
short_path=nx.average_shortest_path_length(G)      
short_path=nx.average_shortest_path_length(G)
print(short_path)
vt.append(short_path)


vt=[]
number=[]
for j in range(4169):
    G=nx.Graph()
    df=pd.read_csv('/Users/zihengzhang/Desktop/network_graph/graph{}.csv'.format(j))
    for i in range(len(df['mid'])):
        if df['layer'][i]<=1:
            G.add_edge(df['mid'][i],df['retweet.mid'][i])
        else:
            G.add_edges_from([(df['mid'][i],df['retweet.mid'][i]),(df['origi.mid'][i],df['mid'][i])])
    a=G.number_of_nodes()-1
    number.append(a)
df=pd.DataFrame({"retweet":number})
df.to_csv('/Users/zihengzhang/Desktop/spreadth.csv')       
    short_path=nx.average_shortest_path_length(G)
    print(short_path)
    vt.append(short_path)
   
df=pd.DataFrame({"origi.mid":ef['origi.mid'],"vt":vt})
df.to_excel('/Users/zihengzhang/Desktop/vtall1.xls')



data=list(df['vt'])
mean=np.mean(data)#算均值
std=np.std(data,ddof=1)#标准差
print(mean,std)
plt.hist(data,20,histtype='bar',facecolor='yellowgreen',alpha=0.75,density=True,stacked=True)  #生成直方图括号中代表着不同的属性和参数
#bins=20代表统计的区间分布，density为bool类型，频数或频率分布。Alpha为透明度。
x = np.linspace(mean - 3 * std, mean + 3 * std, 50)#linsapce用于生成start和stop之间50个等差间隔的元素
y_sig = np.exp(-(x - mean) ** 2 / (2 * std ** 2)) / (math.sqrt(2 * math.pi) * std)
#exp函数代表e的幂次方,sqrt函数用于开方。Math.pi代表着π。


print(x)
print("=" * 20)
print(y_sig)
plt.plot(x, y_sig, "r-", linewidth=2)#画出正态分布曲线
plt.grid(True)
plt.show()

#转发量频率分布图
number=[]
for j in range(4169):
    G=nx.Graph()
df=pd.read_csv('/Users/zihengzhang/Desktop/network_graph/graph{}.csv'.format(j))
    for i in range(len(df['mid'])):
        if df['layer'][i]<=1:
            G.add_edge(df['mid'][i],df['retweet.mid'][i])
        else:
            G.add_edges_from([(df['mid'][i],df['retweet.mid'][i]),(df['origi.mid'][i],df['mid'][i])])
    a=G.number_of_nodes()-1#节点减去原发信息节点
    number.append(a)
df=pd.DataFrame({"retweet":number})
df.to_csv('/Users/zihengzhang/Desktop/spreadth.csv')   


data=list(df['retweet'])
plt.hist(data,20,histtype='bar',facecolor='yellowgreen',alpha=0.75,density=True,stacked=True)
#绘制转发量的频率直方分布图


```

```python
spreadth=[]
depth=[]
df=pd.read_csv('/Users/zihengzhang/Desktop/spreadth.csv')
for i in range(4169):    ef=pd.read_csv('/Users/zihengzhang/Desktop/network_graph/graph{}.csv'.format(i))
    a=max(ef['layer']) #提取传播层数
    depth.append(a)

gf=pd.DataFrame({"layer":depth})
gf.to_csv('/Users/zihengzhang/Desktop/depth.csv') 
#计算原发信息被转发的最短时间和平均时间（传播速度和平均速度）
speed=[]
mean_speed=[]
lack=[]
duration=[]
for j in range(4169):  ef=pd.read_csv('/Users/zihengzhang/Desktop/network_graph/graph{}.csv'.format(j))
    time1=[]
    try: 
        for i in range(len(ef['origi.time'])):
            startTime= datetime.datetime.strptime(ef['origi.time'][i],"%m/%d/%Y %H:%M:%S")
            endTime= datetime.datetime.strptime(ef['retweet.time'][i],"%m/%d/%Y %H:%M:%S")
            # 转化时间为标准格式进行运算
            t=(endTime- startTime).total_seconds()#转发差值总秒数
            time1.append(t)
        c=min(time1)#传播速度取第一次转发的时间差
        a=max(time1)
        b=mean(time1)#平均速度取整个列表中的平均时间
        mean_speed.append(b)
        speed.append(c)
        duration.append(a)
    except:
        lack.append(j)
ef=pd.DataFrame({"drop":lack})#把缺失的数据进行存储
ef.to_csv('/Users/zihengzhang/Desktop/lack.csv')
df=pd.DataFrame({"mean":mean_speed,"speed":speed,"duration":duration})
df.to_csv('/Users/zihengzhang/Desktop/indicators.csv')

#删除缺少时间的行
cf=pd.read_csv('/Users/zihengzhang/Desktop/lack.csv') 
a=list(cf['drop'])

#计算列与列间的相关系数
df=pd.read_excel('/Users/zihengzhang/Desktop/vtall1.xls')
rf=pd.read_csv('/Users/zihengzhang/Desktop/indicators.csv')
ef=pd.read_csv('/Users/zihengzhang/Desktop/depth.csv')
gf=pd.read_csv('/Users/zihengzhang/Desktop/spreadth.csv')
bf=df.drop(a,axis=0)
af=ef.drop(a,axis=0)
hf=gf.drop(a,axis=0)
d=list(af['layer'])
b=list(hf['retweet'])
c=list(bf['vt'])
data=pd.DataFrame({'depth':d,'spreadth':b,'vt':c,'mean':rf['mean'],"speed":rf['speed']})
data.to_csv('/Users/zihengzhang/Desktop/data.csv')
data.corr()#计算相关系数矩阵

```

```python
from sklearn.linear_model import LinearRegression
#从sklearn包中调用LinearRegression模型。
import pandas as pd
model = LinearRegression()#线性回归模型
X=data[['origi_feature','content_feature','retweet_feature']]#多元线性回归
Y=data[['vt']]
model.fit(X,Y)#拟合线性回归
b=model.coef_#计算回归系数

from statsmodels.formula.api import ols
#引入statsmodels库，包含假设检验、回归分析、时间序列分析等功能。
lm=ols('vt~ origi_feature + content_feature + retweet_feature',data=data).fit()
print(lm.summary()) #使用summary函数能够展示出整个回归分析的结果

```

