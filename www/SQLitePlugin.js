var exec = require('cordova/exec');

exports.coolMethod = function (arg0, success, error) {
  exec(success, error, 'SQLitePlugin', 'coolMethod', [arg0]);
};

exports.createTableWithQuery = function (arg0, success, error) {
  exec(success, error, 'SQLitePlugin', 'createTableWithQuery', [arg0]);
};

exports.insert = function (
  query,
  id,
  username,
  userpassword,
  firstname,
  lastname,
  usertype,
  taskActive,
  tasks,
  success,
  error
) {
  exec(success, error, 'DemoPlugin', 'insert', [
    query,
    id,
    username,
    userpassword,
    firstname,
    lastname,
    usertype,
    taskActive,
    tasks,
  ]);
};
