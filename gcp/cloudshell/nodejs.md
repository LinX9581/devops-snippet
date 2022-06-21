## Nodejs 執行
各個nodejs範例[參考](https://googleapis.dev/nodejs/compute/latest/VM.html#start)

const Compute = require('@google-cloud/compute');
const compute = new Compute();
const zone = compute.zone('asia-northeast3-a');
const vm = zone.vm('korea');

vm.start(function(err, operation, apiResponse) {
  // `operation` is an Operation object that can be used to check the status
  // of the request.
});

//-
// If the callback is omitted, we'll return a Promise.
//-
vm.start().then(function(data) {
  const operation = data[0];
  const apiResponse = data[1];
});
