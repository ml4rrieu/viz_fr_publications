import requests, json, csv
'''
reuse fr doi identified in barometre français science ouverte
https://ministeresuprecherche.github.io/bso

and enrich them w crossref, hal and unpaywall data
M. Larrieu
CC BY
2020 10
'''


def reqHal(doi) : 
	url = "https://api.archives-ouvertes.fr/search/?q=doiId_s:"+doi+"&fl=submitType_s,license_s"
	found = False
	while not found : 
		req = requests.get(url)
		try : 
			req = req.json()
			found = True
		except : 
			pass

	if req.get('error') :
		doipb.append(doi + ', hal error')
		print('\thal error')
		return {
		'coverage' : 'missing',
		'licence' : None
		}

	if req['response']['numFound'] == 0 :
		return {
		'coverage' : 'missing',
		'licence' : None
		}

	else : 
		#we only use the first occurence of result
		return {
		'coverage' : req['response']['docs'][0].get('submitType_s'), 
		'licence' : req['response']['docs'][0].get('license_s')
		}


def reqCrossref(doi):
	headers = {'User-Agent':'frPublication0.1 ; mailto:maxence@larri.eu'}
	req = requests.get(f"https://api.crossref.org/works/{doi}", headers = headers  )
	
	if req.status_code != 200 : 
		doipb.append(doi + ', not in crossref')
		print('\tnot in crossref')
		
		return{
		'coverage':'missing',
		'doctype' : None, 
		'language' : None,
		'cited_by': None,
		'p_issn' : None,
		'e_issn': None,
		'publisher': None
		}

	else : 
		res = req.json()
		p_issn = e_issn = None
		issn_list = res['message'].get('issn-type')
		if issn_list : 
			for item in issn_list : 
				if item['type'] == 'print' : p_issn = item['value']
				elif item['type'] == 'electronic' : e_issn = item['value']

		return{
		'coverage':'in',
		'doctype' : res['message'].get('type'), 
		'language' : res['message'].get('language'),
		'cited_by': res['message'].get('is-referenced-by-count'),
		'p_issn' : p_issn,
		'e_issn': e_issn,
		'publisher': res['message'].get('publisher')
		}
		


## __________00 initialize	
filename = '2018_FR_Doi_OAtype_process.csv'
doi2scan = 80000

## load dois already scanned
doiScanned = []
with open(filename, 'r', encoding='utf-8') as fh : 
	tempreader = csv.DictReader(fh)
	[doiScanned.append(row['doi']) for row in tempreader]
print('doi scanned =', len(doiScanned), '\n')

#load suspicious issns
fhjson = open('suspiciousIssns.json')
suspiciousIssns = json.load(fhjson)

# create writer to append rows
fhresult = open(filename, 'a', newline='', encoding='utf-8')
writer = csv.writer(fhresult)

#txt file to export doi with problem
doipb_txt = open('doipbs.txt', 'a', encoding='utf-8')
doipb = []


with open("open-access-monitor-france.csv", 'r', newline='', encoding='utf-8') as fh:
	reader = csv.DictReader(fh, delimiter=";")
	next(reader,None)

	newDoiScanned = 0
	for row in reader:
		
		if newDoiScanned > doi2scan : break # nb of doi to be scan
		if row['year'] == '2018' and not row['doi'] in doiScanned :
			doi = row['doi']
			#print(f'\n{doi}')

			
			# __0__ retrieve crossref data 
			crossref = reqCrossref(doi)
			row_pre = ([doi, crossref['coverage'], crossref['doctype'], crossref['language'], 
			crossref['cited_by'], crossref['p_issn'], crossref['e_issn'], crossref['publisher'] ])


			# __1__ deduce if journal is suspicious		
			if crossref['p_issn'] in suspiciousIssns['print'] or crossref['e_issn'] in suspiciousIssns['electronic']: 
				row_pre.append(1)		
			else : 
				row_pre.append(0)
				
					
			# __2__ retrieve hal data 
			hal = reqHal(doi)
			row_pre.extend([ hal['coverage'], hal['licence'] ])


			# __3__ retrieve unpaywall data
			found = False
			while not found : 
				req = requests.get(f"https://api.unpaywall.org/v2/{doi}?email=m@larri.eu")	
				try : 
					res = req.json()
					found = True
				except : 
					pass

			#if upw message is 'not in upw'
			if res.get("message") and "isn't in Unpaywall" in res.get("message") :	
				doipb.append(doi+ ", not in upw")
				row_pre.append( 'missing' )
				writer.writerow( row_pre)
				print('\tnot in upw')
				newDoiScanned += 1
				continue

			if not res.get('is_oa') :
				row_pre.append( 'closed' )
				writer.writerow( row_pre )
				newDoiScanned += 1
				continue
		
			oaType = False
			licence = []
			repo = publisher = 0		
			j_is_oa = res.get('journal_is_oa')
			for loc in res['oa_locations'] :
				if loc['host_type'] == 'repository' : repo = 1
				if loc['host_type'] == 'publisher' : publisher = 1
				if loc['license'] and loc['license'] not in licence : 
					licence.append(loc['license'] )
			
			if repo == 0 and j_is_oa == 0 and len(licence) == 0 : oaType = 1 #bronz
			if repo == 0 and j_is_oa == 0 and len(licence) > 0 : oaType = 2 # hybrid only
			if repo == 1 and j_is_oa == 0 : oaType = 3 # archiv
			if repo == 1 and j_is_oa == 1 : oaType = 4 # archive
			if repo == 0 and j_is_oa == 1 : oaType = 5 # j only
			
			if not oaType : 
				print('\t pb oaType is none')
				print('licence', licence, 'repo', repo, 'publisher', publisher, 'j_is_oa', j_is_oa)
				break
			
			row_pre.extend(['oa', " ; ".join(licence) , repo, publisher, j_is_oa, res.get('journal_is_in_doaj') ] )	
			writer.writerow(row_pre)
			newDoiScanned += 1	
			if newDoiScanned % 10 == 0 : 
				print(newDoiScanned, "DOI scanned\n\n")	


[doipb_txt.write('\n'+ line) for line in doipb]
fhjson.close()
fhresult.close()
