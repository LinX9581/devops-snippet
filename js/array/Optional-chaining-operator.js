//可選串聯
//如我取的值是左邊 就變右邊
//undefined null ?? []
//會自動判斷user後面有沒有值
// a.user?.name

const adventurer = {
    name: 'Alice',
    cat: {
        name: 'Dinah'
    }
};

const dogName = adventurer.dog?.name;
console.log(dogName);