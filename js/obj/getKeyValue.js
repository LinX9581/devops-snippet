let obj = {
    'google': [1, 3],
    'yahoo': [2, 5],
    'line': [3, 4]
}

let source = 'fb'
obj[source] = [4, 5]

let array = []
    // array[source] = [1, 2]
array[source].push([1, 2])
console.log(array);

for (const key in obj) {
    console.log(key);
    console.log(obj[key]);
}

console.log(Object.keys(obj));
console.log(Object.values(obj));