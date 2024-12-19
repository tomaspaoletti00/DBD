Personas (dni, nombre, apellido, genero, telefono, email)
Medicos (matricula, dni(FK), fechalngreso)
Pacientes (dni(FK), fechaNacimiento, antecedentes)
Especialidades (idEspecialidad, nombree, descripcion)
MedicosEspecialidades (matricula(FK). idEspecialidad(FK))
Atenciones (nroAtencion, matricula(FK), dni(FK), fecha, hora, motivo, diagnostico?, tratamiento? ) // dni se refiere al DNI del
paciente atendido 

1 - Listar matrícula, dni, nombre, apellido, teléfono y email de los médicos cuyo apellido sea “Garcia”.

select nombre,apellido,telefono,email
From Persona p
INNER JOIN Medicos m ON (m.DNI=p.DNI)
WHERE p.apellido='Garcia'

2- Listar dni, nombre y apellido de aquellos pacientes que no recibieron atenciones durante 2024. 

select p.dni,p.apellido,p.nombre
INNER JOIN Paciente pac ON (pac.DNI=p.DNI)
INNER JOIN Atenciones a ON (a.DNI=pac.DNI)
EXCEPT(
select p.dni,p.apellido,p.nombre
INNER JOIN Paciente pac ON (pac.DNI=p.DNI)
INNER JOIN Atenciones a ON (a.DNI=pac.DNI)
WHERE a.fecha BETWEEN '2024-01-01'and'2024-12-31';
)

3- Listar dni, nombre y apellido de los pacientes atendidos por todos los médicos especializados en “Cardiología”. 

select p.dni,p.apellido,p.nombre
FROM Persona p
INNER JOIN Paciente pac ON (p.DNI=pac.DNI)
INNER JOIN Atenciones a ON (a.DNI=pac.DNI)
WHERE NOT EXISTS(
	select 1
	FROM Medicos m
	WHERE NOT EXISTS(
 select 1
 FROM MedicosEspecialidad me 
 INNER JOIN Especialidades e ON(me.idEspecialidad=e.idEspecialidad)
 WHERE e.nombreE='Cardiologia' and me.matricula=m.matricula
)
	and m.dni=a.dni
)

4- Listar para cada especialidad nombre y cantidad de médicos que se especializan en ella. Tenga en cuenta que puede haber
especialidades que no tienen médicos especialistas. 

select e.nombreE, count(m.matricula) as cantidad_medicos
LEFT JOIN MedicosEspecialidadme ON
(e.idEspecialidad=me.idEspecialidad)
LEFT JOIN Medicos m ON (me.matricula=m.matricula)
GROUP BY e.idEspecialidad,e.mombreE;

5- Listar matrícula, dni, nombre y apellido del médico (o de los médicos) con más atenciones realizadas. 

select m.matricula,p.dni,p.apellido
From Persona p
INNER JOIN Medicos m ON (m.DNI=p.DNI)
INNER JOIN Atenciones a ON (m.matricula=a.matricula)
GROUP BY m.matricula,p.dni,p.apellido
HAVING COUNT (a.nroAtencion)>=ALL(
 select COUNT(a.nroAtencion)
 From Atenciones a2
 INNER JOIN Medicos m ON (m.DNI=p.DNI)
 GROUP BY m2.matricula
)

