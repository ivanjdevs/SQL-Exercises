## ¿Qué es esto?

Este es un ejericio en SQL donde se realizan 5 consultas sobre una pequeña base de datos dividida en tres archivos CSV que contienen información sobre empleados contratados en ciertos
departamentos de una empresa y sus cargos.

### 1) Cantidad de empleados contratados por departamento en 2021.

```ruby
select d.department, count(*)
from public.employees e
left join public.departments d on d.id = e.dep_id
where (select substring(e.datetime, 1,4))='2021'
group by d.department;
```

![1  Number of employees hired by dept](https://github.com/ivanjdevs/SQL-Exercises/assets/68659886/ba64ac0b-4648-4324-b0da-8f63ed152e1e)


### 2) Encontrar los empleados de la tabla employees para los cuales no existe un dep_id.

```ruby
select d.department, e.name
from public.employees e
left join public.departments d on d.id = e.dep_id
where d.id is null;
```

![2  Employees with no dep_id](https://github.com/ivanjdevs/SQL-Exercises/assets/68659886/028dcc3c-5ccb-4ae8-ac0d-cff8bedc83d7)


### 3) Departamento dentro del cual fue contratado el empleado, y cuya contratación fue en mayo de 2021.

```ruby
select d.department, e.name, e.datetime
from public.employees e
left join public.departments d on d.id = e.dep_id
where (select substring(e.datetime, 1,7))='2021-05';
```

### 4) Cantidad de empleados contratados por departamento en 2021, divididos por trimestre.

```ruby
select d.department,
sum(case when (select substring(e.datetime, 1,7)) in ('2021-01','2021-02','2021-03') then 1 else 0 end ) as Trimestre1,
sum(case when (select substring(e.datetime, 1,7)) in ('2021-04','2021-05','2021-06') then 1 else 0 end ) as Trimestre2,
sum(case when (select substring(e.datetime, 1,7)) in ('2021-07','2021-08','2021-09') then 1 else 0 end ) as Trimestre3,
sum(case when (select substring(e.datetime, 1,7)) in ('2021-10','2021-11','2021-12') then 1 else 0 end ) as Trimestre4
from public.departments d
left join public.employees e on d.id = e.dep_id
group by d.department;
```


<h3> 5) Listar el id, nombre y número de empleados contratados en cada departamento que contrató mas empleados que el promedio
de empleados contratados en todo 2021 para todos los departamentos. Ordene el resultado por el número de empleados contratados
en orden descendente.  </h3>

_Primero, promedio de empleados contratados._

```ruby
select count(*)/count (distinct dep_id) as avg_hired
from public.employees
where (select substring(datetime, 1,4))='2021';
```

_Listo. Armar la querie completa. La subquerie de mas abajo es la misma que acabamos de hacer anteriormente..
En la subquerie de mas arriba (select d.id, d.department, count(*)...) se halla el número de empleados contratados en cada
departamento. Y en la querie general, se seleccionan los campos que se desean (id, department, hired), colocando 
la condición where según lo que se requiere, en este caso, que la cantidad de empleados sea mayor al promedio general._


```ruby
select id, department, hired
from(
	select d.id, d.department, count(*) as hired
	from public.employees e
	left join public.departments d on d.id = e.dep_id
	where (select substring(e.datetime, 1,4))='2021'
	group by d.department, d.id
	 ) as aux
where hired > (
	select count(*)/count (distinct dep_id) as avg_hired
	from public.employees
	where (select substring(datetime, 1,4))='2021'
	           )
order by hired desc;
```
