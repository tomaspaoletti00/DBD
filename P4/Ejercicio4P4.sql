/*

Ejercicio 4
PERSONA = (DNI, Apellido, Nombre, Fecha_Nacimiento, Estado_Civil, Genero)
ALUMNO = (DNI (fk), Legajo, Año_Ingreso)
PROFESOR = (DNI (fk), Matricula, Nro_Expediente)
TITULO = (Cod_Titulo, Nombre, Descripción)
TITULO-PROFESOR = (Cod_Titulo (fk), DNI (fk), Fecha)
CURSO = (Cod_Curso, Nombre, Descripción, Fecha_Creacion, Duracion)
ALUMNO-CURSO = (DNI (fk), Cod_Curso (fk), Año, Desempeño, Calificación)
PROFESOR-CURSO = (DNI (fk), Cod_Curso (fk), Fecha_Desde, Fecha_Hasta)

*/

-- 1. Listar DNI, legajo y apellido y nombre de todos los alumnos que tengan año de ingreso inferior a 2014.

select p.DNI,p.nombre,p.apellido,a.legajo
FROM Persona p
INNER JOIN Alumno a ON (a.DNI=p.DNI)
WHERE a.Año_Ingreso<2024

-- 2. Listar DNI, matrícula, apellido y nombre de los profesores que dictan cursos que tengan más de
-- 100 horas de duración. Ordenar por DNI.

select p.DNI,prof.matricula,p.apellido,p.nombre
FROM Persona p
INNER JOIN Profesor p ON (prof.DNI=p.DNI)
INNER JOIN Profesor-Curso pc ON (prof.DNI=pc.DNI)
INNER JOIN Curso c ON (c.cod_curso=pc.cod_curso)
WHERE c.duracion>100
ORDER BY p.DNI

-- 3. Listar el DNI, Apellido, Nombre, Género y Fecha de nacimiento de los alumnos inscriptos al
-- curso con nombre “Diseño de Bases de Datos” en 2023.

select p.DNI,p.nombre,p.apellido,p.fecha_nacimiento,p.genero
FROM Persona p
INNER JOIN Alumno a ON (p.DNI=a.DNI)}
INNER JOIN ALUMNO-CURSO ac ON (ac.DNI=a.DNI)
INNER JOIN CURSO c ON (c.cod_curso=ac.cod_curso)
WHERE c.nombre='Diseño De Bases DeDatos' and ac.año=2024

--4. Listar el DNI, Apellido, Nombre y Calificación de aquellos alumnos que obtuvieron una
--calificación superior a 8 en algún curso que dicta el profesor “Juan Garcia”. Dicho listado deberá
--estar ordenado por Apellido y nombre.

select p.dni, p.apellido, p.nombre, ac.calificacion
From Persona p
INNER JOIN Alumno a ON (p.DNI=a.DNI)}
INNER JOIN ALUMNO-CURSO ac ON (ac.DNI=a.DNI)
INNER JOIN CURSO c ON (c.cod_curso=ac.cod_curso)
INNER JOIN PROFESOR-CURSO pc ON (c.cod_curso=pc.cod_curso)
INNER JOIN Profesor prof ON (pc.DNI=prof.DNI)
INNER JOIN Persona profP ON (prof.DNI=profP.DNI)
WHERE ac.calificacion>8 and profP.nombre='Juan' and profP.nombre='Garcia';
ORDER BY p.nombre,p.apellido

--5. Listar el DNI, Apellido, Nombre y Matrícula de aquellos profesores que posean más de 3 títulos.
--Dicho listado deberá estar ordenado por Apellido y Nombre.

select p.DNI,p.apellido,p.nombre,prof.matricula
FROM Persona p
INNER JOIN Profesor prof ON (prof.DNI=p.DNI)
INNER JOIN TITULO-PROFESOR tp ON (tp.DNI=prof.DNI)
INNER JOIN Titulo t ON (tp.cod_Titulo=t.cod_Titulo)
GROUP BY p.DNI,p.apellido,prof.matricula
HAVING COUNT(t.cod_Titulo)>3
ORDER BY p.nombre,p.apellido

--6. Listar el DNI, Apellido, Nombre, Cantidad de horas y Promedio de horas que dicta cada profesor.
-- La cantidad de horas se calcula como la suma de la duración de todos los cursos que dicta

select p.DNI,p.apellido,p.nombre, SUM(c.duracion), AVG(c.duracion)
FROM Persona p
INNER JOIN Profesor prof ON (prof.DNI=p.DNI)
INNER JOIN Profesor-Curso pc ON (prof.DNI=pc.DNI)
INNER JOIN Curso c ON (c.cod_curso=pc.cod_curso)
GROUP BY p.DNI,prof.matricula,p.apellido,p.nombre

--7. Listar Nombre y Descripción del curso que posea más alumnos inscriptos y del que posea menos 
-- alumnos inscriptos durante 2024.

select c.nombre,c.descripcion
FROM Curso c
INNER JOIN ALUMNO-CURSO ac ON (ac.cod_curso=c.cod_curso)
INNER JOIN Alumno a ON (ac.DNI=a.DNI)
WHERE a.año=2024
GROUP BY c.cod_curso,c.nombre,c.descripcion
HAVING COUNT(a.DNI)>= ALL(
 select COUNT(a.DNI)
 FROM Curso c
 INNER JOIN ALUMNO-CURSO ac ON (ac.cod_curso=c.cod_curso)
 INNER JOIN Alumno a ON (ac.DNI=a.DNI)
 WHERE a.año=2024
 GROUP BY c.cod_curso,c.nombre,c.descripcion
 )
UNION(
select c.nombre,c.descripcion
FROM Curso c
INNER JOIN ALUMNO-CURSO ac ON (ac.cod_curso=c.cod_curso)
INNER JOIN Alumno a ON (ac.DNI=a.DNI)
WHERE a.año=2024
GROUP BY c.cod_curso,c.nombre,c.descripcion
HAVING COUNT(a.DNI)<= ALL(
 select COUNT(a.DNI)
 FROM Curso c
 INNER JOIN ALUMNO-CURSO ac ON (ac.cod_curso=c.cod_curso)
 INNER JOIN Alumno a ON (ac.DNI=a.DNI)
 WHERE a.año=2024
 GROUP BY c.cod_curso,c.nombre,c.descripcion
)
)

-- 8. Listar el DNI, Apellido, Nombre y Legajo de alumnos que realizaron cursos con nombre
-- conteniendo el string ‘BD’ durante 2022 pero no realizaron ningún curso durante 2023.

select p.DNI,p.apellido,p.nombre,a.legajo
FROM Persona p
INNER JOIN Alumno a ON (p.dni=a.dni)
INNER JOIN Alumno-Curso ac ON (ac.dni=a.dni)
INNER JOIN Curso c ON (c.cod_Curso=ac.cod_Curso)
WHERE c.nombre LIKE '%BD%' and ac.año=2022
EXCEPT (
select p.DNI,p.apellido,p.nombre,a.legajo
FROM Persona p
INNER JOIN Alumno a ON (p.dni=a.dni)
INNER JOIN Alumno-Curso ac ON (ac.dni=a.dni)
INNER JOIN Curso c ON (c.cod_Curso=ac.cod_Curso)
WHERE ac.año=2023
)
-- 9. Agregar un profesor con los datos que prefiera y agregarle el título con código: 25.

INSERT INTO Profesor (DNI , Matricula, Nro_Expediente)
VALUES (43015801,'12344',890)
INSERT INTO TITULO-PROFESOR (Cod_Titulo, DNI , Fecha)
VALUES (25,43015801,'2024/12/1')

-- 10. Modificar el estado civil del alumno cuyo legajo es ‘2020/09’, el nuevo estado civil es divorciado.

UPDATE Persona p  
INNER JOIN Alumno a ON(a.dni=p.dni)
SET estado_civil='divorciado' 
WHERE a.legajo='2020/09'

-- 11. Dar de baja el alumno con DNI 30568989. Realizar todas las bajas necesarias para no dejar el
-- conjunto de relaciones en un estado inconsistente.

DELETE Alumno 
WHERE DNI=30568989

DELETE ALUMNO-CURSO
WHERE DNI=30568989

DELETE Persona
WHERE DNI=30568989