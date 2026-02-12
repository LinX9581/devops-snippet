const fs = require('fs')
test()
async function test() {
    fs.access('dump2.txt', fs.F_OK, (err) => {
        if(err){
            fs.appendFileSync('dump2.txt','')
        }
    })
}