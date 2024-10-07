/*
4.1 CRUD de Customer, Staff y Actor
*/

-- Creacion de Nueva Ciudad

INSERT INTO CITY (CITY, COUNTRY_ID) VALUES ('Santiago', 22)

-- Creacion de Nuevas Direcciones
INSERT INTO ADDRESS (ADDRESS, DISTRICT, CITY_ID, POSTAL_CODE, PHONE) VALUES
('875 Padre Hurtado Sur',
'Las Condes',
601,
'7571626',
'6005857000');

INSERT INTO ADDRESS (ADDRESS, DISTRICT, CITY_ID, POSTAL_CODE, PHONE) VALUES
('8750 Francisco Bilbao',
'Las Condes',
601,
'7571699',
'56227636921');


-- Creacion de Staff

INSERT INTO STAFF (FIRST_NAME, LAST_NAME, ADDRESS_ID, EMAIL, STORE_ID, ACTIVE, USERNAME, PASSWORD) VALUES
('Bruce',
'Wayne',
601,
'imbatman@justice_league.org',
1,
FALSE,
'Batman',
'Kill_The Joker');

INSERT INTO STAFF (FIRST_NAME, LAST_NAME, ADDRESS_ID, EMAIL, STORE_ID, ACTIVE, USERNAME, PASSWORD) VALUES
('Barry',
'Allen',
601,
'imfast@justice_league.org',
1,
FALSE,
'Flash',
'Catch_Me_If_U_Can');

-- Creacion de Nueva Tienda

INSERT INTO STORE (MANAGER_STAFF_ID, ADDRESS_ID) VALUES (3,601)

-- Creacion de Nuevos Clientes (Customer)

INSERT INTO CUSTOMER (STORE_ID, FIRST_NAME,LAST_NAME, EMAIL, ADDRESS_ID) VALUES
(3,
'Adam',
'West',
'imnotbatman@pruebas.cl',
607);

INSERT INTO CUSTOMER (STORE_ID, FIRST_NAME,LAST_NAME, EMAIL, ADDRESS_ID) VALUES
(3,
'John',
'Wesley',
'imnotflash@pruebas.cl',
607);

-- Actualiza Direccion de la Tienda
UPDATE STORE SET ADDRESS_ID = 606 WHERE STORE_ID = 3;

-- Actualizacion de Direccion de Staff
UPDATE STAFF SET ADDRESS_ID = 606, ACTIVE = TRUE WHERE STAFF_ID IN (3,4);

-- Actualizacion de Cliente
UPDATE CUSTOMER SET ACTIVE = 1 WHERE CUSTOMER_ID IN (600,601);

-- Borrado de Cliente y Staff
-- No se puede borrar staff que este asociado a una tienda
DELETE FROM CUSTOMER WHERE CUSTOMER_ID = 600;
DELETE FROM STAFF WHERE FIRST_NAME = 'Barry';


-- Querys CRUD Actores
INSERT INTO ACTOR (FIRST_NAME, LAST_NAME) VALUES 
('Adam','West'),
('Burt','Ward');

UPDATE ACTOR SET FIRST_NAME = 'Robin' WHERE FIRST_NAME = 'Burt' and LAST_NAME = 'Ward';

DELETE FROM ACTOR WHERE FIRST_NAME = 'Adam' and LAST_NAME = 'West';

/*
4.2 Listar todas las “rental” con los datos del “customer” dado un año y mes.
*/

SELECT 
	C.CUSTOMER_ID,
	C.FIRST_NAME,
	C.LAST_NAME,
	C.EMAIL,
	COUNT(R.RENTAL_ID) "Cantidad Arriendos",
	EXTRACT(MONTH FROM R.RENTAL_DATE) as "Mes Arriendo",
	EXTRACT(YEAR FROM R.RENTAL_DATE) as "Año Arriendo"
	
FROM
	CUSTOMER C
JOIN
	RENTAL R
ON	R.CUSTOMER_ID = C.CUSTOMER_ID
where EXTRACT(MONTH FROM R.RENTAL_DATE) = 5
and EXTRACT(YEAR FROM R.RENTAL_DATE) = 2005
GROUP BY
	C.CUSTOMER_ID,
	EXTRACT(YEAR FROM R.RENTAL_DATE),
	EXTRACT(MONTH FROM R.RENTAL_DATE),
	C.FIRST_NAME,
	C.LAST_NAME	
ORDER BY
	C.FIRST_NAME,
	C.LAST_NAME,
	"Año Arriendo",
	"Mes Arriendo";

-- Opcion 2
SELECT 
	C.CUSTOMER_ID,
	C.FIRST_NAME,
	C.LAST_NAME,
	C.EMAIL,
	A.PHONE,
	A.ADDRESS Direccion,
	A.DISTRICT,
	COUNT(R.RENTAL_ID) "Cantidad Arriendos",
	EXTRACT(MONTH FROM R.RENTAL_DATE) "Mes Arriendo",
	EXTRACT(YEAR FROM R.RENTAL_DATE) "Año Arriendo"
	
FROM
	CUSTOMER C,
	ADDRESS A,
	RENTAL R
WHERE
	R.CUSTOMER_ID = C.CUSTOMER_ID
AND
	A.ADDRESS_ID = C.ADDRESS_ID
AND
	EXTRACT(MONTH FROM R.RENTAL_DATE) = 5
AND 
	EXTRACT(YEAR FROM R.RENTAL_DATE) = 2005

GROUP BY
	C.CUSTOMER_ID,
	EXTRACT(YEAR FROM R.RENTAL_DATE),
	EXTRACT(MONTH FROM R.RENTAL_DATE),
	C.FIRST_NAME,
	C.LAST_NAME,
	A.ADDRESS, 
	A.DISTRICT, 
	A.PHONE
ORDER BY
	C.FIRST_NAME,
	C.LAST_NAME,
	"Año Arriendo",
	"Mes Arriendo";

/*
4.3 Listar Número, Fecha (payment_date) y Total (amount) de todas las “payment”.
*/

SELECT
	COUNT(PAYMENT_ID) "Cantidad Pagos",
	CAST(PAYMENT_DATE AS DATE) "Fecha Pago",
	SUM(AMOUNT) Total
FROM PAYMENT
GROUP BY
	"Fecha Pago"
ORDER BY
	"Fecha Pago";


/*
4.4 Listar todas las “film” del año 2006 que contengan un (rental_rate) mayor a 4.0.
*/

Select 		
	film_id,
	title,
	rental_rate,
	rating
from
	film 
where 		
	rental_rate > 4.0 
order by 	
	rental_rate, title;

/*
5. 	Realiza un Diccionario de datos que contenga el nombre de las tablas y columnas, 
	si éstas pueden ser nulas, y su tipo de dato correspondiente.
*/

SELECT
    t1.TABLE_NAME AS tabla_nombre,
    t1.COLUMN_NAME AS columna_nombre,
    t1.COLUMN_DEFAULT AS columna_defecto,
    t1.IS_NULLABLE AS columna_nulo,
    t1.DATA_TYPE AS columna_tipo_dato,
    COALESCE(t1.NUMERIC_PRECISION,
    t1.CHARACTER_MAXIMUM_LENGTH) AS columna_longitud,
    PG_CATALOG.COL_DESCRIPTION(t2.OID,
    t1.DTD_IDENTIFIER::int) AS columna_descripcion,
    t1.DOMAIN_NAME AS columna_dominio
FROM 
    INFORMATION_SCHEMA.COLUMNS t1
    INNER JOIN PG_CLASS t2 ON (t2.RELNAME = t1.TABLE_NAME)
WHERE 
    t1.TABLE_SCHEMA = 'public'
ORDER BY
    t1.TABLE_NAME;
