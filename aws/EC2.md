
## internet ssh
https://ip-ranges.amazonaws.com/ip-ranges.json
可以找到 EC2_INSTANCE_CONNECT 連線IP範圍: 3.112.23.0/29

## Cloudwatch
https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/install-CloudWatch-Agent-commandline-fleet.html
https://amazoncloudwatch-agent.s3.region.amazonaws.com/ubuntu/arm64/latest/amazon-cloudwatch-agent.deb
wget https://amazoncloudwatch-agent.s3.amazonaws.com/ubuntu/arm64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb

sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/path/to/your/config.json -s

{
  "metrics": {
    "append_dimensions": {
      "InstanceId": "${aws:InstanceId}"
    },
    "metrics_collected": {
      "disk": {
        "measurement": [
          "used_percent",
          "inodes_free"
        ],
        "resources": [
          "*"
        ]
      },
      "mem": {
        "measurement": [
          "mem_used_percent"
        ]
      }
    }
  }
}
