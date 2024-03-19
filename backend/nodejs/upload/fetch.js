// 使用 import 語法引入模塊
import axios from "axios";
import FormData from "form-data";
import fs from "fs";

// whisper_test();
async function whisper_test() {
  try {
    const data = new FormData();
    data.append("file", fs.createReadStream("/var/www/1.mp3"));

    const config = {
      method: "post",
      maxBodyLength: Infinity,
      url: "http://127.0.0.1:3006/ai/whisper",
      headers: {
        ...data.getHeaders(),
      },
      data: data,
    };

    const response = await axios.request(config);
  } catch (error) {
    console.log(error);
  }
};

