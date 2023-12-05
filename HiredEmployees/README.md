Este es un ejericio en SQL donde se realizan 5 consultas sobre una pequeña base de datos dividida en tres archivos CSV que contienen información sobre empleados contratados en ciertos
departamentos de una empresa y sus cargos.

1. Cantidad de empleados contratados por departamento en 2021.

select d.department, count(*)
from public.employees e
left join public.departments d on d.id = e.dep_id
where (select substring(e.datetime, 1,4))='2021'
group by d.department;

HiredEmployees/OutputsHiredEmpl/1. Number of employees hired by dept.png


![1  Number of employees hired by dept](https://github.com/ivanjdevs/SQL-Exercises/assets/68659886/ba64ac0b-4648-4324-b0da-8f63ed152e1e)


