let socialMediaMemberObj = [
    { name: '123', id: 'dfg', pv: 0 },
    { name: '234', id: 'dfvg', pv: 0 },
    { name: '545', id: 'cvb', pv: 0 },
];

let a = getSocialMediaMember('dfg')
console.log(a);

function getSocialMediaMember(memberId) {
    let member = ''
    socialMediaMemberObj.map((ele, index) => {
        if (ele.id === memberId) member = ele.name;
    });
    return member;
}