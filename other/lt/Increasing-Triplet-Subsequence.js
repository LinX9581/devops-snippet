// Given an integer array nums, return true if there exists a triple of indices (i, j, k) such that i < j < k and nums[i] < nums[j] < nums[k]. If no such indices exists, return false.

 

// Example 1:

// Input: nums = [1,2,3,4,5]
// Output: true
// Explanation: Any triplet where i < j < k is valid.
// Example 2:

// Input: nums = [5,4,3,2,1]
// Output: false
// Explanation: No triplet exists.
// Example 3:

// Input: nums = [2,1,5,0,4,6]
// Output: true
// Explanation: The triplet (3, 4, 5) is valid because nums[3] == 0 < nums[4] == 4 < nums[5] == 6.

let nums = [5,4,3,2,1]
var increasingTriplet = function(nums) {
    if(nums.length <=3){
        let tmp = 0;
        if(nums[0] < nums[1] && nums[1] < nums[2]){
            return "true";
        } else return "false"
    } else {
        let a = []
        console.log(nums);
        for(let i=0;i<nums.length-2;i++){
            console.log(nums[i],nums[i+1],nums[i+2]);
            if(nums[i] < nums[i+1] && nums[i+1] < nums[i+2]){
                if(nums[i+1] < nums[i+2] && nums[i+2] < nums[i+3]){
                    a.push("true")
                } else a.push("false")
            } else a.push("false")
        }
        // console.log(a);
        if(a.includes("true")){
            return "true"
        } else return "false"
    }
};

console.log(increasingTriplet(nums));
// let a = 3;
// let b = 5;
// let c = 7;
// if (a<b && b<c){
//     console.log("ture");
// }