#!/bin/bash

# 設定變數
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ROLE_ARN="arn:aws:iam::${ACCOUNT_ID}:role/service-role/AWSDataLifecycleManagerDefaultRole"

echo "建立每小時快照 DLM 政策 (保留 2 天)"
echo "帳號 ID: $ACCOUNT_ID"

# 建立 DLM 生命週期政策
aws dlm create-lifecycle-policy \
    --region ap-northeast-1 \
    --execution-role-arn "$ROLE_ARN" \
    --description "Hourly EC2 snapshots with 2 days retention" \
    --state ENABLED \
    --policy-details '{
        "PolicyType": "EBS_SNAPSHOT_MANAGEMENT",
        "ResourceTypes": ["VOLUME"],
        "ResourceLocations": ["CLOUD"],
        "TargetTags": [
            {
                "Key": "HourlyBackup",
                "Value": "true"
            }
        ],
        "Schedules": [
            {
                "Name": "HourlySnapshot",
                "CopyTags": true,
                "TagsToAdd": [
                    {
                        "Key": "SnapshotType", 
                        "Value": "Automated-Hourly"
                    },
                    {
                        "Key": "CreatedBy",
                        "Value": "DLM-Policy"
                    }
                ],
                "CreateRule": {
                    "Location": "CLOUD",
                    "Interval": 1,
                    "IntervalUnit": "HOURS",
                    "Times": ["00:00"]
                },
                "RetainRule": {
                    "Count": 48,
                    "Interval": 0
                }
            }
        ]
    }'

echo ""
echo "政策建立完成！"
echo ""
echo "要讓 EC2 實例使用此政策，請為其 EBS 卷加上標籤："
echo "aws ec2 create-tags --resources vol-xxxxxxxxx --tags Key=HourlyBackup,Value=true" 