/* Ejercicio 1
Cliente (idCliente, nombre, apellido, DNI, telefono, direccion)
Factura (nroTicket, total, fecha, hora, idCliente (fk))
Detalle (nroTicket (fk), idProducto (fk), cantidad, preciounitario)
Producto (idProducto, nombreP, descripcion, precio, stock) */

-- 1. Listar datos personales de clientes cuyo apellido comience con el string ‘Pe’. Ordenar por DNI
select idCliente, nombre, apellido, DNI, telefono, direccion
from Cliente
where apellido like "Pe%"
Order by DNI;

-- 2. Listar nombre, apellido, DNI, teléfono y dirección de clientes que realizaron compras solamente durante 2017.
select c.nombre, c.apellido, c.dni, c.telefono, c.direccion
from Cliente c
INNER JOIN Factura f ON c.idCLiente=f.idCLiente
where f.fecha BETWEEN "1/1/2017" AND "31/12/2017"
EXCEPT
select c.nombre, c.apellido, c.dni, c.telefono, c.direccion
from Cliente C
INNER JOIN Factura f ON c.idCliente=f.idCliente
where f.fecha < "1/1/2017" or f.fecha > "31/12/2017";

-- 3. Listar nombre, descripción, precio y stock de productos vendidos al cliente con DNI 45789456, pero que no fueron vendidos a clientes de apellido ‘Garcia’.
SELECT p.nombreP, p.descripcion, p.precio, p.stock
FROM Producto p 
INNER JOIN Detalle d ON (p.idProducto = d.idProducto)
INNER JOIN Factura f ON (d.nroTicket = f.nroTicket) 
INNER JOIN Cliente c ON (f.idCliente =  c.idCliente)
WHERE (c.DNI = 45789456)
EXCEPT  (
SELECT p.nombreP, p.descripcion, p.precio, p.stock
FROM Producto p 
INNER JOIN Detalle d ON (p.idProducto = d.idProducto)
INNER JOIN Factura f ON (d.nroTicket = f.nroTicket) 
INNER JOIN Cliente c ON (f.idCliente =  c.idCliente)
WHERE (c.apellido = "Garcia")
)

/*4. Listar nombre, descripción, precio y stock de productos no vendidos a clientes que tengan 
teléfono con característica: 221 (La característica está al comienzo del teléfono). Ordenar por nombre.*/

SELECT p.nombreP, p.descripcion, p.precio, p.stock
From Producto P
EXCEPT (
SELECT p.nombreP, p.descripcion, p.precio, p.stock
From Producto P
INNER JOIN Detalle d ON (p.idProducto = d.idProducto)
INNER JOIN Factura f ON (d.nroTicket = f.nroTicket) 
INNER JOIN Cliente c ON (f.idCliente =  c.idCliente)
where c.telefono LIKE "221%")
ORDER BY p.nombreP, p.idProdcuto

/*5. Listar para cada producto: nombre, descripción, precio y cuantas veces fué vendido. 
Tenga en cuenta que puede no haberse vendido nunca el producto.*/

SELECT p.nombreP, p. descripcion, p.precio, SUM(d.cantidad) as Cantidad
From Producto p LEFT JOIN Detalle d ON (d.idProducto=p.idProducto)
GROUP BY p.idProducto, p.nombreP, p.descripcion, p.precio

/*6. Listar nombre, apellido, DNI, teléfono y dirección de clientes que compraron los productos con nombre ‘prod1’ y ‘prod2’ 
pero nunca compraron el producto con nombre ‘prod3’.*/

SELECT c.nombre, c.apellido, c.DNI, c.telefono, c.direccion
FROM Cliente c
INNER JOIN Factura f ON f.idCliente = c.idCliente
INNER JOIN Detalle d ON d.NroTicket = f.NroTicket
INNER JOIN Producto p ON p.idProducto = d.idProducto
WHERE p.nombreP = 'prod1' 
AND c.idCliente IN (
    SELECT f.idCliente
    FROM Factura f
    INNER JOIN Detalle d ON d.NroTicket = f.NroTicket
    INNER JOIN Producto p ON p.idProducto = d.idProducto
    WHERE p.nombreP = 'prod2'
)
AND c.idCliente NOT IN (
    SELECT f.idCliente
    FROM Factura f
    INNER JOIN Detalle d ON d.NroTicket = f.NroTicket
    INNER JOIN Producto p ON p.idProducto = d.idProducto
    WHERE p.nombreP = 'prod3'
)
ORDER BY c.nombre;

/*7. Listar nroTicket, total, fecha, hora y DNI del cliente, de aquellas facturas donde se haya comprado el producto ‘prod38’ 
o la factura tenga fecha de 2019.*/

SELECT f.nroTicket, f.total, f.fecha, c.DNI 
FROM Factura f 
INNER JOIN Cliente c ON (c.idCliente=f.idCliente)
INNER JOIN Detalle d ON (d.nroTicket=f.nroTicket)
INNER JOIN Producto p ON (p.idProducto=d.idProducto)
where (p.nombreP = 'prod38') OR (f.fecha BETWEEN '1/1/2019' and '31/12/2019');

/*8. Agregar un cliente con los siguientes datos: nombre:’Jorge Luis’, apellido:’Castor’, DNI:40578999, teléfono:221-4400789, 
dirección:’11 entre 500 y 501 nro:2587’ y el id de cliente: 500002. Se supone que el idCliente 500002 no existe.*/

INSERT INTO Cliente (idCliente, nombre, apellido, dni, telefono, direccion)
VALUES (500002,'Jorge Luis', 'Castor', 40578999, 2214400789, '11 entre 500 y 501 nro:2587')

/*9. Listar nroTicket, total, fecha, hora para las facturas del cliente ´Jorge Pérez´ donde no haya comprado el producto ´Z´.*/

SELECT f.nroTicket, f.total, f.fecha
From Factura f
INNER JOIN Cliente c ON (c.idCliente=f.idCliente)
INNER JOIN Detalle d ON (d.nroTicket=f.nroTicket)
INNER JOIN Producto p ON (p.idProducto=d.idProducto)
where c.nombre='Jorge' and c.apellido='Perez'
EXCEPT(
SELECT f.nroTicket, f.total, f.fecha
From Factura f
INNER JOIN Cliente c ON (c.idCliente=f.idCliente)
INNER JOIN Detalle d ON (d.nroTicket=f.nroTicket)
INNER JOIN Producto p ON (p.idProducto=d.idProducto)
where p.nombreP = 'Z')


/*10. Listar DNI, apellido y nombre de clientes donde el monto total comprado, teniendo en cuenta todas sus facturas, supere $10.000.000.*/

SELECT c.nombre, c.apellido, c.DNI
FROM Cliente C
INNER JOIN Factura f ON (c.idCliente=f.idCliente)
GROUP BY c.idCliente,c.nombre,c.apellido
HAVING SUM(f.total)>10.000.000