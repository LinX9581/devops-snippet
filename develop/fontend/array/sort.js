

let c = ['24433', '19080', '83974', '315299', '23209', '379388', '99902', '3645', '6664', '10467', '1110895']
// let c = [40, 20, 50, 10, 30];
c.map(Number);
console.log(c);
c.sort(function (a, b) {
    return parseInt(a) - parseInt(b); 
});
console.log(c.sort());
