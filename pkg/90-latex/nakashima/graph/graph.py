import cv2
import numpy as np
from PIL import Image
import glob
import os
import sys
from tqdm import tqdm
import math
import matplotlib.pyplot as plt
import japanize_matplotlib

#RMSE（誤差）を求める関数
def error(real,estimate):
    count = 0
    total = 0

    for i in range(len(real)):
        error = real[i]-estimate[i]
        count += 1

        total = total+(error*error)

    RMSE = total/count
    return math.sqrt(RMSE)

#def time(timedata):
    lol_time=[]
    timedata=3600*7+timedata
    Hours=timedata//3600
    Minute=(timedata//60)%60
    Sec=timedata%3600
    lol_time.extend([Hours,Minute,Sec])
    lol_time=map(str,lol_time)
    result=":".join(lol_time)
    return result



def trans_fun(val):
    trans_value = 243.78*val-23.23
    return trans_value

def plot_data(save_file_name,time_estimate,**kwargs):
    count=0

    #fig, ax = plt.subplots()
    fig=plt.figure(figsize=(8,6))
    ax=fig.add_subplot()
    #plt.rcParams["figure.figsize"] = (100,1)
    
    c1,c2,c3 = "darkblue","gold","crimson" #プロットの色
    l1,l2,l3 = "Proposed method","Preceding method","True value"
    #l1,l2,l3 = "Proposed1","Proposed2","Proposed3"  #凡例
    ax.set_xlabel("時間[hour]",size=20)  # x軸ラベル
    ax.set_ylabel("水位[cm]",size=20)  # y軸ラベル
    #ax.set_xlim(7200, 43200)
    ax.set_xlim(0, 43200)
    ax.set_ylim(0, 400)
    #ax.set_xticks([0,3600,7200,10800,14400,18000,21600,25200,28800,32400,36000,39600,43200],['7:00','8:00','9:00','10:00','11:00','12:00','13:00','14:00','15:00','16:00','17:00','18:00','19:00'],fontsize=13)
    ax.set_xticks([0,7200,14400,21600,28800,36000,43200],['7:00','9:00','11:00','13:00','15:00','17:00','19:00'],fontsize=15)
    ax.set_yticks([0,100,200,300,400],['0','100','200','300','400'],fontsize=15)
    #ax.set_xticks([7200,10800,14400,18000,21600,25200,28800,32400,36000,39600,43200],['9:00','10:00','11:00','12:00','13:00','14:00','15:00','16:00','17:00','18:00','19:00'])
    #plt.grid()
    #ax.set_yticks([0,20,40,60,80,100])
    #ax.set_yticks([0,50,100,150,200,250,300,350,400])
    #軸範囲の設定
    #plt.ylim(0,448)

    #データのプロット
    if 'est1' in kwargs.keys():
        ax.plot(time_estimate, kwargs['est1'], color=c1, label='水位(推定)')    
    if 'est2' in kwargs.keys():
        ax.plot(time_estimate, kwargs['est2'], color=c2, label=l2)
    if 'real' in kwargs.keys():
        ax.plot(time_estimate, kwargs['real'], color=c3,linestyle="dashed", label='水位(目視)')

    #出力結果の保存
    plt.legend(fontsize=15)
    plt.savefig(save_file_name)
    plt.show()
    
PredictedSegmentation_dir = 'Senkou' #「SS」か「Senkou」に変更
#all_file = sorted(glob.glob('../../DeepLab/'+PredictedSegmentation_dir+'/PredictedSegmentation/*.png'))  #適用画像
true_val = np.loadtxt('true_value/20180707.csv') #適応日の真値データ
log = np.zeros((8086,2))
#log = np.zeros((4073,2))
log = np.loadtxt(PredictedSegmentation_dir+'/result.csv',delimiter=',')
#log = np.loadtxt('segmentation_result/result_rate/watanabe_0707/result.csv',delimiter=',')
#print(log[:,0])
#print(len(true_val))


#print(error(true_val,trans_fun(log[:,1])))
#print(error(true_val,log[:,1]))
#plot_data("test/watanabe_0706.png",log[:,0],est1=log[:,1],real=true_val)
plot_data(PredictedSegmentation_dir+'.png',log[:,0],est1=log[:,1],real=true_val)
#plot_data("test/plot_0706_step=100.png",log[:,0],est1=trans_fun(log[:,1]),real=true_val)

