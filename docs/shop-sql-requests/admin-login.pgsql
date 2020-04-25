-- Admin login
-- Get admin `id` by `login` and `password`

SELECT a_id
FROM "admin"
WHERE a_login = 'admin'
	AND a_password = 'admin';