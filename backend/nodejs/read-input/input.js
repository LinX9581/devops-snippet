const readline = require('readline');
rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

function question(theQuestion) {
    return new Promise(resolve => rl.question(theQuestion, answ => resolve(answ)))
}

async function askQuestions() {
    var c = await question("c:")
    var n = await question("n:")
    let tmpPrice = 0;
    let buyMySelf = 0;
    let friendlyCoe = 0;
    let friendlyPrice = 0;
    let cost = 0;
    let totalGet = 0;
    for (let i = 0; i < n; i++) {
        var price = await question("p:")
        var item = await question("x:")
        console.log(i);
        if (item > 7 & item < 18) {
            if (item == 8 | item == 9) {
                buyMySelf = (10 - item) * (price - price * 0.9)
                item = 10
            }
            friendlyCoe = 30
            cost += price * 0.9 * item
            totalGet += friendlyCoe * item + buyMySelf;
        } else if (item > 17) {
            if (item == 18 | item == 19) {
                buyMySelf = (20 - item) * (price - price * 0.8)
                item = 20
            }
            friendlyCoe = 50
            cost += price * 0.8 * item
            totalGet += friendlyCoe * item + buyMySelf;
        } else {
            cost += price * item
        }
        // totalGet -= c;
        console.log(cost);
        console.log(totalGet);
    }
}
askQuestions()