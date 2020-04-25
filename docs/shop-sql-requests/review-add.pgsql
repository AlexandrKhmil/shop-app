INSERT INTO public.review(
	rev_title, rev_text, rate_id)
	VALUES ('Заголовок', 'Текст', (SELECT rate_id FROM rate WHERE u_id = 1 AND p_id = 1 ));