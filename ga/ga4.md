# Ga4 參數
https://googleapis.dev/nodejs/analytics-data/latest/google.analytics.data.v1alpha.AlphaAnalyticsData.html#batchRunPivotReports1

# Ga4 Github
https://github.com/googleapis/nodejs-analytics-data

# GA4 for nodejs
https://github.com/LinX9581/nodejs-ga4

# GA4 Note
git clone 
yarn install
yarn start

1. 所有匯出排程都在 ./routes/allSchedule.js
2. GA3 GA4 init ./component/ga4init.js

## Dimensions
pageTitle
fullPageUrl

## Metrics
screenPageViews
activeUsers
newUsers
userEngagementDuration

## 即時數據文件
* 即時數據維度
https://developers.google.com/analytics/devguides/reporting/data/v1/realtime-api-schema
* nodejs code
https://googleapis.dev/nodejs/analytics-data/latest/
* page
https://stackoverflow.com/users/14466144/brett

## Ref For Nodejs
https://7nohe-tech-blog.vercel.app/post/node-js-google-analytics-4-ga4-contentful-google-analytics-data-api

https://dns.sample.com/ga3/106152872/2022-05-20/2022-05-27/date/pageViews

https://dns.sample.com/ga4/308596645/2022-10-25/2022-10-30/date/screenPageViews
## Request Body
[官方文件]
(https://developers.google.com/analytics/devguides/reporting/data/v1/rest/v1beta/properties/batchRunReports)

ga:pageTitle=@新奇 | NOWnews

{
  "dateRanges": [
    {
      "startDate": "2021-01-04",
      "endDate": "2021-01-06"
    }
  ],
  "metrics": [
    {
      "name": "sessions"
      "name": "screenPageViews",
      "name": "activeUsers",
      "name": "newUsers",
      "name": "userEngagementDuration"
    }
  ],
  "dimensions": [
    {
      "name": "date",
      "name": "pageTitle",
      "name": "fullPageUrl"
    }
  ],
  "orderBys": [
    {
      "metric": {
        "metricName": "sessions"
      },
      "desc": true
    }
  ]
}

* result
{
  "metricHeaders": [
    {
      "name": "sessions",
      "type": "TYPE_INTEGER"
    }
  ],
  "rows": [
    {
      "dimensionValues": [
        {
          "value": "20210104"
        }
      ],
      "metricValues": [
        {
          "value": "12900"
        }
      ]
    },
    {
      "dimensionValues": [
        {
          "value": "20210105"
        }
      ],
      "metricValues": [
        {
          "value": "10700"
        }
      ]
    },
    {
      "dimensionValues": [
        {
          "value": "20210106"
        }
      ],
      "metricValues": [
        {
          "value": "11300"
        }
      ]
    }
  ],
  "metadata": {},
  "dimensionHeaders": [
    {
      "name": "date"
    }
  ],
  "rowCount": 3
}

```
{
  "property": string,
  "dimensions": [
    {
      object (Dimension)
    }
  ],
  "metrics": [
    {
      object (Metric)
    }
  ],
  "dateRanges": [
    {
      object (DateRange)
    }
  ],
  "dimensionFilter": {
    object (FilterExpression)
  },
  "metricFilter": {
    object (FilterExpression)
  },
  "offset": string,
  "limit": string,
  "metricAggregations": [
    enum (MetricAggregation)
  ],
  "orderBys": [
    {
      object (OrderBy)
    }
  ],
  "currencyCode": string,
  "cohortSpec": {
    object (CohortSpec)
  },
  "keepEmptyRows": boolean,
  "returnPropertyQuota": boolean
}
```