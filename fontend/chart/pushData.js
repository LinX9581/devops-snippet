let allDataArray = []
for (let i = 0; i < 7; i++) {
    let data = {
        label: i,
        data: [1, 2, 3, 4],
        backgroundColor: [
            'rgba(153, 102, 255, 0.2)',
        ],
        borderColor: [
            'rgba(255, 206, 86, 0.2)',
        ],
        borderWidth: 1
    }
    allDataArray.push(data)
}

console.log(allDataArray[0]);