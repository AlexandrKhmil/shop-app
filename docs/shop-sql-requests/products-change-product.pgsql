UPDATE public.product
	SET 
		p_parent=null, 
		pcat_id=1, 
		pst_id=1, 
		p_title='Новое название', 
		p_price=848, 
		p_description='Новое описание'
	WHERE p_id = 10;