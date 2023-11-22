/*10 SQL queries from basic to medium level*/

/*Estas consultas se realizan sobre un conjunto de datos distribuido en cuatro tablas que contienen información sobre
la recolección de residuos en diferentes estaciones recolectoras en brasil: Una tabla dimensional que contiene las fechas en las
que se han realizado recolecciones; una segunda tabla dimensional que contiene la marca de los camiones recolectores;
una tercera tabla dimensional que contiene cada estación recolectora; y una cuarta que es una tabla de hechos que contiene la
información de cada viaje de recolección de residuos, indicando la fecha, la ciudad, el camión recolector
y la cantidad de residuos recolectados.

Todas las tablas contienen un primer campo id que hace de llave primaria y de llave foránea en algunas de las otras tablas.
*/

--1: Listar todas las estaciones recolectoras en orden alfabético. El resultado debe presentar el stationId, stationname.

select stationid, stationname FROM "Collection".dimstation 
order by stationname

--2: Listar todos los viajes que recolectaron una cantidad de residuos > 40. El resultado debe presentar el tripId, Waste.

select tripid, waste FROM "Collection".facttrips 
where waste > 40

--3: Cuente la cantidad de resultados de la anterior consulta.

select count(*) as CantTripsOver40 FROM "Collection".facttrips 
where waste > 40

-- 4: Listar el promedio de residuos recolectados cada fecha. El resultado debe contener dateId, average waste.
/*Recordar al mezclar columnas agregadas (avg, max, min, count)con columnas no agregadas, es necesario usar la
cláusula group by */

select dateid, avg(waste) as Recolec_Prom FROM "Collection".facttrips 
group by dateid
order by dateid

/*5: Listar los nombres de las marcas de los camiones recolectores y la cantidad que hay de cada uno.
La salida debe contener truckName, count. */

select truckname, count(truckname) from "Collection".dimtruck
group by truckname

--6: Listar cada ciudad con el total de residuos recolectados en ella. El resultado debe contener cityname, total_Waste

/*Acá tenemos que traer información de dos tablas: dimstation y facttrips. Luego el uso de join es aplicable acá.
El campo común entre ambas tablas es el stationid */

select s.stationname as CityName, sum(f.waste) as total_waste
from "Collection".dimstation s
left join "Collection".facttrips f on s.stationid=f.stationid
group by CityName


--7: ¿Cantidad mínima de residuos recolectados por trimestre en 2019? El resultado debe contener QuarterName, minimum waste.
/*Para responder la pregunta, se deben consultar las tablas: dimdate y facttrips. Se usará JOIN.
El campo común entre ambas tablas es dateid */

select d.quartername, min(f.waste) as min_waste_per_quarter_in_2019
from "Collection".facttrips f
left join "Collection".dimdate d on d.dateid=f.dateid
where year=2019 
group by d.quartername
order by d.quartername

/*8:¿Cantidad máxima de residuos recolectados en el trimestre 1 en Sao Paulo? 
El resultado debe contener quarterName, City, maximum Waste.*/

/*Para responder la pregunta, se deben consultar tres tablas: dimdate, dimstation y facttrips. Se usará JOIN.
El campo común entre la tabla facttrips y dimdate es dateid, y entre facttrips y dimstation es stationid */

select s.stationname as City, d.quartername, max(f.waste) as max_waste
from "Collection".facttrips f
left join "Collection".dimdate d on d.dateid=f.dateid
left join "Collection".dimstation s on s.stationid=f.stationid
where d.quartername='Q1' and s.stationname ='Sao Paulo' 
group by s.stationname, d.quartername


/*9: Listar los días de la semana en los que los camiones Volvo recogen una media de residuos mas alta. 
El resultado debe contener WeekDayName, TruckName, avg_Waste.*/

/*Para responder la pregunta, se deben consultar tres tablas: facttrips, dimdate y dimtruck. Se usará JOIN.
El campo común entre la tabla facttrips y dimdate es dateid, y entre facttrips y dimtruck es truckid */

select d.weekdayname, t.truckname, avg(f.waste) as avg_waste
from "Collection".facttrips f
left join "Collection".dimtruck t on f.truckid = t.truckid
left join "Collection".dimdate d on f.dateid=d.dateid
where t.truckname='Volvo'
group by d.weekdayname, t.truckname
order by avg_waste desc

/*10: Encontrar el tripid para el cual se dio el máximo de residuos recolectados en cada date id*/

--esta solución ofrece el mismo resutado que la querie anterior, solo que esta se ve mas limpia
select tripid, dateid, waste from "Collection".facttrips
where (dateid, waste) in (
select dateid, max(waste) from "Collection".facttrips
group by dateid)


/*Bonus: Listar las fechas en las que cada ciudad recolectó el máximo de residuos.
El resultado debe contener city, date, maximum Waste.*/

Select s.stationName as city, d.datec as date, a.waste
From (
Select stationid, dateid, waste, rank() over (partition by stationId order by waste desc) as rnk
From "Collection".facttrips) a
Left outer join "Collection".dimdate d on a.DateId = d.DateId
Left outer join "Collection".dimstation s on a.stationId = s.stationId
Where a.rnk = 1
order by stationname













