-- Register user

--
DECLARE
  v_isExist boolean;

BEGIN
  v_isExist = (SELECT COUNT(1) > 0
               FROM "user"
               WHERE u_email = arg_user_email);

  IF (v_isExist) THEN
  	RAISE 'USER EXIXSTS';
  END IF;

  INSERT INTO "user" (u_email, u_password)
    VALUES (arg_user_email, arg_user_password);
  RETURN currval('user_u_id_seq');
END;

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