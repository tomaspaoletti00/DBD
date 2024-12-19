/*
Ejercicio 3
Banda = (codigoB, nombreBanda, genero_musical, año_creacion)
Integrante = (DNI, nombre, apellido, dirección, email, fecha_nacimiento, codigoB(fk))
Escenario = (nroEscenario, nombre_escenario, ubicación, cubierto, m2, descripción)
Recital = (fecha, hora, nroEscenario (fk), codigoB (fk))

*/

-- 1. Listar DNI, nombre, apellido,dirección y email de integrantes nacidos entre 1980 y 1990 y que
-- hayan realizado algún recital durante 2023.

SELECT i.nombre,i.apellido,i.direccion,i.email
FROM Integrante i
INNER JOIN Banda b ON(b.codigoB=i.codigoB)
INNER JOIN Recital r ON(r.codigoB=b.codigoB)
WHERE (fecha_nacimiento BETWEEN '1980-01-01'and'1990-12-31')and (r.fecha BETWEEN '2023-01-01'and'2023-12-31')

--2. Reportar nombre, género musical y año de creación de bandas que hayan realizado recitales
-- durante 2023, pero no hayan tocado durante 2022 .

SELECT b.nombre,b.genero_musical,b.año_creacion
FROM Banda b
INNER JOIN Recital r ON(b.codigoB=r.codigoB)
WHERE r.fecha BETWEEN  '2023-01-01'and'2023-12-31'
EXCEPT (
 SELECT b.nombre,b.genero_musical,b.año_creacion
 FROM Banda b
 INNER JOIN Recital r ON(b.codigoB=r.codigoB)
 WHERE r.fecha BETWEEN  '2022-01-01'and'2022-12-31'
)

--3. Listar el cronograma de recitales del día 04/12/2023. Se deberá listar nombre de la banda que
--ejecutará el recital, fecha, hora, y el nombre y ubicación del escenario correspondiente.

select b.nombre,r.fecha,r.hora,e.nombre_escenario,e.ubicacion
FROM Recital r
INNER JOIN Banda b ON (b.codigoB=r.codigoB)
INNER JOIN Escenario e ON (e.nroEscenario=r.nroEscenario)
WHERE r.fecha='2023-12-04'

--4. Listar DNI, nombre, apellido,email de integrantes que hayan tocado en el escenario con nombre
--‘Gustavo Cerati’ y en el escenario con nombre ‘Carlos Gardel’.

select i.nombre,i.apellido,i.email,i.DNI
FROM Integrante i
INNER JOIN Banda b ON(b.codigoB=i.codigoB)
INNER JOIN Recital r ON(r.codigoB=b.codigoB)
INNER JOIN Escenario e ON(e.nroEscenario=r.nroEscenario)
WHERE e.nombre_escenario='Gustavo Cerati'
INTERSECT(
    select i.nombre,i.apellido,i.email,i.DNI
    FROM Integrante i
    INNER JOIN Banda b ON(b.codigoB=i.codigoB)
    INNER JOIN Recital r ON(r.codigoB=b.codigoB)
    INNER JOIN Escenario e ON(e.nroEscenario=r.nroEscenario)
    WHERE e.nombre_escenario='CarlosGardel'
) 

-- 5. Reportar nombre, género musical y año de creación de bandas que tengan más de 8 integrantes.

select b.nombre, b.genero_musical, b.año_creacion
FROM Banda b
INNER JOIN Integrante i ON (b.codigoB=i.codigoB)
GROUP BY b.nombre, b.genero_musical, b.año_creacion
HAVING COUNT(i.DNI)>8;

-- 6. Listar nombre de escenario, ubicación y descripción de escenarios que solo tuvieron recitales
-- con el género musical rock and roll. Ordenar por nombre de escenario

select e.nombre_Escenario,e.ubicacion,e.descripcion
From Escenario e
INNER JOIN Recital r ON (r.nroEscenario=e.nroEscenario)
INNER JOIN Banda b on (b.codigoB=r.codigoB)
WHERE b.genero_musical='RockNRoll'
 EXCEPT(
 select e.nombre_Escenario,e.ubicacion,e.descripcion
 From Escenario e
 INNER JOIN Recital r ON (r.nroEscenario=e.nroEscenario)
 INNER JOIN Banda b on (b.codigoB=r.codigoB)
 WHERE b.genero_musical<>'RockNRoll'
 )
ORDER BY e.nombre_escenario

-- 7. Listar nombre, género musical y año de creación de bandas que hayan realizado recitales en
-- escenarios cubiertos durante 2023.// cubierto es true, false según corresponda.

select b.nombre, b.genero_musical, b.año_creacion
FROM Banda b
INNER JOIN Recital r ON (r.codigoB=b.codigoB)
INNER JOIN Escenario e ON (e.nroEscenario=r.nroEscenario)
WHERE r.fecha BETWEEN ('2023-01-01'and'2023-12-31')and e.cubierto=true

-- 8. Reportar para cada escenario, nombre del escenario y cantidad de recitales durante 2024.
select e.nombre_escenario, COUNT(*)
FROM Escenario e
INNER JOIN Recital r ON (r.nroEscenario=e.nroEscenario)
WHERE r.fecha BETWEEN ('2024-01-01'and'2024-12-31')
GROUP BY e.nroEscenario, e.nombre_escenario

-- 9. Modificar el nombre de la banda ‘Mempis la Blusera’ a: ‘Memphis la Blusera’.

UPDATE BANDA 
SET nombreBanda='Memphis la Blusera'
WHERE nombreBanda='Mempis la Blusera'





