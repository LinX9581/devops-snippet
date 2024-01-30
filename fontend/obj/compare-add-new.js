let a = [
    { author: '張雅貞', count: 39 },
    { author: '邱怡潔', count: 47 },
    { author: '鍾可郁', count: 44 }
  ]
  
  

  let b = [ '鄭溫秀', '陳湘羚', '張雅貞', '邱怡潔', '陳銳安', '鍾可郁' ]

  b.forEach((element,i) => {
    console.log(element);
    for (const item of a) {
        console.log(item);
        if(element != item.author){
            a.splice(i,0,{author:element,count:0})
        } 
    }
  });
  console.log(a);