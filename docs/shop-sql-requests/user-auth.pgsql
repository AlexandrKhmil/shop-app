-- Select user by specified ID

SELECT
  u_email AS email,
  u_password AS password
FROM "user"
WHERE u_id = $1;

--

BEGIN
  RETURN (
    SELECT ROW_TO_JSON(query.*, false)
    FROM (SELECT u_email, u_create_time
          FROM "user"
          WHERE u_id = arg_user_id) as query
  );
END;

-- CALL

SELECT user_auth_func(arg_user_id integer>);