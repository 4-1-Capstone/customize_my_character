from flask import Flask, request, jsonify
import requests
import json
import random

app = Flask(__name__)

prompt = {
    "selectedMovie" : "",
    "gender": "",
    "hairStyle": "",
    "hasGlasses": False,
    "fashion": "",
    
}

@app.route('/')
def index():
    return 'Hello, Flask!'

@app.route('/update-prompt', methods=['POST'])
def update_prompt():
    global prompt
    data = request.form
    prompt["selectedMovie"] = data.get("selectedMovie","")
    prompt["gender"] = data.get("gender", "")
    prompt["hairStyle"] = data.get("hairStyle", "")
    prompt["hasGlasses"] = data.get("hasGlasses", "")
    prompt["fashion"] = data.get("fashion", "")
    return 'Prompt 업데이트 완료!', 200

@app.route('/generate-image', methods=['GET'])
def generate_image():
    url = "https://modelslab.com/api/v6/images/text2img"

    print(prompt["selectedMovie"])
    # API 요청에 사용할 prompt 변수 가져오기
    if (prompt["selectedMovie"] == 'shinkai makoto, kimi no na wa'):
        current_prompt = f"shinkai makoto, kimi no na wa,full body shot, realistic pose, epic pose, Dynamic pose, Posing when taking pictures, japan travel,japanese shrine, sight, {prompt['gender']},{prompt['hairStyle']}, {prompt['hasGlasses']},masterpiece,highly detailed,ultra-detailed, landscape, scenery,horizon, {prompt['fashion']}, marker, smile, solo"
        #current_prompt = f"shinkai makoto, kimi no na wa., tachibana taki, full body shot, realistic pose, epic pose, Dynamic pose, Posing when taking pictures, japan travel,japanese shrine, sight, 1boy, no female body, little muscle, blue eyes, brown hair, {prompt['hairStyle']}, {prompt['hasGlasses']},{prompt['fashion']},  masterpiece,highly detailed,ultra-detailed, landscape, scenery,horizon,hood, hoodie, school uniform, male focus, marker, smile, solo, writing"

        #current_prompt = f"shinkai makoto, kimi no na wa, full full body shot, action pose, epic pose,Dynamic pose, Posing when taking pictures, japan travel, japanese shrine, sight, {prompt['gender']},{prompt['hairStyle']}, {prompt['hasGlasses']},{prompt['fashion']}, masterpiece,highly detailed,ultra-detailed, landscape, scenery,horizon, bangs, blush, bow, bowtie, brown eyes, cloud, collared shirt, hair ribbon, hairband, looking at viewer, negative space, outdoors, red bow, red bowtie, red hairband, red ribbon, ribbon,  school uniform, shirt, sky, smile, solo, sweater vest, vest, white shirt, yellow sweater vest, yellow vest ,"
    else:
        current_prompt = f"Ghibli, Sen and Chihiro,full body shot, realistic pose, epic pose, Dynamic pose, Posing when taking pictures, japan travel, working, working in japanese spa, water, spa, motel, busy, outdoor, {prompt['gender']}, {prompt['hairStyle']}, {prompt['hasGlasses']}, {prompt['fashion']}, colorful, high contrast"
        #current_prompt = "Ghibli, Sen and Chihiro, full body shot, realistic pose, epic pose, Dynamic pose, Posing when taking pictures, japan travel, working, working in japanese spa, motel, busy, outdoor,bob cut Hair, black hair, chin-length black hair, serious expression , simple,"
        #current_prompt = f"Ghibli, Sen and Chihiro, ogino chihiro, ponytail, yunaifomu, long arm shirt, half pants, red clothes, barefoot, full body shot, realistic pose, epic pose, Dynamic pose, Posing when taking pictures, japan travel, working, working in japanese spa, motel, busy, outdoor, attached a red string to waist, colorful, high contrast"

    
    # prompt를 약간 변형하여 다양성을 높임
    current_prompt += f", random_text_{random.randint(1, 100)}"
    
    
    # API 요청에 필요한 데이터 설정
    payload = {
        "key": "IY3lKt55ulkL4nc9mYf8hJlZuTAeVae2N4ADUFXkj0eSuljuNnc0ubgFiqm5",
        "model_id": "anything-v5",
        "prompt": current_prompt,
        "negative_prompt": "only upper body, face zoom,  expose body, three hands, three legs, fiction, fantasy,watermark,text, error, blurry, jpeg artifacts, cropped, worst quality, low quality, normal quality, jpeg artifacts, signature, watermark, username, artist name, (worst quality, low quality:1.4), bad anatomy",
        "width": "512",
        "height": "512",
        "samples": "4",
        "num_inference_steps": "30",
        "seed": 3227021174,
        "lora_model":"studio-ghibli-style-lora",
        "guidance_scale": 7.5,
        "scheduler": "UniPCMultistepScheduler",
        "webhook": 0,
        "track_id": 0
    }
    
    payload2 = {
        "key": "IY3lKt55ulkL4nc9mYf8hJlZuTAeVae2N4ADUFXkj0eSuljuNnc0ubgFiqm5",
        "model_id": "cutyanime",
        "prompt": current_prompt,
        "negative_prompt": "only upper body, face zoom, body exposure, bright hair, three hands, three legs, fiction, fantasy, watermark,text, error, blurry, jpeg artifacts, cropped, worst quality, low quality, normal quality, jpeg artifacts, signature, watermark, username, artist name, (worst quality, low quality:1.4), bad anatomy",
        "width": "512",
        "height": "512",
        "samples": "4",
        "num_inference_steps": "30",
        "seed": 3938931364,
        "lora_model":"ghibli-style",
        "guidance_scale": 7.5,
        "scheduler": "UniPCMultistepScheduler",
        "webhook": 0,
        "track_id": 0
    }

    # API 요청 보내기
    if (prompt["selectedMovie"] == 'shinkai makoto, kimi no na wa'):
        response = requests.post(url, json=payload)
    else:
        response = requests.post(url, json=payload2)


    # API 응답 전달
    return jsonify(response.json()), response.status_code

if __name__ == '__main__':
    app.run(debug=True)
