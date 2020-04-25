const { Router } = require('express');
const router = Router();
const db = require('../connection');

// GET `api/user`
router.get('/', async (req, res) => {
  try {
    const token = req.headers.user_token;
    if (token) {
      const decodeToken = token; // decode
      const query = `
        SELECT
          u_email AS email,
          u_password AS password
        FROM "user"
        WHERE u_id = $1;
      `;
      db.any(query, decodeToken)
        .then((data) => {
          return data[0]
            ? res.status(200).json({ ...data })
            : res.status(500).json({ message: 'Нет такого пользователя'});
        })
        .catch((error) => {
          console.log('error');
        });  
    } else {
      return res.status(200).json({ message : 'No token'});
    } 
  } catch (e) {
    return res.status(500).json({ message: 'Ошибка' });
  }
});

// POST `api/user/login`
router.post('/login', async(req, res) => {
  try {

  } catch(e) {
    return res.status(500).jsoin({ message: 'Ошибка '});
  }
});


// POST `api/user/register`
router.post('/register', async(req, res) => {

});


// POST `api/user/change-password`
router.post('/change-password', async(req, res) => {

});

module.exports = router;