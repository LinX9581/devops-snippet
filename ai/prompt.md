https://ivonblog.com/posts/stable-diffusion-webui-features/

## 貓

prompt 

Cute and adorable cat, wearing coat and suit, steampunk, lantern, anthromorphic, Jean paptiste monge, oil painting

可愛的貓咪穿著外套和西裝，蒸汽龐克風格，手提著提燈，人型化，出自Jean Paptiste Monge之手，為油畫作品。

要求姿勢的話 要用canny 或 hed
型態的話要用 seg

舔手指 種子
sticking out its tongue
1092246419
2716827623


* 大自然
正向的 prompt：
(8k, best quality, masterpiece:1.2), (realistic, photo-realistic:1.37), ultra-detailed, breathtaking view of the high mountains and rare high-altitude trees, with clear blue skies and bright sunshine, (wildlife:1.15), (fresh mountain air:1.1), (clear mountain streams or lakes:1.2), (hiking trails:1.15), (colorful wildflowers:1.1), stunning vistas, relaxing/serene atmosphere.

負向的 prompt：

(8k, low quality, poor craftsmanship:0.5), (unrealistic, cartoonish:0.7), low-detailed, unimpressive view of the high mountains and few high-altitude trees, with cloudy skies and weak sunshine, (deforestation or erosion:1.1), (polluted mountain streams or lakes:1.15), (disruptive or loud noise:1.1), (dangerous terrain:1.2), (inclement weather conditions:1.15), barren and unattractive environment.

controlnet 模型用segmentation 

* 精緻女生
parameters

<(masterpiece, photorealistic:1.4), (extremely intricate:1.2)>, (hand of guido daniele:1.2), jewelry, black hair, necklace, black choker, upper body, short hair, single hair bun, mole under eye, bangs, black shirt, off shoulder, sleeveless, hoop earrings, purple eyes, piercing, red lips, closed mouth, eyelashes, studio, grey background, simple background, 1girl, solo, BREAK, <cinematic light, ultra high res, 8k uhd, film grain, perfect anatomy, exquisitely detailed skin, best shadow, delicate, RAW>,

Negative prompt: 
(worst quality, normal quality, low quality:1.5), paintings, sketches, freckles, lowres, monochrome, grayscale, bad proportions, nsfw, nipples, watermark, signature, text, nsfw, curvy, plump, fat, muscular female, tattoo
Steps: 20, Sampler: DPM++ SDE Karras, CFG scale: 20, Seed: 2050321520, Size: 448x640, Model hash: 733557c424, Model: dalceforealistictallyv2, Denoising strength: 0.6, Clip skip: 2, Hires upscale: 1.5, Hires upscaler: Latent (nearest-exact), Dynamic thresholding enabled: True, Mimic scale: 11, Threshold percentile: 100, Mimic mode: Linear Up, Mimic scale minimum: 0, CFG mode: Linear Up, CFG scale minimum: 0

Vae用
kl-f8-anime2.ckpt

* 女生
prompt
(8k, best quality, masterpiece:1.2), (realistic, photo-realistic:1.37), ultra-detailed, 1 girl,cute, solo,beautiful detailed sky,sitting,dating,(nose blush),(smile:1.15),(closed mouth) big breasts,beautiful detailed eyes,(collared shirt:1.1), (short hair:1.3),(floating hair NovaFrogStyle:1.2), jk,night, pink light, wet, park

negative
paintings, sketches, (worst quality:2), (low quality:2), (normal quality:2), lowres, normal quality, ((monochrome)), ((grayscale)), skin spots, acnes, skin blemishes, age spot, (outdoor:1.6), manboobs, backlight,(ugly:1.331), (duplicate:1.331), (morbid:1.21), (mutilated:1.21), (tranny:1.331), mutated hands, (poorly drawn hands:1.331), blurry, (bad anatomy:1.21), (bad proportions:1.331), extra limbs, (disfigured:1.331), (more than 2 nipples:1.331), (missing arms:1.331), (extra legs:1.331), (fused fingers:1.61051), (too many fingers:1.61051), (unclear eyes:1.331), bad hands, missing fingers, extra digit, (futa:1.1), bad body, NG_DeepNegative_V1_75T,pubic hair, glans, missing foots

* 夕陽+流星prompt

shinkai makoto, kimi no na wa., air conditioner, antennae, architecture, building, cable, city, cloud, cloudy sky, comet, crane (machine), house, industrial pipe, japan, light, night, night sky, no humans, outdoors, pipeline, satellite dish, shinjuku (tokyo), sky, star (sky), tokyo (city), window <lora:shinkai_makoto_offset:1>

(painting by bad-artist-anime:0.9), (painting by bad-artist:0.9), watermark, text, error, blurry, jpeg artifacts, cropped, worst quality, low quality, normal quality, jpeg artifacts, signature, watermark, username, artist name, (worst quality, low quality:1.4), bad anatomy

* H
 {shameless impractical clothes},{{prostitute}}, {{ wears indecent white clothes and gorgeous accessories}} ,{{sexy white clothes maximize body exposure}},{{detailed nipples}},
 NSFW

 lora
 https://civitai.com/gallery/137751?modelId=11980&modelVersionId=14156&infinite=false&returnUrl=%2Fmodels%2F11980%2Fmeisho-doto-umamusume

 models
 https://huggingface.co/WarriorMama777/OrangeMixs/tree/main/Models/AbyssOrangeMix3