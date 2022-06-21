const Compute = require('@google-cloud/compute');
const schedule = require('node-schedule')
const compute = new Compute();
const vmZoneList = ['asia-northeast3-a', 'asia-east1-b'] //vm zone
const vmList = ['korea', 'connect-test'] //vm name
schedule.scheduleJob('0 0 19 * * *', async function() {
    for (let i = 0; i < vmList.length; i++) {

        const zone = compute.zone(vmZoneList[i]);
        const vm = zone.vm(vmList[i]);

        vm.stop(function(err, operation, apiResponse) {
            // `operation` is an Operation object that can be used to check the status
            // of the request.

            vm.stop().then(function(data) {
                console.log(vmList[i] + 'start');
                const operation = data[0];
                const apiResponse = data[1];
            });
        });
    }
})
schedule.scheduleJob('0 0 10 * * *', async function() {
    for (let i = 0; i < vmList.length; i++) {

        const zone = compute.zone(vmZoneList[i]);
        const vm = zone.vm(vmList[i]);

        vm.start(function(err, operation, apiResponse) {
            // `operation` is an Operation object that can be used to check the status
            // of the request.

            vm.start().then(function(data) {
                console.log(vmList[i] + 'stop');
                const operation = data[0];
                const apiResponse = data[1];
            });
        });
    }
})