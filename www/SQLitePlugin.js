var exec = require('cordova/exec');

exports.coolMethod = function (arg0, success, error) {
  exec(success, error, 'SQLitePlugin', 'coolMethod', [arg0]);
};

exports.createTableWithQuery = function (arg0, success, error) {
  exec(success, error, 'SQLitePlugin', 'createTableWithQuery', [arg0]);
};
