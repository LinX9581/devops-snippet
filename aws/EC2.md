
## internet ssh
https://ip-ranges.amazonaws.com/ip-ranges.json
可以找到 EC2_INSTANCE_CONNECT 連線IP範圍: 3.112.23.0/29

## Cloudwatch
https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/install-CloudWatch-Agent-commandline-fleet.html
https://amazoncloudwatch-agent.s3.region.amazonaws.com/ubuntu/arm64/latest/amazon-cloudwatch-agent.deb


wget https://amazoncloudwatch-agent.s3.amazonaws.com/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb -O amazon-cloudwatch-agent.deb
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb

sudo tee /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json > /dev/null <<EOF
{
  "agent": {
    "metrics_collection_interval": 60,
    "logfile": "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log"
  },
  "metrics": {
    "namespace": "CWAgent",
    "metrics_collected": {
      "cpu": {
        "measurement": ["usage_idle", "usage_iowait", "usage_user", "usage_system"],
        "resources": ["*"],
        "totalcpu": true
      },
      "disk": {
        "measurement": ["used_percent", "inodes_free"],
        "resources": ["*"]
      },
      "mem": {
        "measurement": ["mem_used_percent"]
      },
      "net": {
        "measurement": ["bytes_sent", "bytes_recv"],
        "resources": ["*"]
      },
      "swap": {
        "measurement": ["swap_used_percent"]
      }
    }
  }
}
EOF
sudo systemctl enable amazon-cloudwatch-agent && \
sudo systemctl restart amazon-cloudwatch-agent