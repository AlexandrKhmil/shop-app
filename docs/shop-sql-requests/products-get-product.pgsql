SELECT p.*,
	AVG(rate_value) p_rate, 
	COUNT(rate_value) AS p_votes_count,
	COUNT(rev_id) AS p_reviews_count,
	ARRAY(SELECT ptag_id
		FROM product_has_tag AS pht
		WHERE pht.p_id = p.p_id) AS p_tag,
	(SELECT json_agg(review) 
		FROM review
			INNER JOIN rate ON rate.rate_id = review.rate_id
		WHERE rate.p_id = p.p_id
	) AS p_review
FROM product AS p
	LEFT JOIN rate ON p.p_id = rate.p_id
	LEFT JOIN review AS rev ON rev.rate_id = rate.rate_id
	LEFT JOIN product_has_tag AS pht ON p.p_id = pht.p_id
WHERE p.p_id = 3 AND pst_id = 1
GROUP BY p.p_id;

-- WITH LIKES

SELECT p.*,
	AVG(rate_value) p_rate, 
	COUNT(rate_value) AS p_votes_count,
	COUNT(rev_id) AS p_reviews_count,
	ARRAY(SELECT ptag_id
		FROM product_has_tag AS pht
		WHERE pht.p_id = p.p_id) AS p_tag,
	(SELECT json_agg(t) 
	 FROM (SELECT review.*, COUNT(review_like.rev_id) AS rev_likes
		   FROM review
		   	   INNER JOIN rate ON rate.rate_id = review.rate_id
	 	   	   LEFT JOIN review_like ON review.rev_id = review_like.rev_id
 		   WHERE rate.p_id = p.p_id
	 	   GROUP BY review.rev_id) AS t) AS p_review
FROM product AS p
	LEFT JOIN rate ON p.p_id = rate.p_id
	LEFT JOIN review AS rev ON rev.rate_id = rate.rate_id
	LEFT JOIN product_has_tag AS pht ON p.p_id = pht.p_id
WHERE p.p_id = 1 AND pst_id = 1
GROUP BY p.p_id;