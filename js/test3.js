{
  '': [
    497563, 94100,
    209730,  4588,
    101082, 80558,
       616, 14436,
       141
  ],
  google: [
    94100,  1463, 1209,
    11928, 13419, 1013,
    39557, 21804,  547,
      355
  ],
  direct: [
    209730,  4560, 3915,
     31162, 27329, 2731,
     83821, 48869,  803,
       844
  ],
  recommend: [
    4588, 165,   81, 600,
    1323,  36, 1241, 996,
      17,   7
  ],
  yahoo: [
    101082,  2298, 2888,
     13264, 19800, 1454,
     42604, 16041,  481,
       252
  ],
  fb: [
    80558,  1149, 1085,
     2864, 28607,  211,
    21522, 24348,   41,
       90
  ],
  dable: [
    616,  16,   5, 96, 99,
      4, 253, 132,  3,  2
  ],
  line: [
    14436, 1323, 591,
      100, 3767, 300,
     4030, 4090,  13,
        5
  ],
  ai_news: [
    141,  3,  3, 8, 32,
      2, 61, 29, 0,  0
  ],
  summary: [
    12242, 1463, 4560,
      165, 2298, 1149,
       16, 1323,    3
  ],
  global: [
    10756, 1209, 3915,
       81, 2888, 1085,
        5,  591,    3
  ],
  sport: [
    62220, 11928, 31162,
      600, 13264,  2864,
       96,   100,     8
  ],
  entertainment: [
    99692, 13419, 27329,
     1323, 19800, 28607,
       99,  3767,    32
  ],
  finance: [
    6117, 1013, 2731,
      36, 1454,  211,
       4,  300,    2
  ],
  novelty: [
    199975, 39557,
     83821,  1241,
     42604, 21522,
       253,  4030,
        61
  ],
  life: [
    121648, 21804,
     48869,   996,
     16041, 24348,
       132,  4090,
        29
  ],
  focus: [
    2001, 547, 803, 17,
     481,  41,   3, 13,
       0
  ],
  place: [
    1748, 355, 844, 7,
     252,  90,   2, 5,
       0
  ]
}


singleTraffic();
async function singleTraffic() {
  let gaDate = moment(new Date()).add(-1, "days").format("YYYY-MM-DD");
  let metrics, dimension, filter;

  let channelName = ["娛樂"];
  let trafficTableArray = ["google", "direct", "recommend", "yahoo", "fb", "dable", "line", "ai_news"];

  let trafficName = [
    ".*(facebook|fb).*",
    ".*(facebook / nn|fb / nn).*",
    ".*(facebook / bb|fb / bb).*",
    ".*(facebook / pe|fb / pe).*",
    ".*(facebook / ne|fb / ne).*",
    ".*(facebook / ct|fb / ct).*",
    ".*(facebook / bo|fb / bo).*",
  ];
  // pageTitle firstUserSourceMedium CONTAINS FULL_REGEXP
  let tmpArray = [];
  for (let i = 0; i < channelName.length; i++) {
    (metrics = ""), (dimension = ""), (filter = "");
    metrics = [{ name: "screenPageViews" }];
    dimension = [{ name: "pageTitle" }];
    filter = {
      dimensionFilter: {
        andGroup: {
          expressions: [
            {
              filter: {
                fieldName: "pageTitle",
                stringFilter: {
                  matchType: "CONTAINS",
                  value: '娛樂 | test',
                },
              },
            },
          ],
        },
      },
    };
    let ga4Data = await googleApis.ga4Custom(allIds, gaDate, gaDate, metrics, dimension, filter);
    tmpArray.push(sum(ga4Data.screenPageViews));
    // console.log(ga4Data);
  }
  console.log(tmpArray);
}
