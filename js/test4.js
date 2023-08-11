const screenPageViews = [
    '7848', '6078', '5686', '4678', '4217',
    '3761', '2544', '2455', '1992', '1868',
    '553',  '311',  '152',  '108',  '81',
    '48',   '47',   '37',   '32',   '30',
    '25',   '24',   '14',   '13',   '5',
    '4',    '3',    '2',    '2',    '2',
    '1',    '1',    '1',    '1'
  ];
  
  const hour = [
    '8', '7', '0', '6', '9', '1', '5',
    '2', '3', '4', '8', '9', '7', '0',
    '6', '2', '1', '5', '3', '8', '3',
    '4', '5', '7', '8', '9', '6', '0',
    '0', '6', '0', '7', '8', '9'
  ];
  
  const hourScreenPageViews = Array.from({ length: 24 }, () => []);
  
  for (let i = 0; i < hour.length; i++) {
    const index = parseInt(hour[i]);
    hourScreenPageViews[index].push(screenPageViews[i]);
  }
  
  console.log(hourScreenPageViews);