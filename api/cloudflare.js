var request = require('request');

// 取得record id
var findRecordId = {
    'method': 'GET',
    'url': 'https://api.cloudflare.com/client/v4/zones/406b4be1ebb87158be3737bda39b4820/dns_records?type=A&name=web.linxnote.club&content=104.155.232.195&page=1&per_page=20&order=type&direction=desc&match=all',
    'headers': {
        'X-Auth-Email': 'test@gmail.com',
        'X-Auth-Key': '44d80b95daccdfad5c2310eb135ff7d583197',
        'Content-Type': 'application/json',
    }
};
request(findRecordId, function(error, response) {
    if (error) throw new Error(error);
    let recordId = JSON.parse(response.body);
    console.log(recordId.result[0].id)
});

//更改Record
var updateRecord = {
    'method': 'PUT',
    'url': 'https://api.cloudflare.com/client/v4/zones/406b4be1ebb87158be3737bda39b4820/dns_records/c549977224e5f4a8dbe3c43082011312',
    'headers': {
        'X-Auth-Email': 'test@gmail.com',
        'X-Auth-Key': '44d80b95daccdfad5c2310eb135ff7d583197',
        'Content-Type': ['application/json', 'text/plain'],
        'Cookie': '__cfduid=d170406460291f92592ea8579c6ade16f1589458092'
    },
    body: "{\"type\":\"A\",\"name\":\"web.linxnote.club\",\"content\":\"104.155.232.195\",\"proxied\":true}"

};
request(updateRecord, function(error, response) {
    if (error) throw new Error(error);
    console.log(response.body);
});