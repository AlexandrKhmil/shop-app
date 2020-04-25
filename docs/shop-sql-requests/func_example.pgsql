CREATE FUNCTION public.user_auth_func(v_user_id bigint)
    RETURNS TABLE(u_email character varying, u_password character varying, u_create_time timestamp with time zone)
    LANGUAGE 'sql'
    
    
AS $BODY$
BEGIN
	RETURN QUERY SELECT u.u_email, u.u_password, u.u_create_time
		FROM "user" AS u
		WHERE u_id = v_user_id;
END;$BODY$;

ALTER FUNCTION public.user_auth_func(bigint)
    OWNER TO postgres;

-- Объявить JSON и извлечь из Array каждый JSON OBJECT в отдельный столбец

SELECT json_array_elements('[{"1":"10"},{"2":"30"},{"3":"5"}]'::json)

-- JSON TO RECORDSET

-- SELECT json_to_record(json_array_elements('[{"p_id": "1", "p_quantity": "10"},{"p_id": "2", "p_quantity": "5"}]'::json));

-- SELECT * 
-- 	FROM json_to_record(json_array_elements('[{"p_id": "1", "p_quantity": "10"},{"p_id": "2", "p_quantity": "5"}]'::json))
-- 		AS x(p_id integer, p_quantity integer);
		
-- SELECT json_to_record('{"1" : {"p_id": "1", "p_quantity": "10"}, "2" : {"p_id": "2", "p_quantity": "5"}}'::json)

select * From json_to_recordset('[{"a":1,"b":2},{"a":3,"b":4}]') AS x("a" int, "b" int);

-- SELECT TOTAL SUM

SELECT SUM(product_sum) AS total_sum
FROM (SELECT SUM(q.p_quantity * p.p_price) AS product_sum
	FROM (select * 
		From json_to_recordset('[{"p_id": "1", "p_quantity": "10"},{"p_id": "2", "p_quantity": "5"}]') 
			AS x("p_id" int, "p_quantity" int)) AS q
				INNER JOIN "product" AS p ON q.p_id = p.p_id
	GROUP BY q.p_id) AS sub_query; 

-- RETURN JSON

BEGIN
  RETURN (
    SELECT ROW_TO_JSON(query.*, false)
    FROM (SELECT u_email, u_create_time
          FROM "user"
          WHERE u_id = arg_user_id) as query
  );
END;