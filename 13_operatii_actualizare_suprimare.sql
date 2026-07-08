SAVEPOINT inainte_op1;

-- Operația 1
-- Să se actualizeze prețul curent al fiecărui tip de carburant care a fost
-- livrat cel puțin o dată. Noul preț se calculează ca media prețurilor de 
-- livrare pentru acel carburant, la care se adaugă un adaos comercial de 
-- 15%.

UPDATE tip_carburant tc
SET tc.pret_litru = (
    SELECT ROUND(AVG(lc.pret_litru) * 1.15, 2)
    FROM livrare_carburant lc
    WHERE lc.id_tip_carburant = tc.id_tip_carburant
)
WHERE tc.id_tip_carburant IN (
    SELECT DISTINCT lc2.id_tip_carburant
    FROM livrare_carburant lc2
);

ROLLBACK TO inainte_op1;

------------------------------------------------------
SAVEPOINT inainte_op2;

-- Operația 2
-- Să se treacă în starea `revizie` pompele funcționale pentru care cantitatea 
-- totală de carburant vândută este mai mare decât media cantităților 
-- totale vândute pe pompă.

UPDATE pompa p
SET p.stare = 'revizie'
WHERE p.stare = 'functionala'
  AND p.id_pompa IN (
    SELECT pp.id_pompa
    FROM pistol_pompa pp
    JOIN alimentare a
        ON a.id_pistol_pompa = pp.id_pistol_pompa
    GROUP BY pp.id_pompa
    HAVING SUM(a.cantitate_litri) > (
        SELECT AVG(total_litri_pompa)
        FROM (
            SELECT
                pp2.id_pompa,
                SUM(a2.cantitate_litri) AS total_litri_pompa
            FROM pistol_pompa pp2
            JOIN alimentare a2
                ON a2.id_pistol_pompa = pp2.id_pistol_pompa
            GROUP BY pp2.id_pompa
        )
    )
);

ROLLBACK TO inainte_op2;

------------------------------------------------------
SAVEPOINT inainte_op3;

-- Operația 3
-- Să se șteargă programările mai vechi decât cea mai recentă programare 
-- existentă în tabel, dar numai pentru angajații care au salariul mai mic decât 
-- salariul mediu al tuturor angajaților.

DELETE FROM programare_tura pt
WHERE pt.data_programare < (
    SELECT MAX(pt2.data_programare)
    FROM programare_tura pt2
)
AND pt.id_angajat IN (
    SELECT a.id_angajat
    FROM angajat a
    WHERE a.salariu < (
        SELECT AVG(a2.salariu)
        FROM angajat a2
    )
);

ROLLBACK;