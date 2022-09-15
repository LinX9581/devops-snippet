const util = require('util');
const exec = util.promisify(require('child_process').exec);

test()
async function test() {
    let ip = '34.92.123.9'
    const { stdout, stderr } = await exec(`gcloud compute firewall-rules describe denyip --format="value(sourceRanges)" |awk {'print $1'} | sed 's/;/,/g'`);
    console.log(stdout);
    await exec(`gcloud compute firewall-rules update denyip --source-ranges=` + ip + "," + stdout);
}

// "dependencies": {
//     "@google-cloud/compute": "^3.1.2",
//     "child_process": "^1.0.2",
//     "util": "^0.12.4"
//   }