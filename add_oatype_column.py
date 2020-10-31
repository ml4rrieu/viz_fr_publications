import pandas as pd

''' ajout de la colonne oatype '''


df = pd.read_csv("2018_FR_Doi_OAtype_process - Copie.csv")
print('length of df is', len(df.index))

oaType = []
for index, row in df.iterrows(): 

	treated = False
	if row['hal_coverage'] !='file' and row['upw_coverage'] != 'oa' : 
		oaType.append(0)
		treated = True
		continue

	if row['j_is_suspicious'] == 1 : 
		oaType.append(1)
		treated = True
		continue

	#inclure les pdf de HAL qui ne seraient pas couverts upw
	if row['hal_coverage'] == 'file' and row['upw_coverage'] != 'oa' : 
		oaType.append(4)
		treated = True
		continue

	if row['repo'] == 0 and row['j_is_oa'] == 0 and pd.isnull(row['licence']) == True : 
		oaType.append(2) #bronz (and no archive)
		treated = True	
	
	if row['repo'] == 0 and row['j_is_oa'] == 0 and pd.isnull(row['licence']) == False : 
		oaType.append(3) #hybrid (and not archive)
		treated = True	

	if row['repo'] > 0 and row['j_is_oa'] == 0 : 
		oaType.append(4) #archive and j is not oa
		treated = True	

	if row['repo'] > 0 and row['j_is_oa'] == 1 : 
		oaType.append(5) #archive & journal
		treated = True	

	if row['repo'] == 0 and row['j_is_oa'] == 1 : 
		oaType.append(6) #journal only
		treated = True	

	if not treated : print('no oatype for this doi', row['doi'])


print('length oatype', len(oaType))
if len(df.index) != len(oaType) : 
	print('problem df length is not equal to oatype list ')
else : 
	df['oaType'] = oaType
	df.to_csv('2018_FR_Doi_oatype.csv', index = False)
