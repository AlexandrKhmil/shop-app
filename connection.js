const pgp = require('pg-promise')();
const config = require('config');
const db = pgp(config.get('db'));

module.exports = db;