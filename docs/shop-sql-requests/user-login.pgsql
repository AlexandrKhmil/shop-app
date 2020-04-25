-- Select user by email

SELECT
	u_id,
	u_email,
	u_password,
	u_create_time
FROM "user"
WHERE u_email = 'myEmail';