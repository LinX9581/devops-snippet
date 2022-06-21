const Compute = require('@google-cloud/compute');
const compute = new Compute();
const zone = compute.zone('asia-northeast3-a');
const vm = zone.vm('korea');

const zone = 'some-zone';
const name = 'a-name';
const sourceInstanceTemplate = `some-template-name`;
createVM(zone, name, sourceInstanceTemplate)
    .then(console.log)
    .catch(console.error);

async function createVM(zone, vmName, templateName) {
    const { auth } = require('google-auth-library');
    const client = await auth.getClient({
        scopes: 'https://www.googleapis.com/auth/cloud-platform'
    });
    const projectId = await auth.getDefaultProjectId();

    const sourceInstanceTemplate = `projects/${projectId}/global/instanceTemplates/${templateName}`;
    const url = `https://www.googleapis.com/compute/v1/projects/${projectId}/zones/${zone}/instances?sourceInstanceTemplate=${sourceInstanceTemplate}`;
    let a = ''
    if (a == 1) {
        if (a == 2) {

        }
    }
    return await client.request({
        url: url,
        method: 'post',
        data: { name: vmName }
    });
}