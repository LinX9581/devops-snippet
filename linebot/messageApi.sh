


# 取得被加好友的ID (沒有權限)
curl -v -X GET https://api.line.me/v2/bot/followers/ids \
-H 'Authorization: Bearer {6561516}'

# 取得群組資訊
curl -v -X GET https://api.line.me/v2/bot/group/{13216531}/summary \
-H 'Authorization: Bearer {6561516}'

# 取得群組人數
curl -v -X GET https://api.line.me/v2/bot/group/{Cafcb634a95cf02d8276cd1395bf0c6bf}/members/count \
-H 'Authorization: Bearer {UAzntG96EkxRiNBpjzxIaCXRFqDAJZzSPt2TLYo5zynYFGukyee96XGfpNss7d6aSJYPh60CPY22u8d8a0MzvMlve4aMZwMAaa0+ScLvnnJUEYfhYsuPVwMUQXS0zOOTWJcTjyUt4NOFAjsrl4FwZQdB04t89/1O/w1cDnyilFU=}'

# 讓linebot離開群組
curl -v -X GET https://api.line.me/v2/bot/group/{Cafcb634a95cf02d8276cd1395bf0c6bf}/members/leave \
-H 'Authorization: Bearer {UAzntG96EkxRiNBpjzxIaCXRFqDAJZzSPt2TLYo5zynYFGukyee96XGfpNss7d6aSJYPh60CPY22u8d8a0MzvMlve4aMZwMAaa0+ScLvnnJUEYfhYsuPVwMUQXS0zOOTWJcTjyUt4NOFAjsrl4FwZQdB04t89/1O/w1cDnyilFU=}'

# 取得群組人數ID (沒有權限)
curl -v -X GET https://api.line.me/v2/bot/group/{Cafcb634a95cf02d8276cd1395bf0c6bf}/members/ids \
-H 'Authorization: Bearer {UAzntG96EkxRiNBpjzxIaCXRFqDAJZzSPt2TLYo5zynYFGukyee96XGfpNss7d6aSJYPh60CPY22u8d8a0MzvMlve4aMZwMAaa0+ScLvnnJUEYfhYsuPVwMUQXS0zOOTWJcTjyUt4NOFAjsrl4FwZQdB04t89/1O/w1cDnyilFU=}'

