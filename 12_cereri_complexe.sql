-- Cererea 1
-- Să se afișeze alimentările a căror cantitate de carburant este mai mare 
-- sau egală cu media cantităților alimentate pentru același tip de 
-- carburant, în aceeași stație.

SELECT
    c.id_client,
    c.nume || ' ' || c.prenume AS client,
    bf.id_bon,
    s.denumire AS statie,
    p.numar_pompa,
    tc.denumire AS carburant,
    a.cantitate_litri,
    a.pret_litru,
    ROUND(a.cantitate_litri * a.pret_litru, 2) AS valoare_alimentare
FROM client c
JOIN bon_fiscal bf
    ON bf.id_client = c.id_client
JOIN alimentare a
    ON a.id_bon = bf.id_bon
JOIN pistol_pompa pp
    ON pp.id_pistol_pompa = a.id_pistol_pompa
JOIN pompa p
    ON p.id_pompa = pp.id_pompa
JOIN statie s
    ON s.id_statie = p.id_statie
JOIN tip_carburant tc
    ON tc.id_tip_carburant = pp.id_tip_carburant
WHERE a.cantitate_litri >= (
    SELECT AVG(a2.cantitate_litri)
    FROM alimentare a2
    JOIN pistol_pompa pp2
        ON pp2.id_pistol_pompa = a2.id_pistol_pompa
    JOIN pompa p2
        ON p2.id_pompa = pp2.id_pompa
    JOIN tip_carburant tc2
        ON tc2.id_tip_carburant = pp2.id_tip_carburant
    WHERE p2.id_statie = p.id_statie
      AND tc2.id_tip_carburant = tc.id_tip_carburant
)
ORDER BY
    s.denumire,
    tc.denumire,
    a.cantitate_litri DESC;

------------------------------------------------------------------
-- Cererea 2
-- Să se afișeze, pentru fiecare client, numărul de bonuri, valoarea totală
-- a alimentărilor, valoarea totală a produselor cumpărate și valoarea 
-- totală generală. Pentru clienții fără anumite valori se va afișa 0. 
-- Statusul clientului se va determina folosind DECODE.

SELECT
    c.id_client,
    INITCAP(c.nume || ' ' || c.prenume) AS client,
    COUNT(bf.id_bon) AS nr_bonuri,
    NVL(SUM(va.valoare_alimentare), 0) AS total_carburant,
    NVL(SUM(vp.valoare_produse), 0) AS total_produse,
    NVL(SUM(va.valoare_alimentare), 0)
        + NVL(SUM(vp.valoare_produse), 0) AS total_general,
    DECODE(
        COUNT(bf.id_bon),
        0, 'fara bonuri',
        DECODE(
            SIGN(NVL(SUM(va.valoare_alimentare), 0)),
            0, 'doar produse magazin',
            'are alimentari'
        )
    ) AS status_client
FROM client c
LEFT JOIN bon_fiscal bf
    ON bf.id_client = c.id_client
LEFT JOIN (
    SELECT
        id_bon,
        SUM(cantitate_litri * pret_litru) AS valoare_alimentare
    FROM alimentare
    GROUP BY id_bon
) va
    ON va.id_bon = bf.id_bon
LEFT JOIN (
    SELECT
        id_bon,
        SUM(cantitate * pret_unitar) AS valoare_produse
    FROM articol_bon
    GROUP BY id_bon
) vp
    ON vp.id_bon = bf.id_bon
GROUP BY
    c.id_client,
    c.nume,
    c.prenume
ORDER BY
    total_general DESC,
    client ASC;

------------------------------------------------------------------
-- Cererea 3
-- Să se afișeze categoriile de produse din magazin pentru care valoarea totală a
-- vânzărilor este mai mare sau egală cu media valorilor totale ale vânzărilor pe
-- categorii.

SELECT
    NVL(pm.categorie, 'necunoscuta') AS categorie_produs,
    COUNT(DISTINCT pm.id_produs_magazin) AS nr_produse_vandute,
    COUNT(DISTINCT ab.id_bon) AS nr_bonuri,
    SUM(ab.cantitate) AS cantitate_totala,
    ROUND(SUM(ab.cantitate * ab.pret_unitar), 2) AS valoare_totala,
    ROUND(AVG(ab.pret_unitar), 2) AS pret_mediu_vanzare
FROM produs_magazin pm
JOIN articol_bon ab
    ON ab.id_produs_magazin = pm.id_produs_magazin
GROUP BY
    NVL(pm.categorie, 'necunoscuta')
HAVING SUM(ab.cantitate * ab.pret_unitar) >= (
    SELECT AVG(valoare_categorie)
    FROM (
        SELECT
            SUM(ab2.cantitate * ab2.pret_unitar) AS valoare_categorie
        FROM produs_magazin pm2
        JOIN articol_bon ab2
            ON ab2.id_produs_magazin = pm2.id_produs_magazin
        GROUP BY
            NVL(pm2.categorie, 'necunoscuta')
    )
)
ORDER BY
    valoare_totala DESC;

    
------------------------------------------------------------------
-- Cererea 4
-- Să se afișeze bonurile fiscale împreună cu numele clientului formatat, informații
-- despre data emiterii bonului și tipul bonului: bon doar cu alimentare, bon doar
-- cu produse din magazin sau bon mixt.

SELECT
    bf.id_bon,
    UPPER(c.nume) || ' ' || INITCAP(c.prenume) AS client_formatat,
    SUBSTR(NVL(c.telefon, 'fara telefon'), 1, 10) AS telefon_scurt,
    bf.metoda_plata,
    TRUNC(bf.data_bon) AS data_calendaristica,
    TO_CHAR(bf.data_bon, 'FMDay', 'NLS_DATE_LANGUAGE=ROMANIAN') AS zi_saptamana,
    EXTRACT(MONTH FROM bf.data_bon) AS luna_bon,
    ROUND(MONTHS_BETWEEN(SYSDATE, bf.data_bon), 2) AS vechime_luni,
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM alimentare a
            WHERE a.id_bon = bf.id_bon
        )
        AND EXISTS (
            SELECT 1
            FROM articol_bon ab
            WHERE ab.id_bon = bf.id_bon
        )
            THEN 'bon mixt: carburant si produse'
        WHEN EXISTS (
            SELECT 1
            FROM alimentare a
            WHERE a.id_bon = bf.id_bon
        )
            THEN 'bon doar cu alimentare'
        WHEN EXISTS (
            SELECT 1
            FROM articol_bon ab
            WHERE ab.id_bon = bf.id_bon
        )
            THEN 'bon doar cu produse'
        ELSE 'bon fara detalii'
    END AS tip_bon
FROM bon_fiscal bf
JOIN client c
    ON c.id_client = bf.id_client
ORDER BY
    TRUNC(bf.data_bon) DESC,
    UPPER(c.nume),
    INITCAP(c.prenume);

------------------------------------------------------------------
-- Cererea 5
-- Să se afișeze, pentru fiecare stație și fiecare tip de carburant care are
-- activitate, cantitatea totală livrată, cantitatea totală vândută, cantitatea
-- estimată rămasă și profitul brut estimativ.

WITH vanzari_carburant AS (
    SELECT
        p.id_statie,
        pp.id_tip_carburant,
        SUM(a.cantitate_litri) AS litri_vanduti,
        SUM(a.cantitate_litri * a.pret_litru) AS valoare_vanzari
    FROM alimentare a
    JOIN pistol_pompa pp
        ON pp.id_pistol_pompa = a.id_pistol_pompa
    JOIN pompa p
        ON p.id_pompa = pp.id_pompa
    GROUP BY
        p.id_statie,
        pp.id_tip_carburant
),
livrari_carburant AS (
    SELECT
        id_statie,
        id_tip_carburant,
        SUM(cantitate_litri) AS litri_livrati,
        SUM(cantitate_litri * pret_litru) AS cost_livrari
    FROM livrare_carburant
    GROUP BY
        id_statie,
        id_tip_carburant
)
SELECT
    s.denumire AS statie,
    tc.denumire AS carburant,
    NVL(lc.litri_livrati, 0) AS litri_livrati,
    NVL(vc.litri_vanduti, 0) AS litri_vanduti,
    NVL(lc.litri_livrati, 0) - NVL(vc.litri_vanduti, 0) AS litri_ramasi_estimati,
    ROUND(NVL(vc.valoare_vanzari, 0) - NVL(lc.cost_livrari, 0), 2) AS profit_brut_estimativ,
    CASE
        WHEN NVL(lc.litri_livrati, 0) = 0
            THEN 'nu exista livrari'
        WHEN NVL(lc.litri_livrati, 0) - NVL(vc.litri_vanduti, 0) < 0
            THEN 'vanzari peste livrari'
        WHEN NVL(lc.litri_livrati, 0) - NVL(vc.litri_vanduti, 0) <= 1000
            THEN 'stoc estimat redus'
        ELSE 'stoc estimat suficient'
    END AS situatie_carburant
FROM statie s
CROSS JOIN tip_carburant tc
LEFT JOIN vanzari_carburant vc
    ON vc.id_statie = s.id_statie
   AND vc.id_tip_carburant = tc.id_tip_carburant
LEFT JOIN livrari_carburant lc
    ON lc.id_statie = s.id_statie
   AND lc.id_tip_carburant = tc.id_tip_carburant
WHERE NVL(lc.litri_livrati, 0) > 0
   OR NVL(vc.litri_vanduti, 0) > 0
ORDER BY
    s.denumire,
    tc.denumire;