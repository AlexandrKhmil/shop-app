const { Router } = require('express');
const router = Router();
const config = require('config');
const jwtSecret = config.get('jwtSecret');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { check, body, validationResult } = require('express-validator')
const db = require('../connection');

// GET `api/user`
router.get('/', [
    check('token', 'Wrong token').exists()
  ],
  async (req, res) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(500).json({ errors: errors.array() });
      }

      const decodedToken = jwt.decode(req.headers.token, jwtSecret);
      const query = `
        SELECT
          u_email AS email
        FROM "user"
        WHERE u_id = $1;
      `;
      const result = await db.one(query, decodedToken.id)
        .then((data) => data)
        .catch((error) => ({ error }));
      if (result.error) {
        return res.status(500).json({ message: 'No such user' });
      }
      return res.status(200).json(result);
    } catch (e) {
      return res.status(500).json({ message: e });
    }
  });

// POST `api/user/login`
router.post('/login', [
    body('email', 'Wrong email').normalizeEmail().isEmail(),
    body('password', 'Wrong password').isLength({ min: 5 })
  ],
  async(req, res) => {
    try { 
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(500).json({ errors: errors.array() });
      }

      const { email, password } = req.body;
      const query = `
        SELECT
          u_id AS id,
          u_password AS password
        FROM "user"
        WHERE u_email = $1;
      `;
      const result = await db.one(query, email)
        .then((data) => data)
        .catch((error) => ({ error })); 

      if (result.error) {
        return res.status(500).json(result);
      } 
      const isMatch = await bcrypt.compare(password, result.password)
      if (!isMatch) {
        return res.status(500).json({ message: 'Wrong password' });
      }

      const token = jwt.sign(
        { id: result.id },
        jwtSecret,
        { expiresIn: '1h' }
      );
      return res.status(200).json({ token, email });
    } catch(e) { 
      return res.status(500).json({ message: e });
    }
  });


// POST `api/user/register`
router.post('/register', [
    check('email', 'Wrong email').normalizeEmail().isEmail(),
    check('password', 'Wrong password').isLength({ min: 5 })
  ],
  async(req, res) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(500).json({ errors: errors.array() });
      }

      const { email, password } = req.body;
      const hashedPassword = await bcrypt.hash(password, 12);
      const result = await db.func('user_register', [email, hashedPassword])
        .then(data => data[0].user_register)
        .catch(error => ({ error }));
      
      if (result.error) {
        return res.status(500).json({ message: 'User exists' });
      }
      const token = jwt.sign(
        { id: result },
        jwtSecret,
        { expiresIn: '1h' }
      );
      return res.status(200).json({ token, email });
    } catch(e) {
      return res.status(500).json({ message: e });
    }
  });


// POST `api/user/change-password`
router.post('/change-password', async(req, res) => {

});

module.exports = router;