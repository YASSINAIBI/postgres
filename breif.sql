function 1
CREATE or replace FUNCTION chambresRéservées ()
RETURNS TABLE(numc int ,lits int,prix float) as $list$

BEGIN
    RETURN QUERY SELECT
     ch.*
    FROM
     "chambres" AS ch,"reservations" AS r
     WHERE ch."numc"=r."numc" AND EXTRACT(MONTH FROM r.départ) =8
	 GROUP BY ch."numc";
END; 
$list$ LANGUAGE 'plpgsql';

select chambresRéservées()

function 2
CREATE or replace FUNCTION ListClient ()
RETURNS TABLE(numpass int ,nom varchar,ville varchar) as $list$

BEGIN
    RETURN QUERY SELECT
     cl.*
    FROM
     "chambres" AS ch,"reservations" AS r,"clients" AS cl
     WHERE ch."numc"=r."numc" AND r."numpass" = cl."numpass" AND ch."prix">700
	 GROUP BY cl."numpass";
END; 
$list$ LANGUAGE 'plpgsql';

select ListClient()


function 3
CREATE or replace FUNCTION chambresRéservéesParClient ()
RETURNS TABLE(numc int ,lits int,prix real) as $list$

BEGIN
    RETURN QUERY SELECT
     ch.*
    FROM
     "chambres" AS ch,"reservations" AS r,"clients" AS cl
     WHERE ch."numc"=r."numc" AND r."numpass" = cl."numpass" AND cl.nom Like'A%'
	 GROUP BY ch."numc";
END; 
$list$ LANGUAGE 'plpgsql';

SELECT chambresRéservéesParClient()


function 4
CREATE or replace FUNCTION clientsRéservées ()
RETURNS TABLE(numpass int ,nom varchar,ville varchar) as $list$

BEGIN
    RETURN QUERY SELECT 
     cl.*
    FROM
     "chambres" AS ch,"reservations" AS r,"clients" AS cl
     WHERE ch."numc"= r."numc" AND r."numpass" = cl."numpass" 
	 GROUP BY cl."numpass"
	having count(ch."numc")<=2;
END; 
$list$ LANGUAGE 'plpgsql';

SELECT clientsRéservées()


function 5
CREATE or replace FUNCTION clientsHabitent ()
RETURNS TABLE(numpass int ,nom varchar,ville varchar) as $list$

BEGIN
    RETURN QUERY SELECT 
     cl.*
    FROM
     "chambres" AS ch,"reservations" AS r,"clients" AS cl
     WHERE ch."numc"= r."numc" AND r."numpass" = cl."numpass" AND cl."ville"='Agadir' 
	 GROUP BY cl."numpass"
	having count(ch."numc")>2 AND count(r."numpass")>2 ;
END; 
$list$ LANGUAGE 'plpgsql';

SELECT clientsHabitent()


create or replace procedure ModifierPrix()
language plpgsql    
as $update$
begin
    -- subtracting the amount from the sender's account 
    update "chambres" 
    set prix = 1000 
    where prix >= 700;
end;$update$

CALL ModifierPrix()


create or replace procedure supprimerClient()
language plpgsql    
as $delete$
begin
    -- subtracting the amount from the sender's account 
    delete from "clients" WHERE "clients"."numpass" Not in(select "numpass" FROM "reservations" );
end;$delete$

CALL supprimerClient()



create or replace procedure ModifierPrixPourLits()
language plpgsql    
as $updatePrice$
begin
    -- subtracting the amount from the sender's account 
    update "chambres" 
    set prix = prix - 100
    where lits > 1;
end;$updatePrice$

CALL ModifierPrixPourLits()
