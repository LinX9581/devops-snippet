const TelegramBot = require("node-telegram-bot-api");
const express = require("express");
const bodyParser = require("body-parser");
const moment = require("moment-timezone");
// const token = config.telegram.token;
const token = '6773597683:AAHF15elDbvVS_Z-egfIyAxPdVGaHrQ-GDc';
const bot = new TelegramBot(token, { polling: true });

bot.on("message", async (msg) => {
  const chatId = msg.chat.id;
  console.log(chatId);
  bot.sendMessage(chatId, "HI");
});

const tfId = '1132073511'

const app = express();
app.use(bodyParser.json())
app.post("/webhook", async (req, res) => {
  try {
    if (req.body) {
      let alertMessages = req.body.alerts;
      let alertSummary = convertAlertsToSummaryString(alertMessages);
      await bot.sendMessage(tfId, alertSummary);
      res.send(
        JSON.stringify({
          code: "200",
        })
      );
    }
  } catch (error) {
    console.log(error);
  }
});

// 合併監控訊息
function convertAlertsToSummaryString(alertMessages) {
  let descriptionSummary = "";
  let status = "";
  let startsAt = "";

  alertMessages.forEach((alert, index) => {
    descriptionSummary += `${index + 1}. ${alert.annotations.description}\n`;

    if (index === 0) {
      status = alert.status;
      startsAt = convertToTimeZone(alert.startsAt, "Asia/Taipei");
    }
  });

  let alertSummary = `Status: ${status}\n`;
  alertSummary += `Descriptions:\n${descriptionSummary}\n`;
  alertSummary += `Starts At (UTC+8): ${startsAt}\n\n`;
  alertSummary += `--------------------------------------------------------\n`;
  return alertSummary;
}

function convertToTimeZone(dateString, timeZone) {
  return moment(dateString).tz(timeZone).format("YYYY-MM-DD HH:mm:ss");
}

const http = require("http").Server(app);
const port = process.env.PORT || 3005;
http.listen(port, function() {
    console.log("My Line bot App running on 3005");
});