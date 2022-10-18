let a = 1215121;
var isPalindrome = function(x) {
    let res = ''
    let str = x.toString()
    for (const i of str) {
        res = i + res
    }
    return (res === str)
};

console.log(isPalindrome(1211121));