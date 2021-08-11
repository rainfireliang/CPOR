#本文件为简化后的案例代码样例，使用时请根据个人数据特征进行调整

import pandas as pd
from pandas import Series,DataFrame
import nltk
from nltk.corpus import stopwords
from nltk.stem.wordnet import WordNetLemmatizer
import string
import gensim
from gensim import corpora
from gensim import models
from gensim.models import KeyedVectors


def get_data():
    #根据个人的数据存储方式读取数据
    return data_bot,data_human

def get_doc(data_bot,data_human):
    with open('bot.txt','w') as f:
        for text in list(data_bot):
            f.write(text+'\n')
    with open('human.txt','w') as f:
        for text in list(data_human):
            f.write(text+'\n')

class MySentences(object):
    def __init__(self, filename):
        self.filename = filename 
 
    def __iter__(self):
        for line in open(self.filename):
            yield line.split()

data_bot,data_human=get_data()
get_doc(data_bot,data_human)#可根据个人习惯修改语料库构建方式
docs_bot = MySentences('bot.txt')#可根据个人习惯修改语料库构建方式
docs_human = MySentences('human.txt')
model_bot = gensim.models.Word2Vec(docs_bot)#Word2Vec 有需要设置的参数，可根据个人需求决定
model_human = gensim.models.Word2Vec(docs_human)

print(model_human.most_similar(u"china", topn=50))

model_human.wv.save_word2vec_format("model_human.bin", binary=True)
