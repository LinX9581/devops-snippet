const util = require('util');
const exec = util.promisify(require('child_process').exec);

test()
async function test() {
    const { stdout, stderr } = await exec('dir');
    console.log(stdout);
}

// exec(`dir`, (err, stdout, stderr) => {
//     if (err) {
//         return;
//     }
//     console.log("db-backup")
//     console.log(`stdout: ${stdout}`);
//     console.log(`stderr: ${stderr}`);
// });