SELECT p.*, 
	AVG(rate_value) p_rate, 
	COUNT(rate_value) AS p_votes_count,
	COUNT(rev_id) AS p_reviews_count,
	array(SELECT ptag_id
		FROM product_has_tag AS pht
		WHERE pht.p_id = p.p_id) AS p_tag
FROM product AS p
	LEFT JOIN rate ON p.p_id = rate.p_id
	LEFT JOIN review AS rev ON rev.rate_id = rate.rate_id
	LEFT JOIN product_has_tag AS pht ON p.p_id = pht.p_id
WHERE pst_id = 1
GROUP BY p.p_id
ORDER BY p.p_id LIMIT 5 OFFSET 0;