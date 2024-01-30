
詳細介紹文
https://ivonblog.com/posts/stable-diffusion-webui-features/

https://medium.com/%E9%9B%9E%E9%9B%9E%E8%88%87%E5%85%94%E5%85%94%E7%9A%84%E5%B7%A5%E7%A8%8B%E4%B8%96%E7%95%8C/%E6%B7%BA%E8%AB%87aigc%E7%88%86%E7%82%B8%E7%9A%84%E6%99%82%E4%BB%A3-ai%E7%B9%AA%E5%9C%96-stable-diffusion-mid-journey-dall-e-2-4e0cf67afd8d
## stable-diffusion
### 安裝教學
用自己顯卡跑 stable-diffusion
https://www.coolaler.com/index/%E4%BD%BF%E7%94%A8%E8%87%AA%E5%B7%B1%E7%9A%84%E9%A1%AF%E5%8D%A1%E9%80%B2%E8%A1%8C-ai-%E7%B9%AA%E5%9C%96-stable-diffusion-webui-%E5%AE%89%E8%A3%9D%E6%95%99%E5%AD%B8/

### plugin
1. sd-webui-additional-networks
讓web ui 可以從 Extensions -> Avalible 
去安裝第三方套件 Ex. Lora

* 安裝
cd stable-diffusion-webui\extensions
git clone https://github.com/kohya-ss/sd-webui-additional-networks.git

2. controlnet
主要是藉由圖片的線條、骨幹為參考依據去生成圖片

* 教學參考
https://home.gamer.com.tw/artwork.php?sn=5662905
https://www.youtube.com/watch?v=C7IT8hP50P4&ab_channel=JoeMultimedia

* 安裝
cd stable-diffusion-webui\extensions
git clone https://github.com/Mikubill/sd-webui-controlnet.git

* models
底下兩個model用途一樣 但底下容量比較大 不確定功能差異
https://huggingface.co/webui/ControlNet-modules-safetensors/tree/main
https://huggingface.co/lllyasviel/ControlNet/tree/main/models

* 手部插件
可以自由選擇手勢
https://github.com/jexom/sd-webui-depth-lib


模組	    效果
Canny	    會用演算法詳細的抓圖片的邊緣線做為參考生成圖片
mlsd	    會嘗試抓圖片中明顯的直線做為參考生成圖片
hed 	    會嘗試抓取圖片中的特徵做為參考生成圖片
Scribbles	會嘗試以提供的線條為結構做為參考生成圖片
openpose	會嘗試從圖片中的人物生成骨架後做為參考生成圖片
seg	        會將圖片用一個大略的色塊取代後做為參考生成圖片
depth	    會嘗試從圖片中抓取圖片的深淺遠近做為參考生成圖片
normal	    與depth類似，也會嘗試從圖片中抓取圖片的深淺遠近做為參考生成圖片

3. Lora
從 web ui
Extensions -> Avalible

下載模型 在 Lora的 ui介面上選擇
https://huggingface.co/AnonPerson/ChilloutMix/tree/main
https://civitai.com/models/16599/beautypromix

人物的部份，用0.7-0.85
姿勢的部份，用0.6以下
場景的部份，用0.5

一般圖片叫 LORA
拿到它的正反面詞 和 seed之外 還要去找它使用的model

model 的 Type = CHECKPOINT MERGE
https://civitai.com/models/6424/chilloutmix

model分為主模型或大模型，小模型分為Vae, Lora, Embedding(Text Invertion)，以及輔助模型像是BLIP, CLIP, ControlNet

https://github.com/civitai/civitai/wiki/How-to-use-models#fine-tuned-model-checkpoints-dreambooth-models

4. Vae
臉部修正插件
https://huggingface.co/stabilityai/sd-vae-ft-mse-original/tree/main
下載 vae-ft-mse-840000-ema-pruned.safetensors 至 stable-diffusion-webui\models\VAE 

web-ui -> setting -> stable-diffusion -> SD VAE
選上面的檔案

6500 -> 改用這個
https://civitai.com/models/4514/pure-eros-face
放到 embeddings 資料夾
藉由關鍵字 prompt 去觸發 Ex. girl

5. sd-webui-cutoff
https://github.com/hnmr293/sd-webui-cutoff
讓提示詞的效果不會溢出 像是綠色的裙子 就只會影響裙子

6. Dynamic Thresholding (CFG Scale Fix)
https://github.com/mcmonkeyprojects/sd-dynamic-thresholding
讓臉更細緻

7. 讓區塊更細緻
https://github.com/hnmr293/sd-webui-llul

### 畫畫方式
* 保留衣服 換臉
canny 取線條.把不需要的boddy線條刪掉
保留相對位置 之後就能生出身體了

* 保留圖片的 prompt
直接版產出來的圖片 丟到prompt格子裡面
## midjourney
用 discord 下prompt產圖
https://mrmad.com.tw/midjourney


3. 真人 plugin
https://www.youtube.com/watch?v=C7IT8hP50P4&ab_channel=JoeMultimedia


## AI 相關應用
1. Tinder chatgpt bot
https://github.com/TheExplainthis/ChatGPT-Tinder-Bot


## prompy


* 男生
(8k, best quality, masterpiece:1.2), (realistic, photo-realistic:1.37), ultra-detailed, 1 boy, handsome, solo, beautiful detailed sky, sitting, dating, (nose blush), (smile:1.15), (closed mouth), muscular build, beautiful detailed eyes, (collared shirt:1.1), (short hair:1.3), (floating hair NovaFrogStyle:1.2), jk, night, blue light, wet, park

* 女生
prompt
(8k, best quality, masterpiece:1.2), (realistic, photo-realistic:1.37), ultra-detailed, 1 girl,cute, solo,beautiful detailed sky,sitting,dating,(nose blush),(smile:1.15),(closed mouth) big breasts,beautiful detailed eyes,(collared shirt:1.1), (short hair:1.3),(floating hair NovaFrogStyle:1.2), jk,night, pink light, wet, park

negative
paintings, sketches, (worst quality:2), (low quality:2), (normal quality:2), lowres, normal quality, ((monochrome)), ((grayscale)), skin spots, acnes, skin blemishes, age spot, (outdoor:1.6), manboobs, backlight,(ugly:1.331), (duplicate:1.331), (morbid:1.21), (mutilated:1.21), (tranny:1.331), mutated hands, (poorly drawn hands:1.331), blurry, (bad anatomy:1.21), (bad proportions:1.331), extra limbs, (disfigured:1.331), (more than 2 nipples:1.331), (missing arms:1.331), (extra legs:1.331), (fused fingers:1.61051), (too many fingers:1.61051), (unclear eyes:1.331), bad hands, missing fingers, extra digit, (futa:1.1), bad body, NG_DeepNegative_V1_75T,pubic hair, glans, missing foots

Sampling method DPM++ SDE Karras
Sampling steps 28
CFG scale 8



* 大自然
正向的 prompt：
(8k, best quality, masterpiece:1.2), (realistic, photo-realistic:1.37), ultra-detailed, breathtaking view of the high mountains and rare high-altitude trees, with clear blue skies and bright sunshine, (wildlife:1.15), (fresh mountain air:1.1), (clear mountain streams or lakes:1.2), (hiking trails:1.15), (colorful wildflowers:1.1), stunning vistas, relaxing/serene atmosphere.

負向的 prompt：

(8k, low quality, poor craftsmanship:0.5), (unrealistic, cartoonish:0.7), low-detailed, unimpressive view of the high mountains and few high-altitude trees, with cloudy skies and weak sunshine, (deforestation or erosion:1.1), (polluted mountain streams or lakes:1.15), (disruptive or loud noise:1.1), (dangerous terrain:1.2), (inclement weather conditions:1.15), barren and unattractive environment.

controlnet 模型用segmentation 


反向詞
best quality, illustration, castle, ((Midnight mid-age western fantasy back alley)), ((low brightness)), ((black sky)), ((black out)), lovely little girl, back view
Negative prompt: EasyNegative, (((light))), (((street light))), ((moonlight)), ((bulb)), window, electric, ((((sunshine)))), ((((sunlight))))