import tensorflow as tf

from tensorflow.keras import layers

print(tf.VERSION)
print(tf.keras.__version__)

from sklearn.svm import SVR
from sklearn.ensemble import RandomForestRegressor
import sklearn
sklearn.__version__

import pandas as pd
import numpy as np
from sklearn.utils import shuffle
from sklearn import preprocessing



curr_config = [4, 2, 1, 1, 48, 1, 64, 0, 0, 0, 0.6, 2, 256, 3, 1, 4, 0.5]

import pickle
from sklearn import preprocessing


file  = open("wc_trained_model.pkl","rb")
model = pickle.load(file)

print(model)


train_dataset = pd.read_csv("preprocessed_wc_1_2_4_8.csv")
test_dataset = pd.read_csv("preprocessed_wc_16.csv")


X = train_dataset.iloc[:,1:-1]
Y = train_dataset.iloc[:,-1]

print(X)

testX = test_dataset.iloc[:,1:-1]
testY = test_dataset.iloc[:,-1]

print(testX)

min_max_scalar = preprocessing.MinMaxScaler()
min_max_scalar.fit(X.values)

model.fit(X,Y)
print("test score = " )
print( model.score(X,Y) )



# print(curr_config )
# print( model.predict([curr_config]).tolist())
# print( model.score(testX,testY) )

values = [[4], [1, 2, 4], [1, 2, 4], [1, 2, 4, 8], [48],
    [1, 0], [64], [1], [0], [0], [0.6],
    [1, 2, 4], [16, 64, 128, 256], [3], [1], [2, 4, 8], [0.3, 0.5]]


par1 = values[0]
par2 = values[1]
par3 = values[2]
par4 = values[3]
par5 = values[4]
par6 = values[5]
par7 = values[6]
par8 = values[7]
par9 = values[8]
par10 = values[9]
par11 = values[10]
par12 = values[11]
par13 = values[12]
par14 = values[13]
par15 = values[14]
par16 = values[15]
par17 = values[16]

minArr = []
minTime  = 100000
count = 0
for q in par1:
	for a in par2:
		for z in par3:
			for w in par4:
				for e in par5:
					for r in par6:
						for t in par7:
							for s in par8:
								for d in par9:
									for f in par10:
										for x in par11:
											for c in par12:
												for v in par13:
													for y in par14:
														for u in par15:
															for i in par16:
																for o in par17:
																	arr = [q,a,z,w,e,r,t,s,d,f,x,c,v,y,u,i,o]
																	#print(arr)
																	time = model.predict([arr]).tolist()
																	#print( time )
																	if minTime > time[0]:
																		minTime = time[0]
																		minArr = arr
print("minumum time = ",minTime)
print("config for minumum time = ",minArr)
