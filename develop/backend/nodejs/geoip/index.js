const { exec } = require('child_process');
const schedule = require('node-schedule');
const moment = require('moment');
const util = require('util');
const execProm = util.promisify(exec);
const fs = require('fs');
var geoip = require('geoip-lite');

async function getTopIp() {
    let checkAttackTime = new moment().add(-1, 'hours').format('HH:');
    let attackIpArray = [],
        directAttackIpArray = []
    let attackStatus = 0;
    let top10Ip;
    top10Ip = await execProm(`grep "16/Jul/2022:[18,19,20,21]" /var/www/atomip.log | awk '{print $NF}' | sort | uniq -c | sort -nr`);
    let top10Split = top10Ip.stdout.split('\n')
    for (const ipItem of top10Split) {
        attackIpArray.push(ipItem.trim().replace(/"/g, "").split(' ')[1])
    }
    fs.appendFile('/var/www/atomip1.json', attackIpArray, function(error) {
        if (error) console.log(error)
    })
}

test()
async function test() {
    let atomIpArray = []
    let countryArray = []
    let cityArray = []
    let geo = ''
    let atomIpObj = []
    fs.readFile('/var/www/atomip1.json', 'utf8', (err, data) => {
        if (err) {
            console.error(err);
            return;
        }
        atomIpArray.push(data.split(','))
        for (let i = 1; i < atomIpArray[0].length - 1; i++) {
            geo = geoip.lookup(atomIpArray[0][i]);
            if (geo != null) {
                if (geo.region != '') {
                    if (geo.country == 'TW') {
                        atomIpObj.push({ 'ip': atomIpArray[0][i], 'country': geo.country, 'city': geo.region })
                        countryArray.push(geo.country)
                        cityArray.push(geo.region)
                    }
                }
            }
        }
        // console.log(atomIpObj);
        let cityCount = {}
        for (const num of atomIpObj) {
            cityCount[num.city] = cityCount[num.city] ? cityCount[num.city] + 1 : 1;
        }
        let cityObj = []
        let cityChange = {
            "KHH": "Kaohsiung",
            "TPE": "Taipei",
            "CYI": "Chiayi",
            "CYQ": "ChiayiCounty",
            "HSZ": "Hsinchu",
            "HSQ": "HsinchuCounty",
            "KEE": "Keelung",
            "TXG": "Taichung",
            "TNN": "Tainan",
            "CHA": "Changhua",
            "HUA": "Hualien",
            "ILA": "Ilan",
            "MIA": "Miaoli",
            "NAN": "Nantou",
            "PEN": "Penghu",
            "PIF": "Pingtung",
            "TTT": "Taitung",
            "TAO": "Taoyuan",
            "YUN": "Yunlin",
            "KIN": "Kinmen",
            "LIE": "LienchiangCounty",
        }
        let tmpArray = []
        for (const oriKey in cityCount) {
            for (const afterKey in cityChange) {
                tmpArray.push(afterKey)
                if (oriKey == afterKey) {
                    cityObj.push({ 'city': cityChange[afterKey], 'count': cityCount[oriKey] })
                }
            }
        }
        let total = 0;
        for (const key of cityObj) {
            total += key.count
        }
        console.log(cityObj);
        console.log(total);
    });
}