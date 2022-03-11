*****Bachelorarbeit - Do-File

*Zur Anpassung der entsprechenden Variablen werden zunächst alle irrelevanten Variablen *entfernt, sodass nur die relevanten Variablen im Datensatz verbleiben

keep pre005a pre007a pre014a pre016a pre029* pre047 pre049 pre051 pre053 pre123a

***Variablen zur Messung des Konsums von TV-Nachrichten

*Zur Erstellung von Variablen über den gesamten Konsum sowie über den spezifisch privaten *und öffentlich rechtlichen Konsum, werden zunächst Recodes für alle Sender gebildet. Da die *Werte später miteinander addiert werden, werden auch alle Angaben wie "ich weiß es nicht" *oder "keine Angabe" als Wert 0 kodiert, sodass auch die Personen, die bei einzelnen Sendern *keine Angabe machen konnten, nicht unberücksichtigt bleiben. Alle weiteren Werte bleiben *wie in der ursprünglichen Variablen bestehen

**ARD**
gen ard=pre047
recode ard (-99 -98 8 9 96 97= 0)
label var ard "Wöchentlicher Konsum ARD-Nachrichten"
**ZDF**
gen zdf=pre049
recode zdf (-99 -98 8 9 -97 = 0)
label var zdf "Wöchentlicher Konsum ZDF-Nachrichten"
**RTL**
gen rtl=pre051
recode rtl (-99 -98 8 9 -97= 0)
label var rtl "Wöchentlicher Konsum RTL-Nachrichten"
**SAT1**
gen sat1=pre053
recode sat1 (-99 -98 8 9 -97 = 0)
label var sat1 "Wöchentlicher Konsum Sat1-Nachrichten"

*Zur Erstellung zweier Skalen, mit welchen der Konsum von öffentlchen und privaten *Nachrichtensendungen betrachtet werden können, werden nun die Werte von ard und zdf 
*sowie von rtl und sat1 miteinander addiert

gen oefr=ard+zdf
label var oefr "Konsum öffentlich-rechtlicher Nachrichtensendungen"
gen priv=rtl+sat1
label var priv "Konsum privater Nachrichtensendungen"

*Zur Darstellung des Konsumverhalten in Abschnitt 4.1 werden die beiden Skalen nun auf
*jeweils 3 Gruppen komprimiert: kein TV Konsum (0->0), niedriger TV-Konsum (1-7->1), hoher *TV-Konsum (8-14->2)

recode oefr (1 2 3 4 5 6 7 = 1) (8 9 10 11 12 13 14=2), gen(oefr_komp)
label var oefr_komp "Komprimierte Skala öffentlich-rechtliche Sender"
recode priv (1 2 3 4 5 6 7 = 1) (8 9 10 11 12 13 14=2), gen(priv_komp)
label var priv_komp "Kompimierte Skala private Sender"

*Um nun nachträglich diejenigen Fälle auszuschließen, die auf alle Fragen zu den *TV-Nachrichten mit "ich weiß es nicht" oder gar nicht geantwortet haben, werden *Hilfsvariablen gebildet.

**ARD**
gen ard_h=pre047
recode ard_h (-99 -98 =.) (8 9 96 97= 0)
label var ard_h "Hilfsvariable ARD H1"

**ZDF**
gen zdf_h=pre049
recode zdf_h (-99 -98=.) (8 9 -97 = 0)
label var zdf_h "Hilfsvariable ZDF H1"

**RTL**
gen rtl_h=pre051
recode rtl_h (-99 -98=.) (8 9 -97= 0)
label var rtl_h "Hilfsvariable RTL H1"

**SAT1**
gen sat1_h=pre053
recode sat1_h (-99 -98=.) (8 9 -97 = 0)
label var sat1_h "Hilfsvariable SAT1 H1"

*Auch aus der komprimierten Fassung der Skalen werden nun alle Personen entfernt, die 
*auf alle verwendeten Fragen mit "ich weiß es nicht" oder gar nicht geantwortet haben.

replace oefr_komp=. if ard_h==. & zdf_h==. & rtl_h==. & sat1_h==.
replace priv_komp=. if ard_h==. & zdf_h==. & rtl_h==. & sat1_h==.

*Zur Erstellung einer Skala, mit der der gesamte TV-Nachrichten-Konsum gemessen werden kann, 
*(Abschnitt 4.3) wird im Anschluss die Summe aus den 4 senderspezifischen Variablen gebildet

gen konsumges = ard+zdf+rtl+sat1
label var konsumges "Wöchentlicher Konsum von TV-Nachrichten allgemein"

*Nun werden auch hier alle Personen, die auf alle Fragen TV-spezifischen mit "ich weiß es *nicht" oder gar nicht geantwortet haben, nachträglich entfernt.

replace konsumges=. if ard_h==. & zdf_h==. & rtl_h==. & sat1_h==.

*Zur Erstellung der Skala, mit der die Hypothese 2 getestet werden soll (Abschnitt 4.4), *werden nun die Werte der privaten Nachrichtensendungen von denen der öffentlich-rechtlichen *Sendungen subtrahiert

gen indexoep=oefr-priv
label var indexoep "Index: Vergleich öffentlich-rechtliche/private Ausprägung"

*Da der Wert 0 hier bedeutsam ist und einen ausgeglichenen Konsum der Nachrichten bedeutet,
*werden anschließend alle Personen, die keine der Sendungen gesehen haben oder mit "ich weiß *es nicht" oder gar nicht geantwortet haben, entfernt.

replace indexoep=. if ard==0 & zdf==0 & rtl==0 & sat1==0

*********************************************************************************

***Variablen für die logistische Regression mit den Parteien CDU/CSU

*Wahlentscheidung (AV)*
*Um eine binäre Variable für die Wahlentscheidung für/gegen die CDU zu erstellen, wird 
*eine Variable vc_union erstellt. Hier wird der Wert 1 als Wahlentscheidung für CDU/CSU 
*beibehalten und die Entscheidung für alle anderen Parteien mit dem Wert 0 ersetzt.
*Personen die keine Angabe gemacht haben, "ich weiß es nicht" geantwortet haben, bei einer 
*früheren Frage angegeben haben, dass sie nicht wählen gehen oder schon per Briefwahl 
*gewählt haben, keine oder keine gültige Zweitstimme abgeben werden, werden als Missings 
*kodiert.  
recode pre005a (-99 -98 -97 -84 -83 = .)  (4 5 6 7 322 801 = 0) (1=1), gen (vc_union) 
*Briefwahl*
*Im zweiten Schritt werden die Missings zu 1 kodiert, wenn bei der Frage zur Briefwahl 
*die CDU/CSU als Partei der Zweitstimme angegeben wurde und zu 0 kodiert, wenn eine andere 
*Partei angebeben wurde. 
replace vc_union = 1 if pre007a == 1
replace vc_union = 0 if pre007a == 4
replace vc_union = 0 if pre007a == 5 
replace vc_union = 0 if pre007a == 6
replace vc_union = 0 if pre007a == 7
replace vc_union = 0 if pre007a == 322
replace vc_union = 0 if pre007a == 801
label var vc_union "Wahlentscheidung Union"

*Kandidatenorientierung (Angela Merkel) (UV)*
*Hilfsvariable 1 um missing values zu exkludieren
recode pre029a (-71 -98 -99 =.), gen (candidate1_union)
label var candidate1_union "Hilfsvariable 1: Candidate Union"
*Hilfsvariable 2 um Skala von 1 bis 11 in 0 bis 10 zu transformieren
gen candidate2_union = candidate1_union-1
label var candidate2_union "Hilfsvariable 2: Candidate Union"
*Kandidatenorientierung -> durch Transformation der Skala auf Werte zwischen 0 und 1
gen candidate_union = candidate2_union/10
label var candidate_union "Kandidatenorientierung Union"

*Parteiindetifikation (KV)*
*Um eine binäre Variable für die Parteiidentifikation mit der Union zu erstellen, wird die 
*Variable pid_union erstellt. Hier werden unter dem Wert 1 alle Personen gefasst, die bei der 
*spezifischen Frage angaben, der CDU/CSU, der CDU oder der CSU zugewandt zu sein. Unter den 
*Wert 0 fallen Personen, die angaben sich mit einer der anderen oder keiner Partei zu 
*"identifizieren". Als Missings gelten nur diejenigen, die keine Angabe machten oder mit
*"ich weiß es nicht" antworteten. 
recode pre123a (-98 -99 =.) (4 5 6 7 322 801 808 = 0) (1 2 3 = 1), gen (pid_union)
label var pid_union "Parteiidentifikation Union"

*Issue-Orientierung (KV)*
*Hilfsvariablen für Nennung der Union als Partei mit größter Lösungskompetenz bei für die Person wichtigstem/zweitwichtigstem Problem
recode pre014a  (-97 -99 = .) (4 5 6 7 322 -98 801 802 807 808 809 = 0) (1=1), gen(issue1_union)
label var issue1_union "Hilfsvariable: Lösungskompetenz 1. Issue Union"
recode pre016a (-97 -99 = .) (4 5 6 7 322 -98 801 802 807 808 809 = 0) (1=1), gen(issue2_union)
label var issue2_union "Hilfsvariable: Lösungskompetenz 2. Issue Union"
*Issue-Orientierung
*das Ziel ist es eine Variable zu generieren, für die gilt 
*0 -> die Union wurde weder beim wichtigsten noch beim zweitwichtigsten Problem als lösungskompetent angesehen
*0.5 -> die Union wurde bei einem der beiden Probleme als lösungskompetent angesehen
*1 -> die Union wurde bei beiden Problemen als lösungskompetent angesehen
gen issue_union=.
replace issue_union = 1/2 if issue1_union==1 & issue2_union!=1 
replace issue_union = 1/2 if issue1_union!=1 & issue2_union==1 
replace issue_union = 1 if issue1_union==1 & issue2_union==1
replace issue_union = 0 if issue1_union==0 & issue2_union==0
replace issue_union = 0 if issue1_union==0 & issue2_union==.
replace issue_union = 0 if issue1_union==. & issue2_union==0
label var issue_union "Issue-Orientierung Union"

********************************************************************************
*Die folgenden Variablen wurden analog zum Vorgehen bei der Union kodiert,
*weswegen nur noch Stichpunktartig auf die Vorgänge eingagangen wird.

**Variablen für die logistische Regression mit der Partei SPD

*Wahlentscheidung (AV)*
recode pre005a (-99 -98 -97 -84 -83 = .)  (1 5 6 7 322 801 = 0) (4=1), gen (vc_spd) 
*Briefwahl
replace vc_spd = 1 if pre007a == 4
replace vc_spd = 0 if pre007a == 1 | pre007a == 5 | pre007a == 6 | pre007a == 7 | pre007a == 322 | pre007a == 801
label var vc_spd "Wahlentscheidung SPD"

*Kandidatenorientierung (Martin Schulz) (UV)*
*Hilfsvariable 1 
recode pre029b (-71 -98 -99 =.), gen (candidate1_spd)
label var candidate1_spd "Hilfsvariable 1: Candidate SPD"
*Hilfsvariable 2 
gen candidate2_spd = candidate1_spd-1
label var candidate2_spd "Hilfsvariable 2: Candidate SPD"
*Kandidatenorientierung
gen candidate_spd = candidate2_spd/10
label var candidate_spd "Kandidatenorientierung SPD"

*Parteiindetifikation (KV)*
recode pre123a (-99 -98 =.) (1 2 3 5 6 7 322 801 808 = 0) (4 = 1), gen (pid_spd)
label var pid_spd "Parteiidentifikation SPD"

*Issue-Orientierung (KV)*
*Hilfsvariablen
recode pre014a  (-97 -99 = .)(1 5 6 7 322 -98 801 802 807 808 809 = 0) (4=1), gen(issue1_spd)
label var issue1_spd "Hilfsvariable: Lösungskompetenz 1. Issue SPD"
recode pre016a (-97 -99 = .) (1 5 6 7 322 -98 801 802 807 808 809 = 0) (4=1), gen(issue2_spd)
label var issue2_spd "Hilfsvariable: Lösungskompetenz 2. Issue SPD"
*Issue-Orientierung
gen issue_spd=.
replace issue_spd = 1/2 if issue1_spd==1 & issue2_spd!=1 
replace issue_spd = 1/2 if issue1_spd!=1 & issue2_spd==1 
replace issue_spd = 1 if issue1_spd==1 & issue2_spd==1
replace issue_spd = 0 if issue1_spd==0 & issue2_spd==0
replace issue_spd = 0 if issue1_spd==. & issue2_spd==0
replace issue_spd = 0 if issue1_spd==0 & issue2_spd==.
label var issue_spd "Issue-Orientierung SPD"

*******************************************************************************

**Variablen für die logistische Regression mit der Partei  B90/ die Grünen

*Wahlentscheidung (AV)*
recode pre005a (-99 -98 -97 -84 -83 = .)  (1 4 5 7 322 801 = 0) (6=1), gen (vc_gruene) 
*Briefwahl
replace vc_gruene = 1 if pre007a == 6 
replace vc_gruene = 0 if pre007a == 1 | pre007a == 4 | pre007a == 5 | pre007a ==7 | pre007a == 322 | pre007a == 801
label var vc_gruene "Wahlentscheidung Grüne"

*Kandidatenorientierung (Cem Özdemir) (UV)*
*Hilfsvariable 1 
recode pre029d (-71 -98 -99 =.), gen (candidate1_gruene)
label var candidate1_gruene "Hilfsvariable 1: Candidate Gruene"
*Hilfsvariable 2 
gen candidate2_gruene = candidate1_gruene-1
label var candidate2_gruene "Hilfsvariable 2: Candidate Gruene"
*Kandidatenorientierung 
gen candidate_gruene = candidate2_gruene/10
label var candidate_gruene "Kandidatenorientierung Gruene"

*Parteiindetifikation (KV)*
recode pre123a (-99 -98 =.) (1 2 3 4 5 7 322 801 808 = 0) (6 = 1) , gen (pid_gruene)
label var pid_gruene "Parteiidentifikation Grüne"

*Issue-Orientierung (KV)*
*Hilfsvariablen 
recode pre014a (-97 -99 = .) (1 4 5 7 322 -98 801 802 807 808 809 = 0) (6=1), gen(issue1_gruene)
label var issue1_gruene "Hilfsvariable: Lösungskompetenz 1. Issue Grüne"
recode pre016a (-97 -99 = .) (1 4 5 7 322 -98 801 802 807 808 809 = 0) (6=1), gen(issue2_gruene)
label var issue2_gruene "Hilfsvariable: Lösungskompetenz 2. Issue Grüne"
*Issue-Orientierung
gen issue_gruene=.
replace issue_gruene = 1/2 if issue1_gruene==1 & issue2_gruene!=1 
replace issue_gruene = 1/2 if issue1_gruene!=1 & issue2_gruene==1 
replace issue_gruene = 1 if issue1_gruene==1 & issue2_gruene==1
replace issue_gruene = 0 if issue1_gruene==0 & issue2_gruene==0
replace issue_gruene = 0 if issue1_gruene==. & issue2_gruene==0
replace issue_gruene = 0 if issue1_gruene==0 & issue2_gruene==.
label var issue_gruene "Issue-Orientierung Grüne"

********************************************************************************
**Variablen für die logistische Regression mit der Partei FDP

*Wahlentscheidung (AV)*
recode pre005a (-99 -98 -97 -84 -83 = .)  (1 4 6 7 322 801 = 0) (5=1), gen (vc_fdp) 
*Briefwahl
replace vc_fdp = 1 if pre007a == 5
replace vc_fdp = 0 if pre007a == 1 | pre007a == 4 | pre007a == 6 | pre007a == 7 | pre007a == 322 | pre007a == 801
label var vc_fdp "Wahlentscheidung FDP"

*Kandidatenorientierung (Christian Lindner) (UV)*
*Hilfsvariable 1 
recode pre029e (-71 -98 -99 =.), gen (candidate1_fdp)
label var candidate1_fdp "Hilfsvariable 1: Candidate FDP"
*Hilfsvariable 2 
gen candidate2_fdp = candidate1_fdp-1
label var candidate2_fdp "Hilfsvariable 2: Candidate FDP"
*Kandidatenorientierung 
gen candidate_fdp = candidate2_fdp/10
label var candidate_fdp "Kandidatenorientierung FDP"

*Parteiindetifikation (KV)*
recode pre123a (-99 -98=.) (1 2 3 4 6 7 322 801 808 = 0) (5 = 1), gen (pid_fdp)
label var pid_fdp "Parteiidentifikation FDP"

*Issue-Orientierung (KV)*
*Hilfsvariablen
recode pre014a (-97 -99 = .) (1 4 6 7 322 -98 801 802 807 808 809 = 0) (5=1), gen(issue1_fdp)
label var issue1_fdp "Hilfsvariable: Lösungskompetenz 1. Issue FDP"
recode pre016a (-97 -99 = .) (1 4 6 7 322 -98 801 802 807 808 809 = 0) (5=1), gen(issue2_fdp)
label var issue2_fdp "Hilfsvariable: Lösungskompetenz 2. Issue FDP"
*Issue-Orientierung
gen issue_fdp=.
replace issue_fdp = 1/2 if issue1_fdp==1 & issue2_fdp!=1 
replace issue_fdp = 1/2 if issue1_fdp!=1 & issue2_fdp==1 
replace issue_fdp = 1 if issue1_fdp==1 & issue2_fdp==1
replace issue_fdp = 0 if issue1_fdp==0 & issue2_fdp==0
replace issue_fdp = 0 if issue1_fdp==. & issue2_fdp==0
replace issue_fdp = 0 if issue1_fdp==0 & issue2_fdp==.
label var issue_fdp "Issue-Orientierung FDP"

********************************************************************************
**Variablen für die logistische Regression mit der Partei die Linke

*Wahlentscheidung (AV)*
recode pre005a (-99 -98 -97 -84 -83 = .)  (1 4 5 6 322 801 = 0) (7=1), gen (vc_linke) 
*Briefwahl
replace vc_linke = 1 if pre007a == 7
replace vc_linke = 0 if pre007a == 1 | pre007a == 4 | pre007a == 5 | pre007a == 6 | pre007a == 322 | pre007a == 801 
label var vc_linke "Wahlentscheidung Linke"

*Kandidatenorientierung (Sahra Wagenknecht) (UV)*
*Hilfsvariable 1 
recode pre029c (-71 -98 -99 =.), gen (candidate1_linke)
label var candidate1_linke "Hilfsvariable 1: Candidate Linke"
*Hilfsvariable 2
gen candidate2_linke = candidate1_linke-1
label var candidate2_linke "Hilfsvariable 2: Candidate Linke"
*Kandidatenorientierung
gen candidate_linke = candidate2_linke/10
label var candidate_linke "Kandidatenorientierung Linke"

*Parteiindetifikation (KV)*
recode pre123a (-98 -99=.) (1 2 3 4 5 6 322 801 808 = 0) (7 = 1) , gen (pid_linke)
label var pid_linke "Parteiidentifikation Linke"

*Issue-Orientierung (KV)*
*Hilfsvariablen
recode pre014a (-97 -99 = .) (1 4 5 6 322 -98 801 802 807 808 809 = 0) (7=1), gen(issue1_linke)
label var issue1_linke "Hilfsvariable: Lösungskompetenz 1. Issue Linke"
recode pre016a (-97 -99 = .) (1 4 5 6 322 -98 801 802 807 808 809 = 0) (7=1), gen(issue2_linke)
label var issue2_linke "Hilfsvariable: Lösungskompetenz 2. Issue Linke"
*Issue-Orientierung
gen issue_linke=.
replace issue_linke = 1/2 if issue1_linke==1 & issue2_linke!=1 
replace issue_linke = 1/2 if issue1_linke!=1 & issue2_linke==1 
replace issue_linke = 1 if issue1_linke==1 & issue2_linke==1
replace issue_linke = 0 if issue1_linke==0 & issue2_linke==0
replace issue_linke = 0 if issue1_linke==. & issue2_linke==0
replace issue_linke = 0 if issue1_linke==0 & issue2_linke==.
label var issue_linke "Issue-Orientierung Linke"

********************************************************************************
**Variablen für die logistische Regression mit der Partei AfD

*Wahlentscheidung (AV)
recode pre005a (-99 -98 -97 -84 -83 = .)  (1 4 5 6 7 801 = 0) (322=1), gen (vc_afd) 
*Briefwahl
replace vc_afd = 1 if pre007a == 322
replace vc_afd = 0 if pre007a == 1 | pre007a == 4 | pre007a == 5 | pre007a == 6 | pre007a == 7 | pre007a == 801
label var vc_afd "Wahlentscheidung AfD"

*Kandidatenorientierung (Frauke Petry) (UV)*
*Hilfsvariable 1 
recode pre029f (-71 -98 -99 =.), gen (candidate1_afd)
label var candidate1_afd "Hilfsvariable 1: Candidate AfD"
*Hilfsvariable 2
gen candidate2_afd = candidate1_afd-1
label var candidate2_afd "Hilfsvariable 2: Candidate AfD"
*Kandidatenorientierung 
gen candidate_afd = candidate2_afd/10
label var candidate_afd "Kandidatenorientierung AfD"

*Parteiindetifikation (KV)*
recode pre123a (-98 -99=.) (1 2 3 4 5 6 7 801 808 = 0) (322 = 1) , gen (pid_afd)
label var pid_afd "Parteiidentifikation AfD"

*Issue-Orientierung (KV)*
recode pre014a (-97 -99 = .) (1 4 5 6 7 -98 801 802 807 808 809 = 0) (322=1), gen(issue1_afd)
label var issue1_afd "Hilfsvariable: Lösungskompetenz 1. Issue AfD"
recode pre016a (-97 -99 = .) (1 4 5 6 7 -98 801 802 807 808 809 = 0) (322=1), gen(issue2_afd)
label var issue2_afd "Hilfsvariable: Lösungskompetenz 2. Issue AfD"
*Issue-Orientierung
gen issue_afd=.
replace issue_afd = 1/2 if issue1_afd==1 & issue2_afd!=1 
replace issue_afd = 1/2 if issue1_afd!=1 & issue2_afd==1 
replace issue_afd = 1 if issue1_afd==1 & issue2_afd==1
replace issue_afd = 0 if issue1_afd==0 & issue2_afd==0
replace issue_afd = 0 if issue1_afd==. & issue2_afd==0
replace issue_afd = 0 if issue1_afd==0 & issue2_afd==.
label var issue_afd "Issue-Orientierung AfD"

********************************************************************************

***Ergebnisse

***Abschnitt 4.1 - Konsum von TV-Nachrichten (Crosstab)

tab oefr_komp priv_komp 

***Abschnitt 4.2 - Baseline Michigan-Modell

*Zur Untersuchung der Einflussfaktoren des Michigan-Modells werden für alle Parteien
*logistische Regressionen gerechnet, hierbei ist die jeweils spezifische binäre
*Variable vc_parteiname die abhängige Variable. Nachträglich wird weiterhin das 
*Pseudo-R² nach Nagelkerke berechnet, um Auskunft über die Erklärungskraft geben zu können

*Union
logit vc_union candidate_union pid_union issue_union 
estadd nagelkerke
*SPD
logit vc_spd candidate_spd pid_spd issue_spd 
estadd nagelkerke
*Gruene
logit vc_gruene candidate_gruene pid_gruene issue_gruene
estadd nagelkerke
*FDP
logit vc_fdp candidate_fdp pid_fdp issue_fdp
estadd nagelkerke
*Linke
logit vc_linke candidate_linke pid_linke issue_linke
estadd nagelkerke
*AfD
logit vc_afd candidate_afd pid_afd issue_afd
estadd nagelkerke

***Abschnitt 4.3 - Hypothese 1 (Michigan-Modell unter Berücksichtigung des *Nachrichten-Konsums)

*Zur Untersuchung der Hypothese 1 wird das Sample in 2 Gruppen geteilt. 
*Personen, deren TV-Nachrichten-Konsum als niedrig gilt (konsumges<=7) 
*und Personen, deren TV-Nachrichten-Konsum als hoch gilt (konsumges>=8)
*bei dieser Gruppe wird die Bedingung, dass es sich nicht um Missings handeln darf 
*hinzugefügt, da diese von stata als sehr hohe Zahlen gewertet würden 
*und diese Personen möglicherweise das Ergebnis verfälschen würden.
*Auch hier wird anschließend das Pesudo-R² nach Nagelkerke berechnet.

*Union
logit vc_union candidate_union pid_union issue_union if konsumges<=7 
estadd nagelkerke
logit vc_union candidate_union pid_union issue_union if konsumges>=8 & konsumges!=. 
estadd nagelkerke

*SPD
logit vc_spd candidate_spd pid_spd issue_spd if konsumges<=7 
estadd nagelkerke
logit vc_spd candidate_spd pid_spd issue_spd if konsumges>=8 & konsumges!=. 
estadd nagelkerke

*Die Gruenen
logit vc_gruene candidate_gruene pid_gruene issue_gruene if konsumges<=7 
estadd nagelkerke
logit vc_gruene candidate_gruene pid_gruene issue_gruene if konsumges>=8 & konsumges!=. 
estadd nagelkerke

*FDP
logit vc_fdp candidate_fdp pid_fdp issue_fdp if konsumges<=7 
estadd nagelkerke
logit vc_fdp candidate_fdp pid_fdp issue_fdp if konsumges>=8 & konsumges!=. 
estadd nagelkerke

*Die Linke
logit vc_linke candidate_linke pid_linke issue_linke if konsumges<=7 
estadd nagelkerke
logit vc_linke candidate_linke pid_linke issue_linke if konsumges>=8 & konsumges!=. 
estadd nagelkerke

*AfD
logit vc_afd candidate_afd pid_afd issue_afd if konsumges<=7 
estadd nagelkerke
logit vc_afd candidate_afd pid_afd issue_afd if konsumges>=8 & konsumges!=. 
estadd nagelkerke

***Abschnitt 4.4 - Hypothese 2 (Michigan-Modell unter Berücksichtigung des privaten & öffentlich-rechtlichen Nachrichtenkonsums)

*Auch zur Untersuchung der Hypothese 2 wird das Sample in 2 Gruppen geteilt. 
*Personen, deren Nachrichtenkonsum öffentlich-rechtlich geprägt ist (indexoep<=6) 
*und Personen, deren TV-Nachrichten-Konsum als hoch gilt (indexoep>=7)
*auch bei dieser Gruppe wird die Bedingung, dass es sich nicht um Missings handeln darf 
*hinzugefügt, um das Ergebnis nicht zu verfälschen
*Auch hier wird anschließend das Pesudo-R² nach Nagelkerke berechnet.

*Union
logit vc_union candidate_union pid_union issue_union if indexoep<=6
estadd nagelkerke
logit vc_union candidate_union pid_union issue_union if indexoep>=7 & indexoep!=. 
estadd nagelkerke

*SPD
logit vc_spd candidate_spd pid_spd issue_spd if indexoep<=6
estadd nagelkerke
logit vc_spd candidate_spd pid_spd issue_spd if indexoep>=7 & indexoep!=. 
estadd nagelkerke

*Die Gruenen
logit vc_gruene candidate_gruene pid_gruene issue_gruene if indexoep<=6
estadd nagelkerke
logit vc_gruene candidate_gruene pid_gruene issue_gruene if indexoep>=7 & indexoep!=. 
estadd nagelkerke

*FDP
logit vc_fdp candidate_fdp pid_fdp issue_fdp if indexoep<=6
estadd nagelkerke
logit vc_fdp candidate_fdp pid_fdp issue_fdp if indexoep>=7 & indexoep!=. 
estadd nagelkerke

*Die Linke
logit vc_linke candidate_linke pid_linke issue_linke if indexoep<=6
estadd nagelkerke
logit vc_linke candidate_linke pid_linke issue_linke if indexoep>=7 & indexoep!=. 
estadd nagelkerke

*AfD
logit vc_afd candidate_afd pid_afd issue_afd if indexoep<=6
estadd nagelkerke
logit vc_afd candidate_afd pid_afd issue_afd if indexoep>=7 & indexoep!=. 
estadd nagelkerke

*** Darstellungen des Anhangs

*Anhang 2 & 3
*Um nur diejenigen Personen zu zeigen, die in den Analysen berücksichtigt werden,
*werden hier die Personen, die bei keiner der senderspezifischen Fragen geantwortet haben
*oder mit "ich weiß es nicht" geantwortet haben entfernt.
*2
replace oefr=. if ard_h==. & zdf_h==. & rtl_h==. & sat1_h==.
tab oefr
*3
replace priv=. if ard_h==. & zdf_h==. & rtl_h==. & sat1_h==.
tab priv

*Anhang 4
tab konsumges
*Anhang 5
tab indexoep

*Anhang 6
*Im diesem Anhang wird dargestellt, wie viele der in den jeweiligen Modellen berücksichtigten
*Personen die entsprechende Partei gewählt haben
*Da in dem Modell nur diejenigen berücksichtigt werden, für die für die unabhängige und die 
*Kontrollvariablen Werte verfügbar sind, werden hier Personen mit mindestens einem fehlenden 
*Wert entfernt und nur dienigen mit niedrigem Konsum berücksichtigt.
*Aus den Tabellen wird die Gesamtzahl der berücksichtigten Personen abgelesen ("Total") 
*und andererseits die Anzahl der Personen, die die entsprechende Partei gewählt hat ("1")
*abgelesen. Dieser Schritt wird für alle Parteien wiederholt

tab vc_union if konsumges<=7 & candidate_union!=. & pid_union!=. & issue_union!=.
tab vc_spd if konsumges<=7 & candidate_spd!=. & pid_spd!=. & issue_spd!=.
tab vc_gruene if konsumges<=7 & candidate_gruene!=. & pid_gruene!=. & issue_gruene!=.
tab vc_fdp if konsumges<=7 & candidate_fdp!=. & pid_fdp!=. & issue_fdp!=.
tab vc_linke if konsumges<=7 & candidate_linke!=. & pid_linke!=. & issue_linke!=.
tab vc_afd if konsumges<=7 & candidate_afd!=. & pid_afd!=. & issue_afd!=.

*Im zweiten Schritt wird der Vorgang für die Gruppe der Personen mit hohem Konsum wiederholt

tab vc_union if konsumges>=8 & konsumges!=. & candidate_union!=. & pid_union!=. & issue_union!=.
tab vc_spd if konsumges>=8 & konsumges!=. & candidate_spd!=. & pid_spd!=. & issue_spd!=.
tab vc_gruene if konsumges>=8 & konsumges!=. & candidate_gruene!=. & pid_gruene!=. & issue_gruene!=.
tab vc_fdp if konsumges>=8 & konsumges!=. & candidate_fdp!=. & pid_fdp!=. & issue_fdp!=.
tab vc_linke if konsumges>=8 & konsumges!=. & candidate_linke!=. & pid_linke!=. & issue_linke!=.
tab vc_afd if konsumges>=8 & konsumges!=. & candidate_afd!=. & pid_afd!=. & issue_afd!=.

*Anhang 7
*Hier werden die gleichen Schritte wie für Anhang 6 anhand des Index' für
*öffentlich-rechtlich/private Ausprägungen vollzogen

tab vc_union if indexoep<=6 & candidate_union!=. & pid_union!=. & issue_union!=.
tab vc_spd if indexoep<=6 & candidate_spd!=. & pid_spd!=. & issue_spd!=.
tab vc_gruene if indexoep<=6 & candidate_gruene!=. & pid_gruene!=. & issue_gruene!=.
tab vc_fdp if indexoep<=6 & candidate_fdp!=. & pid_fdp!=. & issue_fdp!=.
tab vc_linke if indexoep<=6 & candidate_linke!=. & pid_linke!=. & issue_linke!=.
tab vc_afd if indexoep<=6 & candidate_afd!=. & pid_afd!=. & issue_afd!=.

*Im zweiten Schritt wird der Vorgang für die Gruppe der Personen mit hohem Konsum wiederholt

tab vc_union if indexoep>=7 & indexoep!=. & candidate_union!=. & pid_union!=. & issue_union!=.
tab vc_spd if indexoep>=7 & indexoep!=. & candidate_spd!=. & pid_spd!=. & issue_spd!=.
tab vc_gruene if indexoep>=7 & indexoep!=. & candidate_gruene!=. & pid_gruene!=. & issue_gruene!=.
tab vc_fdp if indexoep>=7 & indexoep!=. & candidate_fdp!=. & pid_fdp!=. & issue_fdp!=.
tab vc_linke if indexoep>=7 & indexoep!=. & candidate_linke!=. & pid_linke!=. & issue_linke!=.
tab vc_afd if indexoep>=7 & indexoep!=. & candidate_afd!=. & pid_afd!=. & issue_afd!=.
