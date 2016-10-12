
# coding: utf-8

# # Importing the data

# In[1]:

import numpy as np
import pandas as pd
import bambi, os, glob


# In[ ]:

dataDir = os.path.abspath(os.path.join(os.getcwd(), '..', 'data/usable/extracted'))
print dataDir
allSubjFilePaths = glob.glob(dataDir + os.sep + 'FC_cfs*clean.csv')
print os.path.basename(allSubjFilePaths[0])
subjNum = len(allSubjFilePaths)
print 'number of subjects: ' + str(subjNum)
df = pd.DataFrame()
for curSubjFileNum in range(subjNum):
    print 'current subject file number = ' + str(curSubjFileNum)
    ds = pd.read_csv(allSubjFilePaths[curSubjFileNum])
    ds.columns = ['subjId', 'domEyeR', 'threshStHi', 'threshStLo', 'thresh', 'trialN',
                  'sentId', 'sentPx', 'congr', 'fam', 'locTop', 'cued', 'crct', 'broken', 'st']
    df = df.append(ds)
print df.shape
df.head(5)


# # Running the Bayesian mixed model

# In[ ]:

#get_ipython().magic(u'matplotlib inline')
model = bambi.Model(df)
modelFitted = model.fit('st ~ congr * fam * cued', samples=2000,
                        random=['1|subjId','1|sentId'], njobs=2)
modelFitted.plot(burn_in=50)

