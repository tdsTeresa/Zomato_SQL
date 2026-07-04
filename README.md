
<h2>🍔 Descripción general:</h2>
<br>
En este ejercicio se realiza la exploración de datos en SQL Server y un dashboard de Power BI para descubrir tendencias en un dataset de la app de <b>comida a domicilio Zomato</b>, en la India. Las consultas realizadas incluyen top restaurantes y platillos, tamaño familiar vs promedio de pedidos, clientes por edad, ocupación e ingresos, ticket promedio, clientes registrados mensualmente, así como la adherencia de la aplicación y la tasa de crecimiento anual.</a><br><br>
Conceptos clave:<br><br></b>
  • <b>Adherencia</b>: Qué proporción de usuarios están activos en un día (DAU/MAU), un buen nivel de adherencia es considerado a partir del 20%:<br>
    • <b>DAU</b>: Daily Active Users, Usuarios activos por día.<br>
    • <b>MAU</b>: Monthly Active Users, Usuarios activos por mes.<br><br>
  • <b>Tasa de crecimiento</b>: Cuánto crecen las ventas respecto al mes o año anterior.<br><br>
  
<br>
<h2>⚙️Tecnologías: </h2>
<br>
    • SQL Server <br>
    • Microsoft Power BI<br>
<br><br>

<h2>🖇️ Fuente: </h2><br>
https://www.kaggle.com/datasets/anas123siddiqui/zomato-database?select=restaurant.csv
<br>
<br>
<br>
<h2>📊 Actividades: </h2>
<br>
  • Definición de base de datos e importación de datos.<br>
  • Consultas para extraer ingresos y otras métricas.<br>
  • CTE y funciones de agregación.<br> 
  • Visualización de resultados en Power BI.<br> 
<br>
<br>
<h2><b></b>Exploración en Power BI</b></h2>
<br><br>
Cada una de las tarjetas indica en color verde (ganancias) o rojo (perdidas) el valor comparado con el mes anterior.<br><br>
<br>
La tendencia de ventas indica los ingresos, la tendencia de adherencia nos muestra qué tan usada ha sido la aplicación a través de los años.
<br><br>

![dashboard](images/Resumen.png)
<br><br><br>
En la siguiente pestaña se pueden realizar filtros para visualizar el top de restaurantes por rating e ingreso, así como los platillos más vendidos y los ingresos por tipo de comida. 
<br><br>

![after_SQL_dashboard](images/oferta_restaurantes.png)
<br><br><br>
Al final de la presentación se muestra la segmentación de usuarios por ocupación, en adición, filtros por género, edad e ingreso mensual. Así mismo, el promedio de unidades vendidas en el tiempo y un diagrama de puntos en relación con el número de miembros por familia.
<br><br>
![after_SQL_dashboard](images/usuarios.png)
<br><br><br>
<h2><b></b>Exploración en SQL </b></h2><br>
Algunas consultas de la exploración en SQL Server:
<br><br>
▫️Top 10 clientes por ingresos<br><br>

![top_client_groups](images/top%20client%20groups.png)
<br><br><br>
▫️Adherencia de la aplicación<br><br>

![stickiness](images/stickiness.png)
<br><br><br>

▫️Ingresos por tipo de cocina (vegana y no vegana)<br><br>
![revenue_veg_or_non_veg](images/revenue%20per%20cuisine%20type.png)
<br><br><br>
▫️Clientes registrados mensualmente<br><br>
Para este ejercicio, se consideró la primera compra de cada cliente como fecha de registro.<br><br>
![registered_users_per_month](images/reg%20users%20per%20month.png)

<br><br><br>
▫️Top 10 platillos más vendidos<br><br>

![top_10_food](images/most%20sold%20food.png)
<br><br><br>

▫️Tasa de crecimiento anual en ventas<br><br>

![growth_rate_per_year](images/growth_rate.png)
<br><br><br>

<h2>🔶 Observaciones generales:</h2>
<br>
• El restaurante con más ventas es MAHARAJA GRILLS & ROLLS, en Bangalore.<br>
• Los clientes que adquieren en promedio más platillos en la aplicación son personas que viven solas.<br> 
• Las empleadas de 25 años que tienen un ingreso mensual superior a las 50,000 rupias y los estudiantes sin ingreso son los clientes que han generado más ventas.<br>
• Los restaurantes con mejor rating no siempre tienen las mejores ventas.<br>
• La cocina vegana es la más consumida.<br>
• El café frío en ambas variantes, vegano y no vegano es el más consumido. <br>
• El ticket promedio es de 1.29 millones de rupias.<br>
• La temporada con más registros de clientes ha sido de noviembre 2017 a enero 2018.<br>
• El promedio de adherencia mensual de la aplicación es alrededor de 5%, lo cual significa que los usuarios interactúan con ella de una a dos veces por mes.<br>
• La tasa de crecimiento es decreciente con los años.
<br>
