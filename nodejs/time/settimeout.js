let date = 0;
let connect_time = setInterval(() => {
  console.log(date++);
}, 1000);

async function test(){
    console.log('sdf');
}
setTimeout(test, 5000);