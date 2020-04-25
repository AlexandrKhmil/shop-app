UPDATE public.review
	SET rev_title='Новый заголовок', rev_text='Новый текст'
	WHERE rate_id = (SELECT rate_id FROM rate WHERE u_id = 1 AND p_id = 1);