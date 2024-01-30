let array1 = [
    ['post1', '1', '2', '5'],
    ['post1', 'fb', 'nn', '3'],
    ['post1', 'fb', 'nn', '2'],
    ['post1', 'as', 'nn', '5'],
    ['post1', 'as', 'nn', '6'],
]
let result = [];

for (let i = 0; i < array1.length; i++) {
    let element = array1[i];
    let found = false;
    result.forEach(item => {
        item[3] = parseInt(item[3])
        if (item[1] === element[1] && item[2] === element[2]) {
            item[3] = parseInt(item[3]);
            item[3] += parseInt(element[3]);
            found = true;
        }
    });
    if (!found) {
        result.push(element);
    }
}
console.log(result);
