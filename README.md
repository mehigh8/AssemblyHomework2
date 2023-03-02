<b>Rosu Mihai Cosmin 323CA</b>

<b>task-1:</b>
- Deoarece era precizat ca secventa contine numere consecutive incepand cu 1,
inseamna ca numarul minim este 1, urmatorul 2, etc.
- Prin urmare, am inceput prin gasirea nodului cu valoarea 1. Dupa ce l-am
gasit, i-am salvat adresa pe stiva deoarece functia returneaza adresa nodului
de la care trebuie sa inceapa parcurgerea.
- Dupa gasirea nodului cu valoarea 1 am inceput sa caut urmatorul numar (2).
Odata gasit, in campul next al nodului cu valoarea 1 este trecuta adresa
nodului cu valoarea 2.
- Dupa aceea, in mod analog se cauta urmatoarele numere, iar adresa lor este
trecuta in campul next al nodului cu valoarea precedenta.
- In final mut in eax valoarea salvata pe stiva, adica adresa primului nod.

<b>task-2:</b>
- In cadrul acestui task, nu puteam folosi enter, leave sau mov. Prin urmare,
pentru a putea simula comanda mov am folosit faptul ca operatia or aplicata
intre doua numere, unde primul este 0, va rezulta in copierea valorii celui
de-al doilea numar in primul.
- p1:  
  -Pentru acest subpunct am folosit formula de calcul a cmmmc-ului prin
  impartirea produsului celor doua numere la cmmdc.  
  -Prin urmare, am inceput prin calcularea cmmdc-ului, care dupa calcule se va
  afla in ebx.  
  -Dupa aceea calculez produsul celor doua numere primite ca parametru.  
  -In final impart produsul la cmmdc pentru a obtine cmmmc-ul.
- p2:  
  -Pentru acest subpunct am folosit stiva pentru a retine parantezele deschise.  
  -Pe parcurs ce parcurg sirul de paranteze, verific la fiecare caracter daca
  este o paranteza deschisa, caz in care o adaug pe stiva, sau daca este
  paranteza inchisa, caz in care scot de pe stiva o paranteza (daca mai exista,
  altfel inseamna ca sirul nu este corect).  
  -Dupa ce am terminat de parcurs sirul, verific daca stiva este goala, caz in
  care sirul este corect, altfel inseamna ca au fost mai multe paranteze
  deschise.

<b>task-3:</b>
- In cadrul acestui task am folosit mai multe functii externe, deoarece asa ne-a
fost recomandat. Functiile externe folosite sunt: strtok, strcpy, strlen,
strcmp, qsort.
- get_words:  
  -Pentru a impartii sirul de caractere in cuvinte am folosit functia strtok.  
  -Apoi, cat timp mai existau cuvinte (lucru verificat prin valoarea intoarsa
  de strtok, care daca nu mai gaseste cuvinte intoarce null, adica eax este 0),
  am continuat sa reapelez functia strtok, iar fiecare cuvant este salvat in
  words folosind functia strcpy.
- sort:  
  -Pentru sortare tot ce am facut a fost sa apelez functia qsort cu parametrii
  aferenti.
- compare:  
  -Pentru a sorta cuvintele in functie de lungime, respectiv lexicografic am
  implementat functia compare, care e trimisa ca parametru functiei qsort.  
  -Mai intai se calculeaza lungimile sirurilor primite ca parametru si se
  compara. Daca nu sunt egale functia va intoarce diferenta dintre cele doua
  lungimi (strlen(s1)-strlen(s2)), altfel functia va intoarce rezultatul
  functiei strcmp.  
  -De asemenea, in cadrul functiei am salvat la inceput registrii vechi si i-am
  restaurat la sfarsit, pentru a nu fi pierduti.
  
<b>task-4:</b>
- In cadrul acestui task am folosit recursivitatea mutuala intre cele trei
functii implementate (expression->term->factor->expression->etc.). De asemenea,
nu am folosit cel de-al doilea parametru, pozitia curenta in sir.
- expression:  
  -Functia calculeaza suma/diferenta intre doi termeni, pe care trebuie sa ii
  determine din sirul primit ca parametru cu expresia.  
  -Am inceput prin a salva registrii vechi pe stiva.  
  -Apoi, am cautat primul semn de + sau - care sa nu fie intre paranteze. Prin
  urmare, parcurgand sirul caracter cu caracter verific pentru fiecare caracter
  daca este paranteza deschisa sau inchisa si cresc sau scad contorul ebx.  
  -Daca ebx este 0 inseamna ca pe acea pozitie, caracterul nu se afla intre
  paranteze, caz in care se poate verifica daca acel caracter este + sau -.  
  -Daca nu este, se continua cautarea pana se termina sirul. Daca se termina
  sirul, inseamna ca nu exista niciun semn + sau - care sa nu fie intre
  paranteze, deci se va trimite sirul cu expresia functiei term.  
  -Daca este gasit totusi un semn, sirul va fi impartit in doua prin punerea
  unui caracter null in locul semnului si apelarea functiei term pentru sirul
  initial (care acum se termina la null-ul plasat in locul semnului) si pentru
  sirul care incepe imediat dupa pozitia unde se afla semnul.  
  -Apoi tot ce ramane de facut este calcularea sumei/diferentei intre cele doua
  valori intoarse de apelurile functiei term.  
  -In final, restaurez valorile registrilor, pentru a nu fi pierdute.
- term:  
  -Functia term calculeaza produsul/impartirea a doi factori, pe care trebuie
  sa ii determine.  
  -In mare parte implementarea este facuta in mod analog cu cea a functiei
  expression, iar diferentele sunt cautarea semnelor * si / in loc de + si -,
  si apelarea functiei factor in loc de term.  
- factor:  
  -Functia evalueaza expresia primita si, daca este cazul, intoarce numarul
  format din cifrele din sirul primit. De asemenea, functia factor se ocupa si
  de eliminarea parantezelor, cand acestea cuprind intreaga expresie.  
  -Mai intai, salvez registrii vechi pe stiva si apoi incep parcurgerea sirului
  pentru a determina daca se afla si alte caractere in afara de cifre.  
  -Prin urmare, verific pentru fiecare caracter daca este cifra (daca nu este
  incrementez registrul edx).  
  -Pentru a verifica daca intreaga expresie se afla intr-o paranteza voi numara
  cate caractere nu se afla in nicio paranteza (cu fiecare paranteza deschisa
  incrementez registrul ebx, si cu fiecare paranteza inchisa il decrementez).  
  -Daca registrul ebx este 0 pentru un caracter, inseamna ca acel caracter nu
  se afla in nicio paranteza, asa ca voi incrementa registrul eax pentru
  fiecare caracter de acest tip (consecinta implementarii este ca ultima
  paranteza inchisa este considerata in afara parantezelor).  
  -Dupa ce termin de parcurs sirul, verific daca registrul edx (care numara
  cate caractere nu sunt cifre) este 0, caz in care apelez functia externa
  atoi, care intoarce numarul format din cifrele aflate in sirul pe care il
  primeste ca parametru.  
  -Altfel, verific daca a existat vreun caracter care sa nu fie in paranteza
  (eax trebuie sa fie mai mare decat 1 deoarece numara ultima paranteza), caz
  in care apelez functia expression. Altfel, inseamna ca trebuie stearsa
  paranteza care cuprinde intreaga expresie (este incrementata adresa de
  inceput a sirului si este pus caracterul null pe penultimul caracter) iar
  apoi este apelata functia expression.

<b>bonus_64bit:</b>
- Conform calling convention-ului, parametrii se afla in registrii rdi, rsi,
rdx, rcx, r8, r9. rdi - v1, rsi - n1, rdx - v2, rcx - n2 si r8 - v.
- Parcurg simultan vectorii v1 si v2 si adaug pe rand elemente din vectorul v1,
iar apoi din vectorul v2 in vectorul v.
- Daca vreunul din vectori ajunge la sfarsit (rsi (n1) sau rcx (n2) ajunge sa
fie 0), atunci acel vector este sarit (nu mai adauga elemente in v).
- Daca ambii vectori ajung la sfarsit, inseamna ca nu mai sunt elemente de
adaugat si se iese din loop.
