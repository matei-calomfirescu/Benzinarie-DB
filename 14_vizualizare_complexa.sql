------------------------------------------------------
-- Cerinta 14
-- Crearea unei vizualizari complexe

CREATE OR REPLACE VIEW v_alimentari_detaliate AS
SELECT
    a.id_alimentare,
    a.id_bon,
    bf.id_client,
    c.nume || ' ' || c.prenume AS client,
    bf.data_bon,
    bf.metoda_plata,
    s.id_statie,
    s.denumire AS statie,
    p.id_pompa,
    p.numar_pompa,
    pp.id_pistol_pompa,
    pp.numar_pistol,
    tc.id_tip_carburant,
    tc.denumire AS carburant,
    a.cantitate_litri,
    a.pret_litru,
    ROUND(a.cantitate_litri * a.pret_litru, 2) AS valoare_alimentare,
    CASE
        WHEN a.cantitate_litri < 20 THEN 'alimentare mica'
        WHEN a.cantitate_litri BETWEEN 20 AND 40 THEN 'alimentare medie'
        ELSE 'alimentare mare'
    END AS categorie_alimentare
FROM alimentare a
JOIN bon_fiscal bf
    ON bf.id_bon = a.id_bon
JOIN client c
    ON c.id_client = bf.id_client
JOIN pistol_pompa pp
    ON pp.id_pistol_pompa = a.id_pistol_pompa
JOIN pompa p
    ON p.id_pompa = pp.id_pompa
JOIN statie s
    ON s.id_statie = p.id_statie
JOIN tip_carburant tc
    ON tc.id_tip_carburant = pp.id_tip_carburant;

------------------------------------------------------
-- Verificarea vizualizarii

SELECT *
FROM v_alimentari_detaliate;

------------------------------------------------------
-- Operatie LMD permisa pe vizualizare

SAVEPOINT inainte_update_view;

UPDATE v_alimentari_detaliate
SET cantitate_litri = cantitate_litri + 1
WHERE id_alimentare = 1;

SELECT
    id_alimentare,
    cantitate_litri,
    pret_litru,
    valoare_alimentare
FROM v_alimentari_detaliate
WHERE id_alimentare = 1;

ROLLBACK TO inainte_update_view;

------------------------------------------------------
-- Operatie LMD nepermisa pe vizualizare

UPDATE v_alimentari_detaliate
SET valoare_alimentare = 300
WHERE id_alimentare = 1;