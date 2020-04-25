DELETE FROM public.review
	WHERE rate_id = (SELECT rate_id FROM rate WHERE u_id = 1 AND p_id = 1);