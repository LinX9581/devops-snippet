const { Client, GatewayIntentBits } = require("discord.js");
const client = new Client({ intents: [GatewayIntentBits.Guilds, GatewayIntentBits.GuildMessages, GatewayIntentBits.MessageContent] });

client.on("ready", () => {
  console.log(`Logged in as ${client.user.tag}!`);
});

// 監聽互動事件來處理命令
client.on("interactionCreate", async (interaction) => {
  if (!interaction.isChatInputCommand()) return;

  if (interaction.commandName === "ping") {
    await interaction.reply("Pong!");
  }
});

// 監聽消息事件來處理命令
client.on("messageCreate", async (message) => {
  console.log(message.content)
  if (!message.guild) return; // 如果消息不是來自伺服器，忽略它
  if (message.author.bot) return; // 如果消息來自機器人，忽略它

});

client.login(config.discord.token);
