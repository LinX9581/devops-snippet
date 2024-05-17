const { google } = require('googleapis');
const { JWT } = require('google-auth-library');
const client = new JWT({
    email: 'gcs-101@gcptest-12123.iam.gserviceaccount.com',
    key: '-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDIzxnStkAi1Ti2\ng4dtP34jyM3m5woOntUnJFCfrW+9hOBjPB50AVL3i0nRYMM4n2Wo4oyGuJApTpVz\nJ1TnfEudx0XnF06ROMnx3II2QjNy4L1IF68hOa6zdZRICRAl8xZaWy6oIqwh4dFC\n1uzoVw7QO5ZIngM2FAuCB6I+Ssyu1G0iDLlp4fhG905BtwmKruIusB7DGEe8ODJ3\nO1y0IZw5xw7GdsNP7yWdfQ2bhhw9U9NaqE3sbcik+CFDYUeICGEdMdheRDPmWA24\nZf63ipnwwinlz1UwBHSlH6R06id5qor28wZUoD5PF8YI1GOPNwWh5U6lH3F9FCto\nYQEMvoirAgMBAAECggEAJVGTv3yeS7rriMPF4dA4bYcOePh7/n6XJ2iQ0TQGvaZZ\nmyebkzyBwj5xEAfXEAlTd8Duk8TuCbcwgA+RsFmBpgdYHtvOfp+arCeqTVIdRJ6u\nnpzEL70MEg7qaT7B8QONpmomsBmNetiALtdJfN5dAuboBYPUHfM4tkgb5064Xk8I\n2QNuSPbCpaj0ME8OynbpIEPNwOiuBsgCIsu/IWUQMfo3Va3YQnXcAqz/XcNMnXUO\nxviIZrzPvXPn5/w+IY8wYxEHCa0/rfYCYoz8s881g75cq0mA8OBzx5QR3GD5eRBP\n6cjpl2skw/3s0pMabenuGPXlPHtDJx53+Tupg5K1YQKBgQDjSQyXQPQT8amyd25p\nFB6RDykRjxPE+MGlABR4UTE6K3yUWt9xApQHtAzbWO8V30meYPBAQZily6oG002U\nXaa0FdyhWHtn1EW8wGSjoj2qHSpBsyKojFnLmwRoAqE+4aIxahKOhcz6KCwenCsT\nxlS0s089MNTWr3SemxO5oL0LIQKBgQDiLb4ziMOcKpng//4MsGoCC9hEsE3OHgBa\nutiI/kPIw5INNUjxdili/WVD/p8sGfdpPQk7LZjq2VACKclafamNHdXenNoT5fr6\nXpnyp6rtOJ+aDpTViL5fbjkCvXOyGfyUZrh7aoyuSMR6hy2lkAUyYh3rfHUSE92u\nFMjNUWmGSwKBgEr4AGgvq5Kchr3wOQH9+esdFg3NpNa2uqDjOt1I4rTuPSRuKP+M\nuykjUY5UcmBDi3PrQ7PeLyyY1hd0QUWr8l26TFEH74Sa9vnAeDGlRTPEdPjAzrDL\nwp6vHi/0lh04rZghBcfvCGKHN65NEsRuCeiksIFdhwbdTtk2C7aR92khAoGAf0ki\n6zmia/aFltw6CsYVQoWL9kwJ3V+A746LYb1GRGvbe9dq74iCDhVwse1PgrAyTmVt\nFoK4tiIKJs2BZY2mp6YMwDUhfWVF8zTeCnNVfB8LotVl6S4FhQswxlv8ClUZkiKk\n27/A4CxPdm0wwSXl5s7U67uk3sGTVe6YewPAETUCgYB7i3gzSPsCSF8molTtoq81\nTMltRyzTY0gy9cmqiQxTT5drJXDMmh5teyXywnfBHigZ2aF8TI9W+ua820sxQxFV\n5TTUP3ENWuQl/g8pEJ9QFEOF7Wv7v1hNT3ka2FVf33oBIXlSqNaCTQUJ6pp2X632\nGLq+p51mmbKCOBbC0JGwjg==\n-----END PRIVATE KEY-----\n',
    scopes: ['https://www.googleapis.com/auth/webmasters', 'https://www.googleapis.com/auth/webmasters.readonly'],
});
google.options({ auth: client });

gsc()
async function gsc() {
    // const searchconsole = google.searchconsole('v1');
    const searchconsole = google.webmasters('v3');
    const resSearchAnalytics = await searchconsole.searchanalytics.query({
        siteUrl: 'https://www.linx.website/',

        requestBody: {
            "dimensions": ["query"],
            "startDate": "2022-05-01",
            "endDate": "2022-05-01",
            "rowLimit": 10
        },
    });

    console.log(resSearchAnalytics.data.rows);
}