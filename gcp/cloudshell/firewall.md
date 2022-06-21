# 所有防火牆清單
gcloud compute firewall-rules list

# 爬取現有阻擋的所有IP，已該IP+上新阻擋的IP，更新防火牆
const util = require('util');
const exec = util.promisify(require('child_process').exec);

test()
async function test() {
    let ip = '34.92.123.9'
    const { stdout, stderr } = await exec(`gcloud compute firewall-rules describe denyip --format="value(sourceRanges)" |awk {'print $1'} | sed 's/;/,/g'`);
    console.log(stdout);
    await exec(`gcloud compute firewall-rules update denyip --source-ranges=` + ip + "," + stdout);
}
# 更詳細的
```
gcloud compute firewall-rules list --format="table(
        name,
        network,
        direction,
        priority,
        sourceRanges.list():label=SRC_RANGES,
        destinationRanges.list():label=DEST_RANGES,
        allowed[].map().firewall_rule().list():label=ALLOW,
        denied[].map().firewall_rule().list():label=DENY,
        sourceTags.list():label=SRC_TAGS,
        sourceServiceAccounts.list():label=SRC_SVC_ACCT,
        targetTags.list():label=TARGET_TAGS,
        targetServiceAccounts.list():label=TARGET_SVC_ACCT,
        disabled
    )"
```
