const ping = require("ping");

let pingTimes = 0
async function pingEip() {
    const result = await ping.promise.probe('172.23.1.11', {
        timeout: 10,
        extra: ["-i", "2"],
    });

    if (result.alive == true) {
        console.log(result.alive);
        clearInterval(timeStatus);

    } else {
        pingTimes += 1;
        if (pingTimes == 10) clearInterval(timeStatus)
        console.log(result.alive);
    }
};

let timeStatus = setInterval(pingEip, 3000);