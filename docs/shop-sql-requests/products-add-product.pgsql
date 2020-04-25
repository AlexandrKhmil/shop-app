-- Add new product

CREATE OR REPLACE PROCEDURE public.product_create_proc(
	arg_name character varying,
	arg_price money,
	arg_description text,
	arg_category smallint,
	arg_status smallint,
	arg_parent bigint,
	arg_tags bigint[])
LANGUAGE 'plpgsql'

AS $BODY$
DECLARE
	var_id integer;

BEGIN
	INSERT INTO "product"(
		p_parent, pcat_id, pst_id, p_title, p_price, p_description)
		VALUES (arg_parent, arg_category, arg_status, arg_name, arg_price, arg_description);
		
	var_id = currval('product_p_id_seq');
	
	INSERT INTO "product_has_tag" SELECT var_id AS p_id, unnest(arg_tags::bigint[]) AS ptag_id;
END;$BODY$;

-- DO$$
-- DECLARE
-- 	v_a integer;

-- BEGIN
-- 	INSERT INTO "product"(
-- 		p_parent, pcat_id, pst_id, p_title, p_price, p_description)
-- 		VALUES (null, 1, 1, 'Название', 100.50, 'Описание');
		
-- 	v_a = currval('product_p_id_seq');
	
-- 	INSERT INTO "product_has_tag"(
-- 		p_id, ptag_id)
-- 		VALUES (v_a, 1);
-- END;$$

-- --

-- DECLARE
-- 	var_a integer;

-- BEGIN
-- 	INSERT INTO "product"(
-- 		pcat_id, pst_id, p_title, p_price, p_description)
-- 		VALUES (arg_category, arg_status, arg_name, arg_price, arg_description);
		
-- 	var_a = currval('product_p_id_seq');
	
-- 	INSERT INTO "product_has_tag"(
-- 		p_id, ptag_id)
-- 		VALUES (var_a, 1);
-- END;$$