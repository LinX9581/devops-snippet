import express from "express";
import fetch from "node-fetch";
import CryptoJS from "crypto-js";
import dotenv from "dotenv";
import query from "../mysql-connect"; // 假設用 SQL 查詢 key

dotenv.config();
const router = express.Router();

/**
 * 解密 SurveyCake 資料
 * @param {string} encryptedData 加密的資料
 * @param {string} hashKey AES 加密密鑰
 * @param {string} ivKey AES IV 向量
 * @returns {Object|null} 解密後的 JSON 或 null（失敗時）
 */
function decryptSurveyCakeData(encryptedData, hashKey, ivKey) {
  try {
    const decrypted = CryptoJS.AES.decrypt(encryptedData, CryptoJS.enc.Utf8.parse(hashKey), { iv: CryptoJS.enc.Utf8.parse(ivKey) });

    const decryptedText = decrypted.toString(CryptoJS.enc.Utf8);
    return decryptedText ? JSON.parse(decryptedText) : null;
  } catch (error) {
    console.error("[Decrypt Error] 解密失敗:", error.message);
    return null;
  }
}

/**
 * 透過 `svid` 從資料庫獲取 `HASH_KEY` 和 `IV_KEY`
 * @param {string} svid 問卷 ID
 * @returns {Promise<{hashKey: string, ivKey: string} | null>}
 */
async function getEncryptionKeys(svid) {
  try {
    const sql = "SELECT hash_key, iv_key FROM cake.survey_keys WHERE svid = ?";
    const [result] = await query(sql, [svid]);

    if (!result) {
      console.error(`[DB Error] 找不到 svid: ${svid} 的金鑰`);
      return null;
    }

    return { hashKey: result.hash_key, ivKey: result.iv_key };
  } catch (error) {
    console.error("[DB Error] 查詢金鑰失敗:", error.message);
    return null;
  }
}

/**
 * SurveyCake Webhook API 處理
 */
router.post("/", async (req, res) => {
  const { svid, hash } = req.body;
  if (!svid || !hash) return res.status(400).json({ error: "缺少必要參數" });

  const keys = await getEncryptionKeys(svid);
  if (!keys) return res.status(500).json({ error: "無法獲取金鑰" });

  const webhookUrl = `https://www.surveycake.com/webhook/v0/${svid}/${hash}`;
  try {
    const response = await fetch(webhookUrl, { headers: { "Content-Type": "application/json" } });
    if (!response.ok) return res.status(502).json({ error: "無法獲取問卷資料" });

    const encryptedData = await response.text();
    const result = decryptSurveyCakeData(encryptedData, keys.hashKey, keys.ivKey);
    if (!result) return res.status(500).json({ error: "解密失敗" });
    console.log("解密成功:", result);
    // Step 1: 存入 `survey_responses`
    const { id, title, status, submitTime, result: answers } = result;
    const sqlInsertResponse = `
            INSERT INTO cake.survey_responses (id, svid, title, status, submit_time)
            VALUES (?, ?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE status=?, submit_time=?
        `;
    await query(sqlInsertResponse, [id, svid, title, status, submitTime, status, submitTime]);

    // Step 2: 存入 `survey_answers`
    const sqlInsertAnswer = `
            INSERT INTO cake.survey_answers (response_id, question_sn, subject, type, answer)
            VALUES (?, ?, ?, ?, ?)
        `;

    for (const question of answers) {
      const { sn, subject, type, answer } = question;
      const answerText = Array.isArray(answer) ? answer.join(", ") : answer; // 處理陣列答案

      await query(sqlInsertAnswer, [id, sn, subject, type, answerText]);
    }
    console.log("問卷資料已成功存入");
    res.json({ success: true, message: "問卷資料已成功存入" });
  } catch (err) {
    console.error("[Server Error]", err.message);
    res.status(500).json({ error: "處理請求時發生錯誤" });
  }
});
export default router;
