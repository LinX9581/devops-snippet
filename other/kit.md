## Kit
EDM tools

* 取的自己的信箱
curl https://api.convertkit.com/v3/account?api_secret=<your_secret_api_key>

* 取得 form ID
curl https://api.convertkit.com/v3/forms?api_key=<your_public_api_key>

* 新增訂閱者 
curl -X POST "https://api.convertkit.com/v3/forms/7648214/subscribe" -H "Content-Type: application/json; charset=utf-8" -d '{"api_key": <your_public_api_key>, "email": "linx9581@gmail.com"}'



* 取得訂閱者資料
curl https://api.convertkit.com/v3/forms/<form_id>/subscriptions?api_secret=<your_secret_api_key>