    # #!/bin/bash

    # # 設置變數
    BUCKET_NAME="s3-nn-test6"
    FOLDER_NAME="s3-nn-folder"
    REGION="ap-northeast-1"

    aws s3 mb s3://$BUCKET_NAME --region $REGION 
    # 讓 S3 bucket 可以公開讀取
    aws s3api put-public-access-block --bucket $BUCKET_NAME --public-access-block-configuration "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"

    echo "<html><body><h1>$BUCKET_NAME Hello World</h1></body></html>" > index.html
    aws s3 cp index.html s3://$BUCKET_NAME/$FOLDER_NAME/index.html

    aws s3api put-bucket-policy --bucket $BUCKET_NAME --policy '{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "PublicReadGetObject",
                "Effect": "Allow",
                "Principal": "*",
                "Action": [
                    "s3:GetObject",
                    "s3:ListBucket"
                ],
                "Resource": [
                    "arn:aws:s3:::'$BUCKET_NAME'",
                    "arn:aws:s3:::'$BUCKET_NAME'/*"
                ]
            }
        ]
    }'

    aws s3 website s3://$BUCKET_NAME --index-document index.html --error-document error.html --region $REGION

    curl http://$BUCKET_NAME.s3-website-$REGION.amazonaws.com/$FOLDER_NAME/index.html

    echo http://$BUCKET_NAME.s3-website-$REGION.amazonaws.com/$FOLDER_NAME/index.html