const { Router } = require('express');
const router = Router();
const { check, body, validationResult } = require('express-validator')
const db = require('../connection');

// GET `/api/product`
router.get('/',
  async (req, res) => {
    try {
      const { 
        limit = 10,
        offset = 0,
      } = req.headers;
      const query = `
        SELECT 
          p.p_id AS id,
          p.p_title AS title,
          p.p_price AS price,
          p.p_description AS description,
          p.p_create_time AS create_time,
          pcat.pcat_title AS category,
          AVG(rate_value) AS rate,
          COUNT(rate_value) AS votes_count,
          COUNT(rev_id) AS reviews_count,
          array(SELECT ptag.ptag_title
                FROM product_has_tag as pht
                  INNER JOIN product_tag AS ptag ON ptag.ptag_id = pht.ptag_id
                WHERE pht.p_id = p.p_id) AS tags
        FROM "product" AS p
          LEFT JOIN product_category AS pcat ON pcat.pcat_id = p.pcat_id
          LEFT JOIN rate AS r ON p.p_id = r.p_id
          LEFT JOIN review AS rev ON rev.rate_id = r.rate_id
          LEFT JOIN product_has_tag AS pht ON p.p_id = pht.p_id
        WHERE pst_id = 1 AND p.p_parent IS NULL
        GROUP BY p.p_id, pcat.pcat_title
        ORDER BY p.p_id LIMIT $1 OFFSET $2;
      `;
      const result = await db.any(query, [limit, offset])
        .then((data) => data)
        .catch((error) => ({ error }));

      if (result.error) {
        return res.status(500).json({ error: result.error });
      }
      return res.status(200).json(result);
    } catch(e) {
      return res.status(500).json({ error: e });
    }
  }
);

// GET `/api/products/{id}/`
router.get('/:id',
  async (req, res) => {
    try {
      const id = req.params.id;
      const query = `
        SELECT 
          p.p_id AS id,
          p.p_title AS title,
          p.p_price AS price,
          p.p_description AS description,
          p.p_create_time AS create_time,
          pcat.pcat_title AS category,
          AVG(rate_value) AS rate,
          COUNT(rate_value) AS votes_count,
          COUNT(rev_id) AS reviews_count,
          array(SELECT ptag.ptag_title
                FROM product_has_tag as pht
                  INNER JOIN product_tag AS ptag ON ptag.ptag_id = pht.ptag_id
                WHERE pht.p_id = p.p_id) AS tags,
          (SELECT json_agg(query)
           FROM (SELECT 
                   review.*,
                   COUNT(review_like.rev_id) AS rev_likes
                 FROM review
                   INNER JOIN rate ON rate.rate_id = review.rate_id
                   LEFT JOIN review_like ON review.rev_id = review_like.rev_id
                 WHERE rate.p_id = p.p_id
                 GROUP BY review.rev_id) AS query) AS review
        FROM product AS p
          LEFT JOIN product_category AS pcat ON pcat.pcat_id = p.pcat_id
          LEFT JOIN rate ON p.p_id = rate.p_id
          LEFT JOIN review AS rev ON rev.rate_id = rate.rate_id
          LEFT JOIN product_has_tag AS pht ON p.p_id = pht.p_id
        WHERE p.p_id = $1 AND pst_id = 1
        GROUP BY p.p_id, pcat.pcat_title;
      `;
      const result = await db.any(query, id)
        .then((data) => data)
        .catch((error) => ({ error }));
      return res.status(200).json(result);
    } catch(e) {
      return res.status(500).json({ error: e });
    }
  }
);

// POST `/api/products/{productId}/rate`

// PUT `/api/products/{productId}/rate`

// DELETE `/api/products/{productId}/rate`

// GET `/api/products/{productId}/review`

// POST `/api/products/{productId}/review`

// PUT `/api/products/{productId}/review`

// DELETE `/api/products/{productId}/review`

// POST `/api/products/{productId}/review/like`

module.exports = router;