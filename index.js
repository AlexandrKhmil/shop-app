const express = require('express');
const app = express();
const port = 3000;



var pgp = require('pg-promise')();
const db = pgp('postgres://postgres:root@localhost:5432/flower-shop');

app.get('/', (req, res) => {
  db.one('SELECT $1 AS value', 123)
    .then(function (data) {
      res.send('DATA: ' + data.value);
    })
    .catch(function (error) {
      console.log('ERROR:', error)
    });
});

app.listen(port, () =>
  console.log(`Example app listening at http://localhost:${port}`)
);