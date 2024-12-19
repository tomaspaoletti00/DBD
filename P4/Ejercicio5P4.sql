/* Ejercicio 5


AGENCIA = (RAZON_SOCIAL, dirección, telef, e-mail)
CIUDAD = (CODIGOPOSTAL, nombreCiudad, añoCreación)
CLIENTE = (DNI, nombre, apellido, teléfono, dirección)
VIAJE = (FECHA, HORA, DNI (fk), cpOrigen(fk), cpDestino(fk), razon_social(fk), descripcion)

//cpOrigen y cpDestino corresponden a la ciudades origen y destino del viaje



//cpOrigen y cpDestino corresponden a la ciudades origen y destino del viaje */

/* 1. Listar razón social, dirección y teléfono de agencias que realizaron viajes desde la ciudad de
‘La Plata’ (ciudad origen) y que el cliente tenga apellido ‘Roma’. Ordenar por razón social y
luego por teléfono. */

select a.RAZON_SOCIAL, a.direccion, a.telefono
FROM Agencia a
INNER JOIN Viaje v ON (a.RAZON_SOCIAL=v.RAZON_SOCIAL)
INNER JOIN Ciudad ci ON (ci.CODIGOPOSTAL=v.cpOrigen)
INNER JOIN Cliente cl ON (cl.DNI=v.DNI)
where ci.nombreCiudad='La Plata' and cl.apellido='Roma'
ORDER BY a.RAZON_SOCIAL, a.telefono

/* 2. Listar fecha, hora, datos personales del cliente, ciudad origen y destino de viajes realizados
en enero de 2019 donde la descripción del viaje contenga el String ‘demorado’. */

select cl.DNI, cl.nombre, cl.apellido, cl.telefono, cl.direccion, v.fecha, v.hora, origen.nombreCiudad, destino.nombreCiudad
FROM CLiente cl
INNER JOIN Viaje v ON (v.DNI=cl.dni)
INNER JOIN CIudad origen ON (v.cpOrigen=origen.CODIGOPOSTAL)
INNER JOIN Ciudad destino ON (v.cpDestino=destino.CODIGOPOSTAL)
WHERE (v.fecha BETWEEN '1/1/2019' and '31/1/2019') and v.descripcion LIKE '%demorado%';

/* 3. Reportar información de agencias que realizaron viajes durante 2019 o que tengan dirección
de mail que termine con ‘@jmail.com’. */

select a.RAZON_SOCIAL, a.direccion, a.telefono, a.e-mail
FROM Agencia a
INNER JOIN Viaje v ON (v.RAZONSOCIAL=a.RAZON_SOCIAL)
where (v.fecha BETWEEN '1/1/2019' and '31/12/2019)') or a.e-mail LIKE '%@jmail.com';

/* 4. Listar datos personales de clientes que viajaron solo con destino a la ciudad de ‘Coronel
Brandsen’ */

select cl.DNI, cl.nombre, cl.apellido, cl.telefono, cl.direccion
FROM Cliente cl
INNER JOIN Viaje v ON (v.DNI=cl.DNI)
INNER JOIN Ciudad dest ON (v.cpDestino=dest.CODIGOPOSTAL)
where dest.nombreCiudad='Coronel Brandsen'
EXCEPT(
select cl.DNI, cl.nombre, cl.apellido, cl.telefono, cl.direccion
FROM Cliente cl
INNER JOIN Viaje v ON (v.DNI=cl.DNI)
INNER JOIN Ciudad otro ON (v.cpDestino=otro.CODIGOPOSTAL)
where NOT  otro.nombreCiudad='Coronel Brandsen'
)
/* 5. Informar cantidad de viajes de la agencia con razón social ‘TAXI Y’ realizados a ‘Villa Elisa’. */

select COUNT(*) as 'Cantidad De Viajes'
From Agencia a
INNER JOIN Viaje v ON (v.razon_social=a.RAZON_SOCIAL)
INNER JOIN Ciudad dest ON (v.cpDestino=dest.CODIGOPOSTAL)
WHERE (a.RAZONSOCIAL='Taxi Y') and (dest.nombreCiudad='Villa Elisa')

/* 6. Listar nombre, apellido, dirección y teléfono de clientes que viajaron con todas las agencias. */

select cl.nombre, cl.apellido,cl.telefono, cl.direccion
From Cliente cl
WHERE NOT EXISTS (
  SELECT a.RAZONSOCIAL
  FROM Agencia A
  WHERE NOT EXISTS(
    SELECT 1
    FROM Viaje v
    where (v.DNI=cl.DNI) and (v.RAZONSOCIAL=a.RAZONSOCIAL)
    )
)


/* 7. Modificar el cliente con DNI: 38495444 actualizando el teléfono a: 221-4400897. */

UPDATE Cliente 
SET telefono='221-4400897'
Where DNI=38495444;

/* 8. Listar razon_social, dirección y teléfono de la/s agencias que tengan mayor cantidad de
viajes realizados. */

select a.RAZON_SOCIAL, a.direccion, a.telefono
FROM Agencia A
INNER JOIN Viaje V ON (a.RAZON_SOCIAL=v.RAZON_SOCIAL)
GROUP BY a.RAZON_SOCIAL, a.direccion, a.telefono
HAVING COUNT(*)>= ALL (
   SELECT COUNT(*)
   FROM Viaje v
   GROUP BY v.RAZONSOCIAL
   )
   
/* 9. Reportar nombre, apellido, dirección y teléfono de clientes con al menos 10 viajes. */

select cl.nombre, cl.apellido,cl.telefono, cl.direccion
From Cliente cl
INNER JOIN Viaje v ON (v.DNI=cl.DNI)
GROUP BY cl.nombre, cl.apellido, cl.telefono, cl.direccion
HAVING COUNT(*)>=10

/* 10. Borrar al cliente con DNI 40325692. */

DELETE FROM Cliente WHERE DNI=40325692
DELETE FROM VIAJE WHERE DNI=40325692



