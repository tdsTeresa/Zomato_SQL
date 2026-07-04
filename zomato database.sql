-- CREACIÓN DE BASE DE DATOS Y TABLAS
CREATE DATABASE zomato
use zomato

CREATE TABLE food(
					num INT,
					f_id VARCHAR(10) PRIMARY KEY,	-- Llave primaria 
					item VARCHAR(200),				-- Nombre del platillo
					veg_or_non_veg VARCHAR(MAX))	-- Indica si es vegano

CREATE TABLE restaurant(
						num INT,
						id INT PRIMARY KEY,			-- Llave primaria
						name_ VARCHAR(75),			-- Nombre del restaurante
						city VARCHAR(50),			-- Ciudad
						rating VARCHAR(5),			-- Calificación promedio
						rating_count VARCHAR(15),	-- Conteo de calificaciones
						cost VARCHAR(10),			-- Costo promedio por comida
						cuisine VARCHAR(50),		-- Cocina
						lic_no VARCHAR(20),			-- No. de licencia
						link VARCHAR(200),			-- Sitio web
						address_ VARCHAR(260),		-- Dirección
						menu VARCHAR(MAX))			-- Menú
						
CREATE TABLE menu(
					num INT, 
					menu_id VARCHAR(10) PRIMARY KEY,	-- Llave primaria
					r_id INT,							-- id de restaurante (FK)
					f_id VARCHAR(10),					-- id de platillo (FK)
					cuisine VARCHAR(90),				-- Cocina
					price VARCHAR(15),					-- Precio
					FOREIGN KEY (r_id) REFERENCES restaurant(id),
					FOREIGN KEY(f_id) REFERENCES food(f_id))

CREATE TABLE users(
					num INT,
					user_id_ INT PRIMARY KEY,				-- Llave primaria
					name VARCHAR(30),						-- Nombre del cliente
					email VARCHAR(40),						-- Correo electrónico
					password VARCHAR(12),					-- Contraseña
					Age INT,								-- Edad
					Gender VARCHAR(6),						-- Género
					Marital_Status VARCHAR(20),				-- Estado civil
					Occupation VARCHAR(15),					-- Ocupación
					Monthly_Income VARCHAR(20),				-- Ingreso mensual
					Educational_Qualifications VARCHAR(15),	-- Nivel de estudios
					Family_size SMALLINT)					-- Tamaño de familia
					CREATE INDEX idx_user_id ON users(user_id_)

CREATE TABLE orders(
					num INT,					
					order_date DATE,					-- Fecha de orden
					sales_qty SMALLINT,					-- Cantidad de platillos
					sales_amount INT,					-- Cantidad en efectivo
					currency VARCHAR(8),				-- Moneda
					user_id_ INT,						-- id de usuario (FK)
					r_id INT,							-- id de restaurante (KF)
					FOREIGN KEY (user_id_) REFERENCES users(user_id_),
					FOREIGN KEY (r_id) REFERENCES restaurant(id))
					ALTER TABLE orders ALTER COLUMN num INT NOT NULL
					alter table orders add constraint PK_num PRIMARY KEY(num)
					alter table orders alter column sales_amount BIGINT
					CREATE INDEX idx_order_date ON orders(order_date)
					
-- INSERCIÓN DE DATOS
BULK INSERT food FROM 'C:\Users\einzw\Downloads\zomato\food_.csv'
						WITH (Firstrow= 2,
							FieldTerminator= ';',
							ROWTERMINATOR = '\n',
							TABLOCK)

BULK INSERT restaurant FROM 'C:\Users\einzw\Downloads\zomato\restaurant_.csv'
						WITH (Firstrow= 2,
							FieldTerminator= ';',
							ROWTERMINATOR = '\n',
							TABLOCK)

BULK INSERT menu FROM 'C:\Users\einzw\Downloads\zomato\menu_.csv'
						WITH (Firstrow= 2,
							FieldTerminator= ';',
							ROWTERMINATOR = '\n',
							TABLOCK)

BULK INSERT users FROM 'C:\Users\einzw\Downloads\zomato\users.csv'
						WITH (Firstrow= 2,
							FieldTerminator= ',',
							ROWTERMINATOR = '\n',
							TABLOCK)

BULK INSERT orders FROM 'C:\Users\einzw\Downloads\zomato\orders.csv'
						WITH (Firstrow= 2,
							FieldTerminator= ',',
							ROWTERMINATOR = '\n',
							TABLOCK)

							--CONSULTAS A LA BASE DE DATOS
				--1. Top 10 restaurantes por ingreso
SELECT TOP (10) r.name_,
				r.city,
				r.rating,
		SUM(o.sales_qty * o.sales_amount) AS revenue
		FROM restaurant r
		LEFT JOIN orders o
		ON o.r_id= r.id
		GROUP BY r.name_, r.city, r.rating
		ORDER BY revenue DESC

				
				--2. Tamaño familiar vs promedio de pedidos
SELECT u.Family_size,
		AVG(o.sales_qty) as avg_quantity
		FROM users u
		LEFT JOIN orders o
		ON o.user_id_= u.user_id_
		GROUP BY u.Family_size
		ORDER BY avg_quantity DESC
		
				--3. Top 10 grupos de clientes por edad, ocupación e ingresos
WITH users_data AS (
					SELECT u.Age, 
							u.Gender,
							u.Marital_Status,
							u.Occupation, 
							u.Monthly_income,
							u.Educational_Qualifications,
							SUM(o.sales_qty * o.sales_amount) AS revenue
							FROM users u
							LEFT JOIN orders o
							ON o.user_id_= u.user_id_
							GROUP BY u.Age, 
							u.Gender,
							u.Marital_Status,
							u.Occupation, 
							u.Monthly_income,
							u.Educational_Qualifications)
						
SELECT TOP (10) Age, Gender, 
				Occupation, 
				Monthly_income, 
				revenue
				FROM users_data		 
				ORDER BY revenue DESC, Age, Monthly_Income, Occupation 

				--4. Rating vs ventas
SELECT COALESCE(r.rating, 'No disponible') AS rating,
		SUM(o.sales_qty * o.sales_amount) AS revenue
		FROM restaurant r
		LEFT JOIN orders o
		ON o.r_id= r.id
		GROUP BY r.rating
		ORDER BY r.rating DESC

				--5.Ingresos por tipo de cocina (vegana y no vegana)
WITH cuisine_type AS (
						SELECT COALESCE(f.veg_or_non_veg, 'No disponible') AS description_column,
					CASE
						WHEN f.veg_or_non_veg like '%non-veg%' THEN 'Non-veg'
						WHEN f.veg_or_non_veg IS NULL THEN 'No disponible'
						ELSE 'Veg'
					END AS VEG_OR_NON_VEG,
						SUM(o.sales_qty * o.sales_amount) AS revenue
						FROM food f
						LEFT JOIN menu m
						ON m.f_id= f.f_id
						LEFT JOIN restaurant r
						ON r.id= m.r_id
						LEFT JOIN orders o
						ON o.r_id= r.id
						GROUP BY COALESCE(f.veg_or_non_veg, 'No disponible'),
					CASE
						WHEN f.veg_or_non_veg like '%non-veg%' THEN 'Non-veg'
						WHEN f.veg_or_non_veg IS NULL THEN 'No disponible'
					ELSE 'Veg'
					END)

SELECT VEG_OR_NON_VEG, 
		SUM(revenue) AS revenue
		FROM cuisine_type
		GROUP BY VEG_OR_NON_VEG
		ORDER BY SUM(revenue) DESC

				-- 6. Top 10 platillos más vendidos
WITH foods AS (
				SELECT f.item,
						COALESCE(f.veg_or_non_veg, 'No disponible') AS description_column,
					CASE
						WHEN f.veg_or_non_veg like '%non-veg%' THEN 'Non-veg'
						WHEN f.veg_or_non_veg IS NULL THEN 'No disponible'
						ELSE 'Veg'
					END AS type_food,
						SUM(o.sales_qty * o.sales_amount) AS revenue
						FROM food f
						LEFT JOIN menu m
						ON m.f_id= f.f_id
						LEFT JOIN restaurant r
						ON r.id= m.r_id
						LEFT JOIN orders o
						ON o.r_id= r.id
						GROUP BY f.item, COALESCE(f.veg_or_non_veg, 'No disponible'),
					CASE
						WHEN f.veg_or_non_veg like '%non-veg%' THEN 'Non-veg'
						WHEN f.veg_or_non_veg IS NULL THEN 'No disponible'
						ELSE 'Veg'
					END)
SELECT TOP (10) COALESCE(NULLIF(item, 'nan'), 'No disponible') as Item, 
				type_food, 
				revenue	
				FROM foods 
				ORDER BY revenue DESC

				-- 7. Ticket promedio
WITH total_revenue AS
					(SELECT SUM(sales_qty * sales_amount) AS revenue
					FROM orders),
sales_quantity AS
					(SELECT COUNT(num) as count_orders
					FROM orders)

SELECT (t.revenue/s.count_orders) AS ticket
	FROM total_revenue t, sales_quantity s;
	
				-- 8. Clientes registrados mensualmente
WITH reg_dates AS (
					SELECT user_id_,
					MIN(order_date) AS reg_date
					FROM orders
					GROUP BY user_id_)

SELECT CAST(DATEADD(MONTH, DATEDIFF(MONTH, 0, reg_date), 0) AS DATE) AS reg_month,
		COUNT(DISTINCT user_id_) AS users
		FROM reg_dates
		GROUP BY CAST(DATEADD(MONTH, DATEDIFF(MONTH, 0, reg_date), 0) AS DATE)
		ORDER BY reg_month DESC

				-- 9. Adherencia o Stickiness de la aplicación: Que proporción de los usuarios 
																--están activos en un día (DAU/MAU)

													-- Usuarios activos por día (Daily Active Users, DAU)
WITH DAU AS (SELECT CAST(order_date AS DATE) AS date_day,			
					COUNT(DISTINCT user_id_) AS DAU
					FROM orders
					GROUP BY CAST(order_date AS DATE)),
					
													-- Usuarios activos por mes (Monthly Active Users, MAU)
MAU AS (SELECT CAST(DATEADD(MONTH, DATEDIFF(MONTH, 0, order_date), 0) AS DATE) AS date_month,
					COUNT(DISTINCT user_id_) AS MAU
					FROM orders
					GROUP BY CAST(DATEADD(MONTH, DATEDIFF(MONTH, 0, order_date), 0) AS DATE))

SELECT d.date_day,
		d.DAU,
		m.MAU,
		CAST(d.DAU * 1.0 / m.MAU AS DECIMAL(5,2)) AS adherencia
		FROM DAU d
		JOIN MAU m
		ON DATEPART(YEAR, d.date_day) = DATEPART(YEAR, m.date_month)
		AND DATEPART(MONTH, d.date_day) = DATEPART(MONTH, m.date_month)
		ORDER BY d.date_day

				-- 10. Promedio mensual de adherencia

WITH DAU AS (SELECT CAST(order_date AS DATE) AS date_day,			
					COUNT(DISTINCT user_id_) AS DAU
					FROM orders
					GROUP BY CAST(order_date AS DATE)),
																		
MAU AS (SELECT CAST(DATEADD(MONTH, DATEDIFF(MONTH, 0, order_date), 0) AS DATE) AS date_month,
					COUNT(DISTINCT user_id_) AS MAU
					FROM orders
					GROUP BY CAST(DATEADD(MONTH, DATEDIFF(MONTH, 0, order_date), 0) AS DATE)),

DAU_MAU AS (SELECT d.date_day,
					m.date_month,
					d.DAU,
					m.MAU,
					CAST(d.DAU * 1.0 / m.MAU AS DECIMAL(5,2)) AS adherencia
					FROM DAU d
					JOIN MAU m
					ON DATEPART(YEAR, d.date_day) = DATEPART(YEAR, m.date_month)
					AND DATEPART(MONTH, d.date_day) = DATEPART(MONTH, m.date_month))
					
SELECT date_month,
		CAST(ROUND(AVG(adherencia * 1.0),2) AS DECIMAL(5,2)) AS avg_dau_mau
		FROM DAU_MAU
		GROUP BY date_month
		ORDER BY date_month


				-- 11. Tasa de crecimiento anual
				
WITH revenues AS (
					SELECT CAST(DATEADD(YEAR, DATEDIFF(YEAR, 0, order_date), 0) AS DATE) AS date_year,
					SUM(sales_qty * sales_amount) AS revenue
					FROM orders
					GROUP BY CAST(DATEADD(YEAR, DATEDIFF(YEAR, 0, order_date), 0) AS DATE)),
revenues_with_lag AS (
						SELECT date_year, 
						revenue,
						LAG(revenue, 1, revenue) -- Si no hay valor anterior, usa el mismo ingreso
						OVER (ORDER BY date_year ASC) AS last_revenue 
						FROM revenues)

						SELECT date_year, 
								CAST(ROUND((revenue - last_revenue) * 1.0 /last_revenue, 2)*100 AS DECIMAL(15,2)) AS growth
								FROM revenues_with_lag
								ORDER BY date_year ASC

		