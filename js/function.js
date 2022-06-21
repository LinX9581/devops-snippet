
asy()
async function asy(){

    let c = await test()
    console.log(c[1]);
}
async function test() {
    let a = ['1', '3', '5']
    let b = ['2', '4', '6']
    let d =[a,b]
    return d;
}

// console.log(c);