-- Процедура: Создать заказ и добавить все товары из списка в его содержимое
-- SELECT '[{"p_id": "1", "p_quantity": "10"}]'::json 
-- Пример JSON

CREATE OR REPLACE PROCEDURE public.order_create_proc(
	arg_u_id integer,
	arg_product_list json)
LANGUAGE 'plpgsql'

AS $BODY$
DECLARE
	var_id integer;
	var_cart SETOF RECORD;
	var_total money;

BEGIN
	-- Transaction
	SET AUTOCOMMIT = OFF;
	BEGIN
		-- Get cart from `json`
		var_cart = SELECT * 
							 FROM json_to_recordset(arg_product_list) 
								 AS x("p_id" int, "p_quantity" int);

		-- Get total sum from `var_cart` and `product` table
		var_total = SELECT SUM(product_sum) AS total_sum
								FROM (SELECT SUM(jr.p_quantity * p.p_price) AS product_sum
											FROM var_cart AS jr
												INNER JOIN "product" AS p
													ON jr.p_id = p.p_id
											GROUP BY jr.p_id
										 ) AS list_product_sum;

		-- Add new order to `order` table
		INSERT INTO "order"(u_id, o_total_price)
			VALUES (arg_u_id, var_total);

		-- Get inserted `id`
		var_id = currval('order_o_id_seq');
		
		-- Add products to `order_has_product` table
		INSERT INTO "product_has_tag" 
			SELECT * FROM var_cart;
	COMMIT;
	SET AUTOCOMMIT = ON;
END;$BODY$;

--

CREATE OR REPLACE PROCEDURE public.order_create_proc(
	arg_u_id integer,
	arg_product_list json)
LANGUAGE 'plpgsql'

AS $$
DECLARE
	var_id integer;
	var_cart RECORD;
	var_total money;

BEGIN
	-- Transaction
	SET AUTOCOMMIT = OFF;
	BEGIN
		-- Get cart from `json`
		var_cart = (SELECT * FROM json_to_recordset(arg_product_list) 
								 AS x("p_id" int, "p_quantity" int));

		-- Get total sum from `var_cart` and `product` table
		var_total = (SELECT SUM(product_sum) AS total_sum
								FROM (SELECT SUM(jr.p_quantity * p.p_price) AS product_sum
											FROM var_cart AS jr
												INNER JOIN "product" AS p
													ON jr.p_id = p.p_id
											GROUP BY jr.p_id
										 ) AS list_product_sum);

		-- Add new order to `order` table
		INSERT INTO "order"(u_id, o_total_price)
			VALUES (arg_u_id, var_total);

		-- Get inserted `id`
		var_id = currval('order_o_id_seq');
		
		-- Add products to `order_has_product` table
		INSERT INTO "product_has_tag" 
			SELECT * FROM var_cart;
	COMMIT;
	SET AUTOCOMMIT = ON;
END; $$;

---

DECLARE
	var_id integer;
	var_cart record;
	var_total money;

BEGIN
-- Transaction
	SET AUTOCOMMIT = OFF;
	BEGIN TRANSACTION
		-- Get cart from `json`
		var_cart = (SELECT * FROM json_to_recordset(arg_product_list) 
								 AS x("p_id" int, "p_quantity" int));

		-- Get total sum from `var_cart` and `product` table
		var_total = (SELECT SUM(product_sum) AS total_sum
								FROM (SELECT SUM(jr.p_quantity * p.p_price) AS product_sum
											FROM var_cart AS jr
												INNER JOIN "product" AS p
													ON jr.p_id = p.p_id
											GROUP BY jr.p_id
										 ) AS list_product_sum);

		-- Add new order to `order` table
		INSERT INTO "order"(u_id, o_total_price)
			VALUES (arg_u_id, var_total);

		-- Get inserted `id`
		var_id = currval('order_o_id_seq');
		
		-- Add products to `order_has_product` table
		INSERT INTO "product_has_tag" 
			SELECT * FROM var_cart;
	COMMIT;
	SET AUTOCOMMIT = ON;
END;

-- FINAL

CREATE OR REPLACE PROCEDURE public.order_create_proc(
	arg_u_id integer,
	arg_product_list json)
LANGUAGE 'plpgsql'
AS $$
DECLARE
	var_id integer; 
	var_total money;

BEGIN
		-- Get cart from `json`
		CREATE TEMP TABLE temp_cart AS 
			(SELECT * FROM json_to_recordset(arg_product_list) 
				AS x("p_id" int, "p_quantity" int));

		-- Get total sum from `var_cart` and `product` table
		var_total = (SELECT SUM(product_sum) AS total_sum
								FROM (SELECT SUM(jr.p_quantity * p.p_price) AS product_sum
											FROM temp_cart AS jr
												INNER JOIN "product" AS p
													ON jr.p_id = p.p_id
											GROUP BY jr.p_id
										 ) AS list_product_sum);

		-- Add new order to `order` table
		INSERT INTO "order"(u_id, o_total_price)
			VALUES (arg_u_id, var_total);

		-- Get inserted `id`
		var_id = currval('order_o_id_seq');
		
		-- Add products to `order_has_product` table
		INSERT INTO "order_has_product" 
			SELECT var_id AS o_id, * FROM temp_cart;
		
		-- Drop temp table
		DROP TABLE temp_cart;
END;$$