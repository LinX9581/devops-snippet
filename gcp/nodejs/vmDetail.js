
const { exec } = require('child_process');
const { google } = require('googleapis')
const keys = require('./gsKey.json');

//gSheet 授權
const gsClient = new google.auth.JWT(
    keys.client_email, null, keys.private_key, ['https://www.googleapis.com/auth/spreadsheets']
)
gsClient.authorize(function (err, tokens) {
    if (err) {
        console.log("Google Sheet Err" + err);
        return;
    } else {
        console.log('Week Data Google Sheet Connected!')
    }
})
//gcloud config set project [project name]
// getVmFirewall()
async function getVmFirewall(){
    exec(`gcloud compute firewall-rules list --format="table(name,network,DIRECTION,PRIORITY,ALLOW,DISABLED,targetTags.list():label=TARGET_TAGS,DENY)"`, async function(err, stdout) {
        if (err) {
            return;
        }
        let vmListArray = stdout.split(/\n/)
        let eachVm = []
        console.log(vmListArray);
        for (let i = 0; i < vmListArray.length; i++) {
            await sleep(300)
            eachVm = vmListArray[i].replace(/, /g, ':').replace(/,t/g, '-t').replace(/\s+/g, ',').split(',')
            vmInfoToGSheet(eachVm, i + 1)
        }
        async function vmInfoToGSheet(eachVm, i) {
            await updateGsSheet(gsClient, 'firewall' + '!A' + i, [eachVm])
        }
    });
}

// getVmList()
async function getVmList(){
    exec(`gcloud compute instances list --format="table(name,status,zone,MACHINE_TYPE,INTERNAL_IP,EXTERNAL_IP)"`, async function(err, stdout) {
        if (err) {
            return;
        }
        let vmListArray = stdout.split(/\n/)
        let eachVm = []
        for (let i = 0; i < vmListArray.length; i++) {
            await sleep(300)
            eachVm = vmListArray[i].replace(/m /g, 'm:').replace(/ v/g, ':').replace(/, /g, ':').replace(/=,/g, '=').replace(/ G/g, ':G').replace(/\s+/g, ',').split(',')
            vmInfoToGSheet(eachVm, i + 1)
        }
        async function vmInfoToGSheet(eachVm, i) {
            await updateGsSheet(gsClient, 'gce' + '!A' + i, [eachVm])
        }
    });
}

async function updateGsSheet(gsClient, range, values) {
    const gsapi = google.sheets({ version: 'v4', auth: gsClient });
    const updateOptions = {
        spreadsheetId: '1sCT6XeMbfEvT4ivVnLEvHCTqzmfsxpOn0uH9NSp0yYM',
        range: range,
        valueInputOption: 'USER_ENTERED',
        resource: { values: values }
    }
    await gsapi.spreadsheets.values.update(updateOptions)
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}
