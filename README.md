# Stație de alimentare cu carburant

Proiect pentru cursul de **Baze de date**, realizat de **Matei Calomfirescu**, **grupa 211**.

## 1. Descrierea modelului real, a utilității acestuia și a regulilor de funcționare

Modelul real ales pentru acest proiect este o stație de alimentare cu carburanți, adică o benzinărie care 
desfășoară atât activități comerciale cu clienții, cât și activități interne de administrare și 
aprovizionare. O astfel de unitate va gestiona vânzarea de carburant, comercializarea produselor din magazin,
emiterea bonurilor fiscale, evidența angajaților și a turelor de lucru, precum și relațiile cu furnizorii.

Această bază de date are rolul de a modela organizat toate aceste activități, astfel încât informațiile 
importante să poată fi stocate, actualizate și interogate ușor. Prin intermediul acestei baze de date se 
pot urmări elemente esențiale din funcționarea stației, cum ar fi: ce tipuri de carburant sunt disponibile, 
la ce pompe se realizează alimentările, prin ce pistol de pompă se face o alimentare, ce produse se vând în
magazin, ce bonuri fiscale au fost emise, ce angajați sunt programați în anumite ture, ce aprovizionări de 
produse au fost făcute de la furnizori și ce livrări de carburant au fost primite de stație.

Utilitatea modelului este una practică și clară. În primul rând, acesta permite organizarea activității 
comerciale a stației, prin evidența alimentărilor și a vânzărilor de produse. În al doilea rând, permite 
gestionarea activității interne, prin evidența angajaților, a rolurilor acestora și a turelor de lucru. În 
plus, baza de date oferă suport pentru urmărirea stocurilor și a aprovizionărilor, ceea ce este esențial 
pentru buna funcționare a magazinului și a întregii stații.

Baza de date urmărește două fluxuri de activitate:

1) **Activitatea comercială**

Un client vine în stație pentru a alimenta cu carburant la una dintre pompe și, opțional, poate cumpăra și 
produse din magazin. Fiecare pompă poate avea unul sau mai multe pistoale, iar fiecare pistol de pompă este 
asociat unui anumit tip de carburant. La finalul tranzacției, se emite un bon fiscal care centralizează 
produsele cumpărate și, după caz, alimentarea efectuată. Astfel, baza de date va trebui să poată reține 
informații despre client, pompă, pistolul folosit, tipul de carburant, bonul fiscal și articolele înscrise pe bon.

2) **Activitatea internă**
   
Stația funcționează cu ajutorul angajaților, care lucrează în ture și au responsabilități diferite. Entitatea 
ANGAJAT este tratată ca superentitate, având ca subentități CASIER, OPERATOR_POMPA și RESPONSABIL_STOC. 
Astfel, modelul surprinde faptul că nu toți angajații au aceleași atribuții. Relația dintre ANGAJAT și TURA
este gestionată prin entitatea asociativă PROGRAMARE_TURA. Tot în activitatea internă intră 
și aprovizionarea stației de la diverși furnizori, pentru produsele din magazin, precum și livrările de 
carburant asociate stației, furnizorului și tipului de carburant.

Entitățile bazei de date:
1. [STAȚIE](#entitatea-stație) - Reține informațiile despre benzinărie;
2. [TIP_CARBURANT](#entitatea-tip-carburant) - Tipurile de carburant vândute;
3. [POMPA](#entitatea-pompa) - Pompele de alimentare;
4. [PISTOL_POMPA](#entitatea-pistol-pompa) - Pistoalele asociate pompelor, fiecare corespunzând unui tip de carburant;
5. [CLIENT](#entitatea-client) - Clienții care alimentează și cumpără produse;
6. [ANGAJAT](#entitatea-angajat) - Superentitate pentru toți angajații stației;
7. [CASIER](#entitatea-casier) - Subentitate pentru angajații care lucrează la casă;
8. [OPERATOR_POMPA](#entitatea-operator-pompa) - Subentitate pentru angajații care operează pompele;
9. [RESPONSABIL_STOC](#entitatea-responsabil-stoc) - Subentitate pentru angajații care gestionează stocul magazinului;
10. [TURĂ](#entitatea-tura) - Reține informații despre turele de lucru ale angajaților;
11. [PROGRAMARE_TURA](#entitatea-programare-tura) - Tabel asociativ între ANGAJAT și TURA pentru evidența programărilor în ture;
12. [BON_FISCAL](#entitatea-bon-fiscal) - Reprezintă bonurile fiscale emise în urma tranzacțiilor;
13. [ALIMENTARE](#entitatea-alimentare) - Reprezintă operația de alimentare a unui client, realizată printr-un pistol de pompă și asociată unui bon fiscal;
14. [PRODUS_MAGAZIN](#entitatea-produs-magazin) - Produsele disponibile în magazin;
15. [ARTICOL_BON](#entitatea-articol-bon) - Tabel asociativ între BON_FISCAL și PRODUS_MAGAZIN pentru a înregistra produsele vândute în magazin;
16. [FURNIZOR](#entitatea-furnizor) - Furnizorii de carburant și produse;
17. [APROVIZIONARE](#entitatea-aprovizionare) - Reprezintă intrările de produse în stație de la furnizori;
18. [ARTICOL_APROV_PRODUS](#entitatea-articol-aprov-produs) - Tabel asociativ între APROVIZIONARE și PRODUS_MAGAZIN pentru a înregistra produsele aprovizionate;
19. [LIVRARE_CARBURANT](#entitatea-livrare-carburant) - Entitate asociativă provenită din relația ternară dintre STAȚIE, FURNIZOR și TIP_CARBURANT, folosită pentru a înregistra livrările de carburant.

## 2. Prezentarea constrângerilor (restricții, reguli) impuse asupra modelului

O pompă aparține unei singure stații de alimentare.
-- cardinalități

Într-o stație de alimentare pot exista mai multe pompe.
-- cardinalități

Un pistol de pompă aparține unei singure pompe, iar o pompă poate avea mai multe pistoale.
-- cardinalități

Un pistol de pompă este asociat unui singur tip de carburant, iar un tip de carburant poate fi asociat mai multor pistoale.
-- cardinalități

Un client poate avea mai multe bonuri fiscale, dar un bon fiscal aparține unui singur client.
-- cardinalități

Un bon fiscal poate conține mai multe produse din magazin, iar un produs poate apărea pe mai multe bonuri fiscale.
-- cardinalități; relație de tip many-to-many, rezolvată prin ARTICOL_BON

O alimentare este realizată printr-un singur pistol de pompă și este asociată unui singur bon fiscal.
-- cardinalități

Un bon fiscal poate avea cel mult o alimentare.
-- cardinalități

Un furnizor poate realiza mai multe aprovizionări, dar o aprovizionare provine de la un singur furnizor.
-- cardinalități

O aprovizionare poate conține mai multe produse din magazin, iar un produs poate apărea în mai multe aprovizionări.
-- cardinalități; relație de tip many-to-many, rezolvată prin ARTICOL_APROV_PRODUS

O livrare de carburant leagă un singur furnizor, o singură stație și un singur tip de carburant.
-- relație ternară

Un furnizor poate realiza mai multe livrări de carburant, o stație poate primi mai multe livrări de carburant, iar un tip de carburant poate apărea în mai multe livrări.
-- cardinalități

Un angajat poate lucra în mai multe ture, iar într-o tură pot lucra mai mulți angajați.
-- cardinalități; relație de tip many-to-many, rezolvată prin PROGRAMARE_TURA

Un casier, un operator pompă sau un responsabil stoc trebuie să existe mai întâi ca angajat.
-- relația dintre superentitate și subentități

Numele angajatului, denumirea produsului, denumirea carburantului, data bonului fiscal și numărul pompei sunt cunoscute.
-- atribute NOT NULL

Prețul unui carburant și prețul unui produs din magazin trebuie să fie valori pozitive.
-- verificarea valorilor atributelor

Cantitatea alimentată trebuie să fie mai mare decât 0.
-- validarea datelor

Cantitatea unui produs trecută pe bon trebuie să fie mai mare decât 0.
-- validarea datelor

Stocul unui produs din magazin nu poate fi negativ.
-- reguli de consistență

Fiecare bon fiscal este identificat în mod unic.
-- cheia primară / unicitate

Fiecare alimentare trebuie asociată unui bon fiscal existent.
-- integritate referențială

## 3. Descrierea entităților, incluzând precizarea cheii primare

### Entitatea STAȚIE

- Descriere: Reține informațiile despre benzinărie;
- Cheie primară: id_stație;

### Entitatea TIP_CARBURANT

- Descriere: Tipurile de carburant vândute;
- Cheie primară: id_tip_carburant;

### Entitatea POMPA

- Descriere: Pompele de alimentare;
- Cheie primară: id_pompa;
- Cheie externă: id_stație (referință către STAȚIE);

### Entitatea PISTOL_POMPA

- Descriere: Pistoalele asociate pompelor, fiecare corespunzând unui tip de carburant;
- Cheie primară: id_pistol_pompa;
- Chei externe: id_pompa (referință către POMPA), id_tip_carburant (referință către TIP_CARBURANT);

### Entitatea CLIENT

- Descriere: Clienții care alimentează și cumpără produse;
- Cheie primară: id_client;

### Entitatea ANGAJAT

- Descriere: Superentitate pentru toți angajații stației;
- Cheie primară: id_angajat;
- Cheie externă: id_stație (referință către STAȚIE);

### Entitatea CASIER

- Descriere: Subentitate pentru angajații care lucrează la casă;
- Cheie primară și cheie externă: id_angajat (referință către ANGAJAT);

### Entitatea OPERATOR_POMPA

- Descriere: Subentitate pentru angajații care operează pompele;
- Cheie primară și cheie externă: id_angajat (referință către ANGAJAT);

### Entitatea RESPONSABIL_STOC

- Descriere: Subentitate pentru angajații care gestionează stocul magazinului;
- Cheie primară și cheie externă: id_angajat (referință către ANGAJAT);

### Entitatea TURĂ

- Descriere: Reține informații despre turele de lucru ale angajaților;
- Cheie primară: id_tura;

### Entitatea PROGRAMARE_TURA

- Descriere: Tabel asociativ între ANGAJAT și TURA pentru evidența programărilor în ture;
- Cheie primară compusă: (id_angajat, id_tura);
- Chei externe: id_angajat (referință către ANGAJAT), id_tura (referință către TURĂ);

### Entitatea BON_FISCAL

- Descriere: Reprezintă bonurile fiscale emise în urma tranzacțiilor;
- Cheie primară: id_bon;
- Cheie externă: id_client (referință către CLIENT);

### Entitatea ALIMENTARE

- Descriere: Reprezintă operația de alimentare a unui client, realizată printr-un pistol de pompă și asociată unui bon fiscal;
- Cheie primară: id_alimentare;
- Chei externe: id_pistol_pompa (referință către PISTOL_POMPA), id_bon (referință către BON_FISCAL);

### Entitatea PRODUS_MAGAZIN

- Descriere: Produsele disponibile în magazin;
- Cheie primară: id_produs_magazin;

### Entitatea ARTICOL_BON

- Descriere: Tabel asociativ între BON_FISCAL și PRODUS_MAGAZIN pentru a înregistra produsele vândute în magazin;
- Cheie primară compusă: (id_bon, id_produs_magazin);
- Chei externe: id_bon (referință către BON_FISCAL), id_produs_magazin (referință către PRODUS_MAGAZIN);

### Entitatea FURNIZOR

- Descriere: Furnizorii de carburant și produse;
- Cheie primară: id_furnizor;

### Entitatea APROVIZIONARE

- Descriere: Reprezintă intrările de produse în stație de la furnizori;
- Cheie primară: id_aprovizionare;
- Cheie externă: id_furnizor (referință către FURNIZOR);

### Entitatea ARTICOL_APROV_PRODUS

- Descriere: Tabel asociativ între APROVIZIONARE și PRODUS_MAGAZIN pentru a înregistra produsele aprovizionate;
- Cheie primară compusă: (id_aprovizionare, id_produs_magazin);
- Chei externe: id_aprovizionare (referință către APROVIZIONARE), id_produs_magazin (referință către PRODUS_MAGAZIN);

### Entitatea LIVRARE_CARBURANT

- Descriere: Entitate asociativă provenită din relația ternară dintre STAȚIE, FURNIZOR și TIP_CARBURANT, folosită pentru a înregistra livrările de carburant;
- Cheie primară: id_livrare_carburant;
- Chei externe: id_statie (referință către STAȚIE), id_furnizor (referință către FURNIZOR), id_tip_carburant (referință către TIP_CARBURANT);


## 4. Descrierea relațiilor, incluzând precizarea cardinalității acestora

| Relație | Cardinalitate | Observații |
|---|---|---|
| **are**: STAȚIE – POMPĂ | stație – pompă: **one-to-many** | O stație poate avea mai multe pompe. Fiecare pompă aparține unei singure stații. |
| **are**: STAȚIE – ANGAJAT | stație – angajat: **one-to-many** | O stație poate avea mai mulți angajați sau niciunul înregistrat momentan. Fiecare angajat aparține exact stații. |
| **are**: POMPĂ – PISTOL_POMPĂ | pompă – pistol_pompă: **one-to-many** | O pompă poate avea unul sau mai multe pistoale. Fiecare pistol aparține unei singure pompe. |
| **distribuie**: TIP_CARBURANT – PISTOL_POMPĂ | tip_carburant – pistol_pompă: **one-to-many** | Un tip de carburant poate fi distribuit prin mai multe pistoale. Fiecare pistol este asociat unui singur tip de carburant. |
| **are loc la**: PISTOL_POMPĂ – ALIMENTARE | pistol_pompă – alimentare: **one-to-many** | Un pistol poate fi folosit în mai multe alimentări sau în niciuna. Fiecare alimentare se realizează print exact un pistol. |
| **se trece pe**: BON_FISCAL – ALIMENTARE | bon_fiscal – alimentare: **one-to-zero-or-one** | Un bon fiscal poate avea cel mult o alimentare. Fiecare alimentare este asociată unui singur bon fiscal. |
| **are**: CLIENT – BON_FISCAL | client – bon_fiscal: **one-to-many** | Un client poate avea mai multe bonuri fiscale sau niciunul. Fiecare bon fiscal aparține unui singur client. |
| **conține / apare în**: BON_FISCAL – PRODUS_MAGAZIN | bon_fiscal – produs_magazin: **many-to-many** | Relația este rezolvată prin tabelul asociativ **ARTICOL_BON**. Un bon poate conține mai multe produse, iar un produs poate apărea pe mai multe bonuri. |
| **realizează**: FURNIZOR – APROVIZIONARE | furnizor – aprovizionare: **one-to-many** | Un furnizor poate realiza mai multe aprovizionări sau niciuna. Fiecare aprovizionare provine de la un singur furnizor. |
| **aprovizionează / conține**: APROVIZIONARE – PRODUS_MAGAZIN | aprovizionare – produs_magazin: **many-to-many** | Relația este rezolvată prin tabelul asociativ **ARTICOL_APROV_PRODUS**. O aprovizionare poate conține mai multe produse, iar un produs poate apărea în mai multe aprovizionări. |
| **livrare_carburant**: STAȚIE – FURNIZOR – TIP_CARBURANT | stație – furnizor – tip_carburant: **many-to-many-to-many** | Relație ternară, de aritate 3, rezolvată prin entitatea asociativă **LIVRARE_CARBURANT**. O livrare leagă o singură stație, un singur furnizor și un singur tip de carburant. |
| **lucrează în**: ANGAJAT – TURĂ | angajat – tură: **many-to-many** | Relația este rezolvată prin tabelul asociativ **PROGRAMARE_TURA**. Un angajat poate lucra în mai multe ture, iar într-o tură pot lucra mai mulți angajați. |
| **este**: ANGAJAT – CASIER | angajat – casier: **one-to-zero-or-one** | Relație superentitate–subentitate. Fiecare casier trebuie să existe mai întâi ca angajat. Un angajat poate fi sau nu casier. |
| **este**: ANGAJAT – OPERATOR_POMPĂ | angajat – operator_pompă: **one-to-zero-or-one** | Relație superentitate–subentitate. Fiecare operator pompă trebuie să existe mai întâi ca angajat. Un angajat poate fi sau nu operator pompă. |
| **este**: ANGAJAT – RESPONSABIL_STOC | angajat – responsabil_stoc: **one-to-zero-or-one** | Relație superentitate–subentitate. Fiecare responsabil de stoc trebuie să existe mai întâi ca angajat. Un angajat poate fi sau nu responsabil stoc. |



## 6. Realizarea diagramei entitate-relație

![ER Diagram](resurse/diagrama_er.png)

## 7. Realizarea diagramei conceptuale

![Diagrama conceptuală](resurse/diagrama_conceptuala.png)