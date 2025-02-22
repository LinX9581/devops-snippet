
## 儲存每個表單的金鑰
CREATE TABLE survey_keys (
    id INT PRIMARY KEY AUTO_INCREMENT,  -- 唯一識別碼
    svid VARCHAR(255) NOT NULL,  -- 問卷 ID (SurveyCake 提供的 ID)
    svid VARCHAR(255) UNIQUE NOT NULL,  -- 問卷 ID (SurveyCake 提供的 ID)
    hash_key VARCHAR(255) NOT NULL,     -- AES 加密金鑰
    iv_key VARCHAR(255) NOT NULL,       -- AES IV 向量
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 建立時間
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- 更新時間
);


## 儲存每個問卷的填答
CREATE TABLE survey_responses (
    id BIGINT PRIMARY KEY,  -- 問卷填答 ID (SurveyCake 提供的)
    svid VARCHAR(255) NOT NULL,  -- 問卷 ID
    title VARCHAR(255),  -- 問卷標題
    status VARCHAR(50),  -- 問卷狀態 (e.g., FINISH)
    submit_time DATETIME,  -- 提交時間
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 記錄建立時間
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  -- 記錄更新時間
);

## 儲存每個問卷的填答內容
CREATE TABLE survey_answers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    response_id BIGINT,  -- 對應 `survey_responses.id`
    question_sn INT,  -- SurveyCake 題目的 `sn`
    subject TEXT,  -- 題目名稱
    type VARCHAR(50),  -- 題型 (e.g., TXTSHORT, CHOICEONE)
    answer TEXT,  -- 使用者填寫的答案
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (response_id) REFERENCES survey_responses(id) ON DELETE CASCADE
);
