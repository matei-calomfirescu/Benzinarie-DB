------------------------------------------------------------
-- Cererea 1 - Outer-join pe minimum 4 tabele
-- Să se afișeze toate stațiile și angajații acestora, împreună cu
-- programarea în tură și casa de marcat, dacă angajatul este casier.
-- Se vor afișa și stațiile fără angajați, angajații fără programare
-- și angajații care nu sunt casieri.

-- Tabele folosite: STATIE, ANGAJAT, PROGRAMARE_TURA, TURA, CASIER.
-- Tip de join: LEFT JOIN.

SELECT
    s.id_statie,
    s.denumire AS statie,
    a.id_angajat,
    a.nume || ' ' || a.prenume AS angajat,
    NVL(t.denumire, 'fara tura') AS tura,
    pt.data_programare,
    NVL(TO_CHAR(ca.numar_casa), 'nu este casier') AS casa_de_marcat
FROM statie s
LEFT JOIN angajat a
    ON a.id_statie = s.id_statie
LEFT JOIN programare_tura pt
    ON pt.id_angajat = a.id_angajat
LEFT JOIN tura t
    ON t.id_tura = pt.id_tura
LEFT JOIN casier ca
    ON ca.id_angajat = a.id_angajat
ORDER BY
    s.denumire,
    a.nume,
    a.prenume;

------------------------------------------------------------
-- Cererea 2 - Division
-- Să se afișeze tipurile de carburant care au fost livrate de toți
-- furnizorii care au efectuat cel puțin o livrare de carburant.

-- Operația division este implementată prin dublu NOT EXISTS.

SELECT
    tc.id_tip_carburant,
    tc.denumire AS carburant
FROM tip_carburant tc
WHERE NOT EXISTS (
    SELECT 1
    FROM (
        SELECT DISTINCT id_furnizor
        FROM livrare_carburant
    ) f_carburant
    WHERE NOT EXISTS (
        SELECT 1
        FROM livrare_carburant lc
        WHERE lc.id_tip_carburant = tc.id_tip_carburant
          AND lc.id_furnizor = f_carburant.id_furnizor
    )
)
ORDER BY
    tc.denumire;

------------------------------------------------------------
-- Cererea 3 - Analiză top-n
-- Să se afișeze primele 3 produse din magazin după valoarea totală
-- a vânzărilor.

-- Analiza top-n este implementată printr-o subcerere ordonată și ROWNUM.

SELECT *
FROM (
    SELECT
        pm.id_produs_magazin,
        pm.denumire AS produs,
        pm.categorie,
        SUM(ab.cantitate) AS cantitate_totala_vanduta,
        ROUND(SUM(ab.cantitate * ab.pret_unitar), 2) AS valoare_totala_vanzari
    FROM produs_magazin pm
    JOIN articol_bon ab
        ON ab.id_produs_magazin = pm.id_produs_magazin
    GROUP BY
        pm.id_produs_magazin,
        pm.denumire,
        pm.categorie
    ORDER BY
        valoare_totala_vanzari DESC
)
WHERE ROWNUM <= 3;