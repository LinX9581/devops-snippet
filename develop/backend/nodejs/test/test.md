yarn add jest --dev

sum.js
function sum(a, b) {
  return a + b;
}
module.exports = sum;

sum.test.js
const sum = require('./sum');

it('adds 1 + 2 to equal 3', () => {
  expect(sum(1, 2)).toBe(3);
});

npx jest

預設會去抓 所有.test的檔案

# 參數 & 設定檔
jest.config.js
module.exports = {
  testMatch: ['**/(*.)unit.js'],
};


* 包含minus的檔案
npx jest --findRelatedTests minus.js
* 測試覆蓋率
npx jest --coverage
* 持續監聽
npx jest --watch