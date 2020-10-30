![2018 FR OA type](img/oa_type_2018.png)

## Type d'accès ouvert des publications françaises de 2018 avec DOI

![legend](img/legend.png)

## Résultats bruts

publications dans archive ouverte & journal non open access : 39662<br />
publications dans archive ouverte & dans un journal open access : 18679<br />
publications hors archive ouverte & dans un journal open access : 5211<br />
publications hors archive ouverte & journal non open access mais avec licence ouverte : 5040<br />
publications hors archive ouverte & journal non open access & sans licence ouverte : 8167<br />
publications dans journaux suspects : 434<br />
publications en accès fermé : 77284<br/>
nombre publications : 154477<br />



## Méthodologie

### Quelles sont les publications sont prises en compte ? 
Les publications identifiées par le [Baromètre français de la Science Ouverte](https://ministeresuprecherche.github.io/bso) (BSO), dont le repérage est basé sur l’identification du pays des affiliations des auteurs. Les bases sources utilisées par le BSO pour trouver ces publications sont Crossref et Hal. Seules les publications avec DOI (de Crossref) sont incluses. <br />


### Comment le type d'accès ouvert est-il obtenu ? 
A partir des données d’[Unpaywall](https://unpaywall.org/products/api). Ces données sont datées, elles ont été extraites à la fin du mois d'octobre 2020.<br />


### Comment l'identification des journaux suspects est-elle réalisée ? 
A partir de la liste [stop predatory journals partagée sur Github](https://github.com/stop-predatory-journals/stop-predatory-journals.github.io/blob/master/_data/journals.csv). L'identification se fait avec les ISSNs : pour chaque titre de la liste les ISSN _print_ et _electronic_ ont été obtenu avec l'API de Crossref.


### Circonspection : périmètre souhaité et outil utilisé 
Il faut distinguer le périmètre que l'on souhaite mesurer et le périmtère couvert par l'outil employé. Le premier ne peut être équivalent au second. Par exemple on aimerait mesurer l'exhaustivité des publications françaises, mais l'outil utilisé couvre les publications avec DOI. Cela étant dit, il faut se rendre compte qu'aucun outil ne permet de mesurer l'exhaustivité des publications françaises. D'autre part, la solution du BSO est une des plus pertinente car elle utilise des données ouvertes, provenant de Crossref, contrairement à la solution européenne basée sur les donées de Scopus.
<br />
Pour perfectionner l'outil, il serait souhaitable pour une 2e version d'intégrer les publicatiosn sans DOIs disponibles en accès ouvert dans HAL.