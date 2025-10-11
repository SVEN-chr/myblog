'use strict';

const pattern = /[\u001B\u009B][[\]()#;?]*(?:\d{1,4}(?:;\d{0,4})*)?[0-9A-ORZcf-nqry=><~]/g;

function stripAnsi(input) {
  if (input === null || input === undefined) {
    return '';
  }

  const string = String(input);
  return string.replace(pattern, '');
}

module.exports = stripAnsi;
module.exports.default = stripAnsi;
