// splice array
var array = [1, 2, 3, 4, 5, 6, 7, 4, 5];
array.splice(array.length - 2, 2);
console.log(array);     //123

var array = [1, 2, 3, 4, 5];
var deletes = array.splice(3, 2);
console.log(deletes);   //45
console.log(array);     //123

//刪除的部分接回去
array = array.concat(deletes);
console.log(array);     //12345

//插入
var array = [1, 2, 3, 4, 5];
array.splice(2, 0, 123, 456);
console.log(array); //1,2,123,456,3,4,5

//替換
var array = [1, 2, 3, 4, 5];
array.splice(2, 2, 123, 456);
console.log(array);     //1,2,123,456,5