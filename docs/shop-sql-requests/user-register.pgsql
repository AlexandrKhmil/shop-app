-- Register user

-- If returns 0
SELECT COUNT(1)
FROM "user"
WHERE u_email = 'myEmail';

-- Add new user
INSERT INTO "user"(u_email, u_password) 
	VALUES ('newEmail', 'newPassword');

-- Return user's id and create_time
SELECT u_id, u_create_time 
FROM "user"
ORDER BY u_id DESC LIMIT 1;