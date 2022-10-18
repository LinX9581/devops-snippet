let a = [0, 1, 2];
// console.log(a[1 + 1]);

// var romanToInt = function(s) {
//     let total = 0;
//     for (let i = 0; i < s.length; i++) {
//         if (s[i] == "I" && s[i + 1] == "V") {
//             total += 4;
//             i += 1;
//         } else if (s[i] == "I" && s[i + 1] == "X") {
//             total += 9;
//             i += 1;
//         } else if (s[i] == "X" && s[i + 1] == "L") {
//             total += 40;
//             i += 1;
//         } else if (s[i] == "X" && s[i + 1] == "C") {
//             total += 90;
//             i += 1;
//         } else if (s[i] == "C" && s[i + 1] == "D") {
//             total += 400;
//             i += 1;
//         } else if (s[i] == "C" && s[i + 1] == "M") {
//             total += 900;
//             i += 1;
//         } else if (s[i] == "I") {
//             total += 1;
//         } else if (s[i] == "V") {
//             total += 5;
//         } else if (s[i] == "X") {
//             total += 10;
//         } else if (s[i] == "L") {
//             total += 50;
//         } else if (s[i] == "C") {
//             total += 100;
//         } else if (s[i] == "D") {
//             total += 500;
//         } else if (s[i] == "M") {
//             total += 1000;
//         }
//     }
//     return total;
// };

var romanToInt = function(s) {
    const map = { I: 1, V: 5, X: 10, L: 50, C: 100, D: 500, M: 1000 }
    let res = 0;
    s.split('').forEach((num, i) => {
        if (map[num] < map[s[i + 1]]) res -= map[num];
        else res += map[num]
    });
    return res
};



console.log(romanToInt("MCMXCIV"));

//MCMXCIV
// Symbol       Value
// I             1
// V             5
// X             10
// L             50
// C             100
// D             500
// M             1000

// I V X minus
// X L C
// C D M minus