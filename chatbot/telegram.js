const TelegramBot = require("node-telegram-bot-api");

const token = config.telegram.token;
const bot = new TelegramBot(token, { polling: true });

bot.on("message", async (msg) => {
  const chatId = msg.chat.id;
  console.log(chatId);
  bot.sendMessage(chatId, "HI");
});
