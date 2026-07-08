DROP TABLE LIVRARE_CARBURANT;
DROP TABLE ARTICOL_APROV_PRODUS;
DROP TABLE APROVIZIONARE;
DROP TABLE ARTICOL_BON;
DROP TABLE ALIMENTARE;
DROP TABLE BON_FISCAL;
DROP TABLE PROGRAMARE_TURA;
DROP TABLE PISTOL_POMPA;
DROP TABLE CASIER;
DROP TABLE OPERATOR_POMPA;
DROP TABLE RESPONSABIL_STOC;
DROP TABLE ANGAJAT;
DROP TABLE POMPA;
DROP TABLE PRODUS_MAGAZIN;
DROP TABLE TURA;
DROP TABLE CLIENT;
DROP TABLE FURNIZOR;
DROP TABLE TIP_CARBURANT;
DROP TABLE STATIE;


DROP SEQUENCE seq_statie;
DROP SEQUENCE seq_tip_carburant;
DROP SEQUENCE seq_pompa;
DROP SEQUENCE seq_pistol_pompa;
DROP SEQUENCE seq_client;
DROP SEQUENCE seq_angajat;
DROP SEQUENCE seq_tura;
DROP SEQUENCE seq_bon_fiscal;
DROP SEQUENCE seq_alimentare;
DROP SEQUENCE seq_produs_magazin;
DROP SEQUENCE seq_furnizor;
DROP SEQUENCE seq_aprovizionare;
DROP SEQUENCE seq_livrare_carburant;


CREATE SEQUENCE seq_statie START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_tip_carburant START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_pompa START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_pistol_pompa START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_client START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_angajat START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_tura START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_bon_fiscal START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_alimentare START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_produs_magazin START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_furnizor START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_aprovizionare START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_livrare_carburant START WITH 1 INCREMENT BY 1;


CREATE TABLE STATIE (
    id_statie NUMBER(10) DEFAULT seq_statie.NEXTVAL,
    denumire VARCHAR2(100) CONSTRAINT nn_statie_denumire NOT NULL,
    adresa VARCHAR2(150) CONSTRAINT nn_statie_adresa NOT NULL,
    oras VARCHAR2(50) CONSTRAINT nn_statie_oras NOT NULL,
    telefon VARCHAR2(15),
    CONSTRAINT pk_statie PRIMARY KEY (id_statie)
);

CREATE TABLE TIP_CARBURANT (
    id_tip_carburant NUMBER(10) DEFAULT seq_tip_carburant.NEXTVAL,
    denumire VARCHAR2(50) CONSTRAINT nn_tip_carburant_denumire NOT NULL,
    pret_litru NUMBER(6,2) CONSTRAINT nn_tip_carburant_pret NOT NULL,
    CONSTRAINT pk_tip_carburant PRIMARY KEY (id_tip_carburant),
    CONSTRAINT uk_tip_carburant_denumire UNIQUE (denumire),
    CONSTRAINT ck_tip_carburant_pret CHECK (pret_litru > 0)
);

CREATE TABLE CLIENT (
    id_client NUMBER(10) DEFAULT seq_client.NEXTVAL,
    nume VARCHAR2(50) CONSTRAINT nn_client_nume NOT NULL,
    prenume VARCHAR2(50) CONSTRAINT nn_client_prenume NOT NULL,
    telefon VARCHAR2(15),
    CONSTRAINT pk_client PRIMARY KEY (id_client)
);

CREATE TABLE FURNIZOR (
    id_furnizor NUMBER(10) DEFAULT seq_furnizor.NEXTVAL,
    denumire VARCHAR2(100) CONSTRAINT nn_furnizor_denumire NOT NULL,
    telefon VARCHAR2(15),
    email VARCHAR2(100),
    CONSTRAINT pk_furnizor PRIMARY KEY (id_furnizor)
);

CREATE TABLE TURA (
    id_tura NUMBER(10) DEFAULT seq_tura.NEXTVAL,
    denumire VARCHAR2(30) CONSTRAINT nn_tura_denumire NOT NULL,
    ora_inceput VARCHAR2(5) CONSTRAINT nn_tura_ora_inceput NOT NULL,
    ora_sfarsit VARCHAR2(5) CONSTRAINT nn_tura_ora_sfarsit NOT NULL,
    CONSTRAINT pk_tura PRIMARY KEY (id_tura)
);

CREATE TABLE POMPA (
    id_pompa NUMBER(10) DEFAULT seq_pompa.NEXTVAL,
    id_statie NUMBER(10) CONSTRAINT nn_pompa_statie NOT NULL,
    numar_pompa NUMBER(3) CONSTRAINT nn_pompa_numar NOT NULL,
    stare VARCHAR2(20) DEFAULT 'functionala' CONSTRAINT nn_pompa_stare NOT NULL,
    CONSTRAINT pk_pompa PRIMARY KEY (id_pompa),
    CONSTRAINT fk_pompa_statie FOREIGN KEY (id_statie) REFERENCES STATIE(id_statie),
    CONSTRAINT ck_pompa_stare CHECK (stare IN ('functionala', 'defecta', 'revizie')),
    CONSTRAINT uk_pompa_statie_numar UNIQUE (id_statie, numar_pompa)
);

CREATE TABLE ANGAJAT (
    id_angajat NUMBER(10) DEFAULT seq_angajat.NEXTVAL,
    id_statie NUMBER(10) CONSTRAINT nn_angajat_statie NOT NULL,
    nume VARCHAR2(50) CONSTRAINT nn_angajat_nume NOT NULL,
    prenume VARCHAR2(50) CONSTRAINT nn_angajat_prenume NOT NULL,
    telefon VARCHAR2(15),
    salariu NUMBER(8,2),
    data_angajare DATE DEFAULT SYSDATE CONSTRAINT nn_angajat_data NOT NULL,
    CONSTRAINT pk_angajat PRIMARY KEY (id_angajat),
    CONSTRAINT fk_angajat_statie FOREIGN KEY (id_statie) REFERENCES STATIE(id_statie),
    CONSTRAINT ck_angajat_salariu CHECK (salariu > 0)
);

CREATE TABLE CASIER (
    id_angajat NUMBER(10),
    numar_casa NUMBER(2) CONSTRAINT nn_casier_numar_casa NOT NULL,
    CONSTRAINT pk_casier PRIMARY KEY (id_angajat),
    CONSTRAINT fk_casier_angajat FOREIGN KEY (id_angajat) REFERENCES ANGAJAT(id_angajat)
);

CREATE TABLE OPERATOR_POMPA (
    id_angajat NUMBER(10),
    zona_responsabilitate VARCHAR2(50),
    CONSTRAINT pk_operator_pompa PRIMARY KEY (id_angajat),
    CONSTRAINT fk_operator_angajat FOREIGN KEY (id_angajat) REFERENCES ANGAJAT(id_angajat)
);

CREATE TABLE RESPONSABIL_STOC (
    id_angajat NUMBER(10),
    sector_stoc VARCHAR2(50) DEFAULT 'magazin',
    CONSTRAINT pk_responsabil_stoc PRIMARY KEY (id_angajat),
    CONSTRAINT fk_responsabil_angajat FOREIGN KEY (id_angajat) REFERENCES ANGAJAT(id_angajat)
);

CREATE TABLE PISTOL_POMPA (
    id_pistol_pompa NUMBER(10) DEFAULT seq_pistol_pompa.NEXTVAL,
    id_pompa NUMBER(10) CONSTRAINT nn_pistol_pompa_pompa NOT NULL,
    id_tip_carburant NUMBER(10) CONSTRAINT nn_pistol_tip_carburant NOT NULL,
    numar_pistol NUMBER(2) CONSTRAINT nn_pistol_numar NOT NULL,
    stare VARCHAR2(20) DEFAULT 'functional' CONSTRAINT nn_pistol_stare NOT NULL,
    CONSTRAINT pk_pistol_pompa PRIMARY KEY (id_pistol_pompa),
    CONSTRAINT fk_pistol_pompa FOREIGN KEY (id_pompa) REFERENCES POMPA(id_pompa),
    CONSTRAINT fk_pistol_tip_carburant FOREIGN KEY (id_tip_carburant) REFERENCES TIP_CARBURANT(id_tip_carburant),
    CONSTRAINT ck_pistol_stare CHECK (stare IN ('functional', 'defect')),
    CONSTRAINT uk_pistol_pompa_numar UNIQUE (id_pompa, numar_pistol)
);

CREATE TABLE PROGRAMARE_TURA (
    id_angajat NUMBER(10),
    id_tura NUMBER(10),
    data_programare DATE CONSTRAINT nn_programare_data NOT NULL,
    CONSTRAINT pk_programare_tura PRIMARY KEY (id_angajat, id_tura),
    CONSTRAINT fk_programare_angajat FOREIGN KEY (id_angajat) REFERENCES ANGAJAT(id_angajat),
    CONSTRAINT fk_programare_tura FOREIGN KEY (id_tura) REFERENCES TURA(id_tura)
);

CREATE TABLE BON_FISCAL (
    id_bon NUMBER(10) DEFAULT seq_bon_fiscal.NEXTVAL,
    id_client NUMBER(10) CONSTRAINT nn_bon_client NOT NULL,
    data_bon DATE DEFAULT SYSDATE CONSTRAINT nn_bon_data NOT NULL,
    metoda_plata VARCHAR2(20) DEFAULT 'card' CONSTRAINT nn_bon_metoda NOT NULL,
    CONSTRAINT pk_bon_fiscal PRIMARY KEY (id_bon),
    CONSTRAINT fk_bon_client FOREIGN KEY (id_client) REFERENCES CLIENT(id_client),
    CONSTRAINT ck_bon_metoda CHECK (metoda_plata IN ('cash', 'card'))
);

CREATE TABLE ALIMENTARE (
    id_alimentare NUMBER(10) DEFAULT seq_alimentare.NEXTVAL,
    id_pistol_pompa NUMBER(10) CONSTRAINT nn_alimentare_pistol NOT NULL,
    id_bon NUMBER(10) CONSTRAINT nn_alimentare_bon NOT NULL,
    cantitate_litri NUMBER(8,2) CONSTRAINT nn_alimentare_cantitate NOT NULL,
    pret_litru NUMBER(6,2) CONSTRAINT nn_alimentare_pret NOT NULL,
    CONSTRAINT pk_alimentare PRIMARY KEY (id_alimentare),
    CONSTRAINT fk_alimentare_pistol FOREIGN KEY (id_pistol_pompa) REFERENCES PISTOL_POMPA(id_pistol_pompa),
    CONSTRAINT fk_alimentare_bon FOREIGN KEY (id_bon) REFERENCES BON_FISCAL(id_bon),
    CONSTRAINT uk_alimentare_bon UNIQUE (id_bon),
    CONSTRAINT ck_alimentare_cantitate CHECK (cantitate_litri > 0),
    CONSTRAINT ck_alimentare_pret CHECK (pret_litru > 0)
);

CREATE TABLE PRODUS_MAGAZIN (
    id_produs_magazin NUMBER(10) DEFAULT seq_produs_magazin.NEXTVAL,
    denumire VARCHAR2(100) CONSTRAINT nn_produs_denumire NOT NULL,
    categorie VARCHAR2(50),
    pret NUMBER(7,2) CONSTRAINT nn_produs_pret NOT NULL,
    stoc NUMBER(6) DEFAULT 0 CONSTRAINT nn_produs_stoc NOT NULL,
    CONSTRAINT pk_produs_magazin PRIMARY KEY (id_produs_magazin),
    CONSTRAINT ck_produs_pret CHECK (pret > 0),
    CONSTRAINT ck_produs_stoc CHECK (stoc >= 0)
);

CREATE TABLE ARTICOL_BON (
    id_bon NUMBER(10),
    id_produs_magazin NUMBER(10),
    cantitate NUMBER(6) DEFAULT 1 CONSTRAINT nn_articol_bon_cantitate NOT NULL,
    pret_unitar NUMBER(7,2) CONSTRAINT nn_articol_bon_pret NOT NULL,
    CONSTRAINT pk_articol_bon PRIMARY KEY (id_bon, id_produs_magazin),
    CONSTRAINT fk_articol_bon_bon FOREIGN KEY (id_bon) REFERENCES BON_FISCAL(id_bon),
    CONSTRAINT fk_articol_bon_produs FOREIGN KEY (id_produs_magazin) REFERENCES PRODUS_MAGAZIN(id_produs_magazin),
    CONSTRAINT ck_articol_bon_cantitate CHECK (cantitate > 0),
    CONSTRAINT ck_articol_bon_pret CHECK (pret_unitar > 0)
);

CREATE TABLE APROVIZIONARE (
    id_aprovizionare NUMBER(10) DEFAULT seq_aprovizionare.NEXTVAL,
    id_furnizor NUMBER(10) CONSTRAINT nn_aprov_furnizor NOT NULL,
    data_aprovizionare DATE DEFAULT SYSDATE CONSTRAINT nn_aprov_data NOT NULL,
    observatii VARCHAR2(200),
    CONSTRAINT pk_aprovizionare PRIMARY KEY (id_aprovizionare),
    CONSTRAINT fk_aprov_furnizor FOREIGN KEY (id_furnizor) REFERENCES FURNIZOR(id_furnizor)
);

CREATE TABLE ARTICOL_APROV_PRODUS (
    id_aprovizionare NUMBER(10),
    id_produs_magazin NUMBER(10),
    cantitate NUMBER(6) CONSTRAINT nn_articol_aprov_cantitate NOT NULL,
    pret_achizitie NUMBER(7,2) CONSTRAINT nn_articol_aprov_pret NOT NULL,
    CONSTRAINT pk_articol_aprov_produs PRIMARY KEY (id_aprovizionare, id_produs_magazin),
    CONSTRAINT fk_articol_aprov_aprov FOREIGN KEY (id_aprovizionare) REFERENCES APROVIZIONARE(id_aprovizionare),
    CONSTRAINT fk_articol_aprov_produs FOREIGN KEY (id_produs_magazin) REFERENCES PRODUS_MAGAZIN(id_produs_magazin),
    CONSTRAINT ck_articol_aprov_cantitate CHECK (cantitate > 0),
    CONSTRAINT ck_articol_aprov_pret CHECK (pret_achizitie > 0)
);

CREATE TABLE LIVRARE_CARBURANT (
    id_livrare_carburant NUMBER(10) DEFAULT seq_livrare_carburant.NEXTVAL,
    id_statie NUMBER(10) CONSTRAINT nn_livrare_statie NOT NULL,
    id_furnizor NUMBER(10) CONSTRAINT nn_livrare_furnizor NOT NULL,
    id_tip_carburant NUMBER(10) CONSTRAINT nn_livrare_tip NOT NULL,
    data_livrare DATE DEFAULT SYSDATE CONSTRAINT nn_livrare_data NOT NULL,
    cantitate_litri NUMBER(10,2) CONSTRAINT nn_livrare_cantitate NOT NULL,
    pret_litru NUMBER(6,2) CONSTRAINT nn_livrare_pret NOT NULL,
    CONSTRAINT pk_livrare_carburant PRIMARY KEY (id_livrare_carburant),
    CONSTRAINT fk_livrare_statie FOREIGN KEY (id_statie) REFERENCES STATIE(id_statie),
    CONSTRAINT fk_livrare_furnizor FOREIGN KEY (id_furnizor) REFERENCES FURNIZOR(id_furnizor),
    CONSTRAINT fk_livrare_tip FOREIGN KEY (id_tip_carburant) REFERENCES TIP_CARBURANT(id_tip_carburant),
    CONSTRAINT ck_livrare_cantitate CHECK (cantitate_litri > 0),
    CONSTRAINT ck_livrare_pret CHECK (pret_litru > 0)
);

INSERT INTO STATIE VALUES (seq_statie.NEXTVAL, 'PetroMax Centru', 'Str. Independentei nr. 10', 'Bucuresti', '0213001001');
INSERT INTO STATIE VALUES (seq_statie.NEXTVAL, 'PetroMax Vest', 'Bd. Timisoara nr. 45', 'Bucuresti', '0213001002');
INSERT INTO STATIE VALUES (seq_statie.NEXTVAL, 'PetroMax Nord', 'Sos. Colentina nr. 82', 'Bucuresti', '0213001003');
INSERT INTO STATIE VALUES (seq_statie.NEXTVAL, 'PetroMax Ploiesti', 'Str. Republicii nr. 12', 'Ploiesti', '0244300104');
INSERT INTO STATIE VALUES (seq_statie.NEXTVAL, 'PetroMax Brasov', 'Calea Bucuresti nr. 88', 'Brasov', '0268300105');

INSERT INTO TIP_CARBURANT VALUES (seq_tip_carburant.NEXTVAL, 'Benzina 95', 7.25);
INSERT INTO TIP_CARBURANT VALUES (seq_tip_carburant.NEXTVAL, 'Benzina 98', 7.85);
INSERT INTO TIP_CARBURANT VALUES (seq_tip_carburant.NEXTVAL, 'Motorina Standard', 7.45);
INSERT INTO TIP_CARBURANT VALUES (seq_tip_carburant.NEXTVAL, 'Motorina Extra', 7.75);
INSERT INTO TIP_CARBURANT VALUES (seq_tip_carburant.NEXTVAL, 'GPL', 3.65);

INSERT INTO CLIENT VALUES (seq_client.NEXTVAL, 'Popescu', 'Andrei', '0711111111');
INSERT INTO CLIENT VALUES (seq_client.NEXTVAL, 'Ionescu', 'Maria', '0722222222');
INSERT INTO CLIENT VALUES (seq_client.NEXTVAL, 'Dumitru', 'George', '0733333333');
INSERT INTO CLIENT VALUES (seq_client.NEXTVAL, 'Stan', 'Elena', '0744444444');
INSERT INTO CLIENT VALUES (seq_client.NEXTVAL, 'Marin', 'Ioana', '0755555555');

INSERT INTO FURNIZOR VALUES (seq_furnizor.NEXTVAL, 'Rompetrol Supply', '0214001001', 'contact@rompetrol-supply.ro');
INSERT INTO FURNIZOR VALUES (seq_furnizor.NEXTVAL, 'OMV Petrom Distributie', '0214001002', 'office@omv-distributie.ro');
INSERT INTO FURNIZOR VALUES (seq_furnizor.NEXTVAL, 'Metro Cash Carry', '0214001003', 'comenzi@metro.ro');
INSERT INTO FURNIZOR VALUES (seq_furnizor.NEXTVAL, 'Aqua Fresh SRL', '0214001004', 'livrari@aquafresh.ro');
INSERT INTO FURNIZOR VALUES (seq_furnizor.NEXTVAL, 'AutoPlus Distribution', '0214001005', 'contact@autoplus.ro');

INSERT INTO TURA VALUES (seq_tura.NEXTVAL, 'dimineata', '06:00', '14:00');
INSERT INTO TURA VALUES (seq_tura.NEXTVAL, 'dupa-amiaza', '14:00', '22:00');
INSERT INTO TURA VALUES (seq_tura.NEXTVAL, 'noapte', '22:00', '06:00');
INSERT INTO TURA VALUES (seq_tura.NEXTVAL, 'weekend zi', '08:00', '20:00');
INSERT INTO TURA VALUES (seq_tura.NEXTVAL, 'weekend noapte', '20:00', '08:00');

INSERT INTO POMPA VALUES (seq_pompa.NEXTVAL, 1, 1, 'functionala');
INSERT INTO POMPA VALUES (seq_pompa.NEXTVAL, 1, 2, 'functionala');
INSERT INTO POMPA VALUES (seq_pompa.NEXTVAL, 2, 1, 'functionala');
INSERT INTO POMPA VALUES (seq_pompa.NEXTVAL, 3, 1, 'revizie');
INSERT INTO POMPA VALUES (seq_pompa.NEXTVAL, 4, 1, 'functionala');

INSERT INTO ANGAJAT VALUES (seq_angajat.NEXTVAL, 1, 'Dumitrescu', 'Alexandru', '0700000001', 4100, DATE '2023-01-15');
INSERT INTO ANGAJAT VALUES (seq_angajat.NEXTVAL, 1, 'Stan', 'Ioana', '0700000002', 3950, DATE '2023-03-10');
INSERT INTO ANGAJAT VALUES (seq_angajat.NEXTVAL, 2, 'Georgescu', 'Mihai', '0700000003', 4200, DATE '2022-11-20');
INSERT INTO ANGAJAT VALUES (seq_angajat.NEXTVAL, 2, 'Marinescu', 'Elena', '0700000004', 3900, DATE '2024-02-01');
INSERT INTO ANGAJAT VALUES (seq_angajat.NEXTVAL, 3, 'Tudor', 'Cristina', '0700000005', 4000, DATE '2024-05-12');

INSERT INTO ANGAJAT VALUES (seq_angajat.NEXTVAL, 1, 'Radu', 'Vlad', '0700000006', 3700, DATE '2023-07-07');
INSERT INTO ANGAJAT VALUES (seq_angajat.NEXTVAL, 2, 'Matei', 'Sorin', '0700000007', 3650, DATE '2023-08-18');
INSERT INTO ANGAJAT VALUES (seq_angajat.NEXTVAL, 3, 'Ilie', 'Bogdan', '0700000008', 3800, DATE '2024-01-25');
INSERT INTO ANGAJAT VALUES (seq_angajat.NEXTVAL, 4, 'Nistor', 'Paul', '0700000009', 3750, DATE '2022-09-11');
INSERT INTO ANGAJAT VALUES (seq_angajat.NEXTVAL, 5, 'Preda', 'Daniel', '0700000010', 3850, DATE '2024-04-30');

INSERT INTO ANGAJAT VALUES (seq_angajat.NEXTVAL, 1, 'Enache', 'Ana', '0700000011', 4500, DATE '2021-06-14');
INSERT INTO ANGAJAT VALUES (seq_angajat.NEXTVAL, 2, 'Voicu', 'Irina', '0700000012', 4550, DATE '2022-05-21');
INSERT INTO ANGAJAT VALUES (seq_angajat.NEXTVAL, 3, 'Mocanu', 'Laura', '0700000013', 4400, DATE '2023-10-03');
INSERT INTO ANGAJAT VALUES (seq_angajat.NEXTVAL, 4, 'Barbu', 'Adrian', '0700000014', 4600, DATE '2021-12-09');
INSERT INTO ANGAJAT VALUES (seq_angajat.NEXTVAL, 5, 'Serban', 'Roxana', '0700000015', 4450, DATE '2024-03-19');

INSERT INTO CASIER VALUES (1, 1);
INSERT INTO CASIER VALUES (2, 2);
INSERT INTO CASIER VALUES (3, 1);
INSERT INTO CASIER VALUES (4, 2);
INSERT INTO CASIER VALUES (5, 1);

INSERT INTO OPERATOR_POMPA VALUES (6, 'pompe 1-2');
INSERT INTO OPERATOR_POMPA VALUES (7, 'pompe 3-4');
INSERT INTO OPERATOR_POMPA VALUES (8, 'zona nord');
INSERT INTO OPERATOR_POMPA VALUES (9, 'zona exterior');
INSERT INTO OPERATOR_POMPA VALUES (10, 'zona GPL');

INSERT INTO RESPONSABIL_STOC VALUES (11, 'magazin');
INSERT INTO RESPONSABIL_STOC VALUES (12, 'depozit');
INSERT INTO RESPONSABIL_STOC VALUES (13, 'magazin');
INSERT INTO RESPONSABIL_STOC VALUES (14, 'produse auto');
INSERT INTO RESPONSABIL_STOC VALUES (15, 'bauturi');

INSERT INTO PISTOL_POMPA VALUES (seq_pistol_pompa.NEXTVAL, 1, 1, 1, 'functional');
INSERT INTO PISTOL_POMPA VALUES (seq_pistol_pompa.NEXTVAL, 1, 3, 2, 'functional');
INSERT INTO PISTOL_POMPA VALUES (seq_pistol_pompa.NEXTVAL, 2, 5, 1, 'functional');
INSERT INTO PISTOL_POMPA VALUES (seq_pistol_pompa.NEXTVAL, 3, 2, 1, 'functional');
INSERT INTO PISTOL_POMPA VALUES (seq_pistol_pompa.NEXTVAL, 4, 4, 1, 'defect');

INSERT INTO PRODUS_MAGAZIN VALUES (seq_produs_magazin.NEXTVAL, 'Apa plata 0.5L', 'bautura', 4.50, 80);
INSERT INTO PRODUS_MAGAZIN VALUES (seq_produs_magazin.NEXTVAL, 'Cafea espresso', 'bautura', 6.00, 100);
INSERT INTO PRODUS_MAGAZIN VALUES (seq_produs_magazin.NEXTVAL, 'Sandvis pui', 'aliment', 14.50, 25);
INSERT INTO PRODUS_MAGAZIN VALUES (seq_produs_magazin.NEXTVAL, 'Odorizant auto', 'auto', 12.00, 40);
INSERT INTO PRODUS_MAGAZIN VALUES (seq_produs_magazin.NEXTVAL, 'Ulei motor 1L', 'auto', 38.00, 20);

INSERT INTO PROGRAMARE_TURA VALUES (1, 1, DATE '2025-05-20');
INSERT INTO PROGRAMARE_TURA VALUES (2, 2, DATE '2025-05-20');
INSERT INTO PROGRAMARE_TURA VALUES (3, 3, DATE '2025-05-21');
INSERT INTO PROGRAMARE_TURA VALUES (4, 4, DATE '2025-05-21');
INSERT INTO PROGRAMARE_TURA VALUES (5, 5, DATE '2025-05-22');
INSERT INTO PROGRAMARE_TURA VALUES (6, 1, DATE '2025-05-22');
INSERT INTO PROGRAMARE_TURA VALUES (7, 2, DATE '2025-05-23');
INSERT INTO PROGRAMARE_TURA VALUES (8, 3, DATE '2025-05-23');
INSERT INTO PROGRAMARE_TURA VALUES (9, 4, DATE '2025-05-24');
INSERT INTO PROGRAMARE_TURA VALUES (10, 5, DATE '2025-05-24');

INSERT INTO BON_FISCAL VALUES (seq_bon_fiscal.NEXTVAL, 1, DATE '2025-05-20', 'card');
INSERT INTO BON_FISCAL VALUES (seq_bon_fiscal.NEXTVAL, 2, DATE '2025-05-20', 'cash');
INSERT INTO BON_FISCAL VALUES (seq_bon_fiscal.NEXTVAL, 3, DATE '2025-05-21', 'card');
INSERT INTO BON_FISCAL VALUES (seq_bon_fiscal.NEXTVAL, 4, DATE '2025-05-22', 'card');
INSERT INTO BON_FISCAL VALUES (seq_bon_fiscal.NEXTVAL, 5, DATE '2025-05-23', 'cash');

INSERT INTO ALIMENTARE VALUES (seq_alimentare.NEXTVAL, 1, 1, 35.40, 7.25);
INSERT INTO ALIMENTARE VALUES (seq_alimentare.NEXTVAL, 2, 2, 42.00, 7.45);
INSERT INTO ALIMENTARE VALUES (seq_alimentare.NEXTVAL, 3, 3, 28.50, 3.65);
INSERT INTO ALIMENTARE VALUES (seq_alimentare.NEXTVAL, 4, 4, 31.20, 7.85);
INSERT INTO ALIMENTARE VALUES (seq_alimentare.NEXTVAL, 5, 5, 50.00, 7.75);

INSERT INTO ARTICOL_BON VALUES (1, 1, 2, 4.50);
INSERT INTO ARTICOL_BON VALUES (1, 2, 1, 6.00);
INSERT INTO ARTICOL_BON VALUES (2, 2, 2, 6.00);
INSERT INTO ARTICOL_BON VALUES (2, 3, 1, 14.50);
INSERT INTO ARTICOL_BON VALUES (3, 1, 1, 4.50);
INSERT INTO ARTICOL_BON VALUES (3, 4, 1, 12.00);
INSERT INTO ARTICOL_BON VALUES (4, 3, 2, 14.50);
INSERT INTO ARTICOL_BON VALUES (4, 5, 1, 38.00);
INSERT INTO ARTICOL_BON VALUES (5, 1, 3, 4.50);
INSERT INTO ARTICOL_BON VALUES (5, 5, 1, 38.00);

INSERT INTO APROVIZIONARE VALUES (seq_aprovizionare.NEXTVAL, 3, DATE '2025-05-15', 'produse alimentare pentru magazin');
INSERT INTO APROVIZIONARE VALUES (seq_aprovizionare.NEXTVAL, 4, DATE '2025-05-16', 'bauturi si apa imbuteliata');
INSERT INTO APROVIZIONARE VALUES (seq_aprovizionare.NEXTVAL, 5, DATE '2025-05-17', 'produse auto');
INSERT INTO APROVIZIONARE VALUES (seq_aprovizionare.NEXTVAL, 3, DATE '2025-05-18', 'reaprovizionare magazin');
INSERT INTO APROVIZIONARE VALUES (seq_aprovizionare.NEXTVAL, 5, DATE '2025-05-19', 'uleiuri si accesorii auto');

INSERT INTO ARTICOL_APROV_PRODUS VALUES (1, 1, 100, 2.10);
INSERT INTO ARTICOL_APROV_PRODUS VALUES (1, 2, 80, 3.00);
INSERT INTO ARTICOL_APROV_PRODUS VALUES (2, 1, 120, 2.00);
INSERT INTO ARTICOL_APROV_PRODUS VALUES (2, 3, 40, 8.50);
INSERT INTO ARTICOL_APROV_PRODUS VALUES (3, 4, 60, 6.20);
INSERT INTO ARTICOL_APROV_PRODUS VALUES (3, 5, 30, 25.00);
INSERT INTO ARTICOL_APROV_PRODUS VALUES (4, 2, 90, 3.10);
INSERT INTO ARTICOL_APROV_PRODUS VALUES (4, 3, 35, 8.70);
INSERT INTO ARTICOL_APROV_PRODUS VALUES (5, 4, 50, 6.40);
INSERT INTO ARTICOL_APROV_PRODUS VALUES (5, 5, 25, 24.50);

INSERT INTO LIVRARE_CARBURANT VALUES (seq_livrare_carburant.NEXTVAL, 1, 1, 1, DATE '2025-05-10', 9000, 6.10);
INSERT INTO LIVRARE_CARBURANT VALUES (seq_livrare_carburant.NEXTVAL, 1, 1, 3, DATE '2025-05-11', 8500, 6.25);
INSERT INTO LIVRARE_CARBURANT VALUES (seq_livrare_carburant.NEXTVAL, 2, 2, 2, DATE '2025-05-12', 7000, 6.60);
INSERT INTO LIVRARE_CARBURANT VALUES (seq_livrare_carburant.NEXTVAL, 2, 2, 4, DATE '2025-05-13', 7500, 6.45);
INSERT INTO LIVRARE_CARBURANT VALUES (seq_livrare_carburant.NEXTVAL, 3, 1, 5, DATE '2025-05-14', 5000, 2.80);
INSERT INTO LIVRARE_CARBURANT VALUES (seq_livrare_carburant.NEXTVAL, 3, 2, 1, DATE '2025-05-15', 8000, 6.12);
INSERT INTO LIVRARE_CARBURANT VALUES (seq_livrare_carburant.NEXTVAL, 4, 1, 3, DATE '2025-05-16', 8200, 6.30);
INSERT INTO LIVRARE_CARBURANT VALUES (seq_livrare_carburant.NEXTVAL, 4, 2, 4, DATE '2025-05-17', 7600, 6.50);
INSERT INTO LIVRARE_CARBURANT VALUES (seq_livrare_carburant.NEXTVAL, 5, 1, 2, DATE '2025-05-18', 6800, 6.55);
INSERT INTO LIVRARE_CARBURANT VALUES (seq_livrare_carburant.NEXTVAL, 5, 2, 5, DATE '2025-05-19', 4500, 2.75);

COMMIT;