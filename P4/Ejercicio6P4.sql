/* Ejercicio 1

Ejercicio 6
Técnico = (codTec, nombre, especialidad) // técnicos
Repuesto = (codRep, nombre, stock, precio) // repuestos
RepuestoReparacion = (nroReparac (fk), codRep (fk), cantidad, precio) // repuestos utilizados en
reparaciones.
Reparación (nroReparac, codTec (fk), precio_total, fecha) // reparaciones realizadas.

*/

-- 1. Listar los repuestos, informando el nombre, stock y precio. Ordenar el resultado por precio.

select r.nombre,r.stock,r.precio
FROM Repuesto r
ORDER BY r.precio

-- 2. Listar nombre, stock y precio de repuestos que se usaron en reparaciones durante 2023 y que no
-- se usaron en reparaciones del técnico ‘José Gonzalez’.

select r.nombre,r.stock,r.precio
FROM Repuesto r
INNER JOIN RepuestoReparacion rr ON (r.codRep=rr.codRep)
INNER JOIN Reparacion rep ON (rep.numReparacion=rr.numReparacion)
INNER JOIN Tecnico t ON (rep.codTec=t.codTec)
WHERE rep.fecha BETWEEN ('2023-01-01'and'2023-12-31')
EXCEPT(
select r.nombre,r.stock,r.precio
FROM Repuesto r
INNER JOIN RepuestoReparacion rr ON (r.codRep=rr.codRep)
INNER JOIN Reparacion rep ON (rep.numReparacion=rr.numReparacion)
INNER JOIN Tecnico t ON (rep.codTec=t.codTec)
WHERE t.nombre='José Gonazalez'
)

-- 3. Listar el nombre y especialidad de técnicos que no participaron en ninguna reparación. Ordenar
-- por nombre ascendentemente.

select t.nombre,t.especialidad
FROM Tecnico t
LEFT JOIN Reparacion rep (rep.codTec=t.codTec)
GROUP BY t.codTec,t.nombre,t.especialidad
WHERE rep.nroReparac IS NULL
ORDER BY t.nombre ASC

-- 4. Listar el nombre y especialidad de los técnicos que solamente participaron en reparaciones en 2022
select DISTINCT t.nombre,t.especialidad
FROM Tecnico t
INNER JOIN Reparacion rep ON (rep.codTec=t.codTec)
WHERE rep.fecha BETWEEN '2022-01-01' AND '2022-12-31'
EXCEPT(
select DISTINCT t.nombre,t.especialidad
FROM Tecnico t
INNER JOIN Reparacion rep ON (rep.codTec=t.codTec)
WHERE rep.fecha<'2022-01-01'or rep.fecha>'2022-12-31'
)

-- 5. Listar para cada repuesto nombre, stock y cantidad de técnicos distintos que lo utilizaron. Si un
-- repuesto no participó en alguna reparación igual debe aparecer en dicho listado

SELECT r.nombre,r.stock, COUNT(DISTINCT t.codTec) as cantidadTecnicos
FROM Repuesto r
LEFT JOIN RepuestoReparacion rr ON (r.codRep=rr.codRep)
LEFT JOIN Reparacion rep ON (rep.nroReparac=rr.nroReparac)
LEFT JOIN Tecnicos t ON (rep.codTec=t.codTec)
GROUP BY r.codRep,r.codNombre,r.stock.

-- 6. Listar nombre y especialidad del técnico con mayor cantidad de reparaciones realizadas y el
-- técnico con menor cantidad de reparaciones.

select t.nombre,t.especialidad
FROM Tecnico t
INNER JOIN Reparacion rep ON (rep.codTec=t.codTec)
GROUP BY t.codTec,t.nombre,t.especialidad
HAVING COUNT(rep.nroReparacion)>=ALL(
  select COUNT(rep.nroReparacion)
  FROM Tecnico t
  INNER JOIN Reparacion rep ON (rep.codTec=t.codTec)
  GROUP BY t.codTec
)
UNION(
select t.nombre,t.especialidad
FROM Tecnico t
INNER JOIN Reparacion rep ON (rep.codTec=t.codTec)
GROUP BY t.codTec,t.nombre,t.especialidad
HAVING COUNT(rep.nroReparacion)<=ALL(
  select COUNT(rep.nroReparacion)
  FROM Tecnico t
  INNER JOIN Reparacion rep ON (rep.codTec=t.codTec)
  GROUP BY t.codTec
)
)

-- 7. Listar nombre, stock y precio de todos los repuestos con stock mayor a 0 y que dicho repuesto
-- no haya estado en reparaciones con un precio total superior a $10000.

select r.nombre,r.stock,r.precio
FROM Repuesto r 
INNER JOIN RepuestoReparacion rr ON (rr.codRep=r.codRep)
INNER JOIN Reparacion rep ON (rr.nroReparac=rep.nroReparac)
WHERE r.stock>0
EXCEPT(
select r.nombre,r.stock,r.precio
FROM Repuesto r 
INNER JOIN RepuestoReparacion rr ON (rr.codRep=r.codRep)
INNER JOIN Reparacion rep ON (rr.nroReparac=rep.nroReparac)
WHERE rep.precio_total>10000
)

-- 8. Proyectar número, fecha y precio total de aquellas reparaciones donde se utilizó algún repuesto
-- con precio en el momento de la reparación mayor a $10000 y menor a $15000.

select rep.nroReparac,rep.fecha,rep.precio_total
FROM Reparacion rep
INNER JOIN RepuestoReparacion rr ON (rep.nroReparac=rr.nroReparacion)
INNER JOIN Repuesto r ON (r.codRep=rr.codRep)
WHERE rr.precio>10000 and rr.precio<15000

-- 9. Listar nombre, stock y precio de repuestos que hayan sido utilizados por todos los técnicos.

select r.nombre,r.stock,r.precio
FROM Repuesto r
WHERE NOT EXISTS(
   select t.codTec
   FROM Tecnico t
   WHERE NOT EXISTS(
     select rr.codRep
     FROM RepuestoReparacion rr
     INNER JOIN Reparacion rep ON (rep.nroReparac=rr.nroReparac)
     WHERE rr.codRep=r.codRep and rep.codTec=t.codTec
   )
  )


  -- 10. Listar fecha, técnico y precio total de aquellas reparaciones que necesitaron al menos 10 repuestos distintos
 
 select rep.fecha,rep.precio_total,t.nombre
 FROM Reparacion rep
 INNER JOIN Tecnico t ON (t.codTec=rep.codTec)
 INNER JOIN RepuestoReparacion rr ON (rr.nroReparac=rep.nroReparac)
 INNER JOIN Repuesto r ON (r.codRep=rr.codRep)
 GROUP BY rep.nroReparacion,rep.fecha,rep.precio_total,t.nombre
 HAVING COUNT(DISTINCT r.codRep)>=10