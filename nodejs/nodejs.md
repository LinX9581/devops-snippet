---
alert(window.navigator.userAgent)
navigator
    .userAgentData.getHighEntropyValues(
        ["architecture", "model", "platform", "platformVersion",
            "uaFullVersion"
        ])
    .then(ua => {
        console.log(ua)
    });
---
https://user-agent-client-hints.glitch.me/javascript.html