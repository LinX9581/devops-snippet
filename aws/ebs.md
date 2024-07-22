
## EBS
* create volume
aws ec2 create-volume \
    --volume-type gp3 \
    --size 3 \
    --iops 3000 \
    --throughput 125 \
    --availability-zone ap-northeast-1a \
    --encrypted \
    --tag-specifications 'ResourceType=volume,Tags=[{Key=Name,Value=MyEncryptedVolume}]'

* get volume id
aws ec2 describe-volumes --filters Name=tag:Name,Values=MyEncryptedVolume

* get instance id
aws ec2 describe-instances --filters Name=tag:Name,Values=test8

* attach volume
aws ec2 attach-volume \
    --volume-id vol-08881279f81872485 \
    --instance-id i-0c075e12f7bf93594 \
    --device /dev/sdf

## mount volume
* if disk is new
mkfs -t ext4 /dev/xvdf

* if disk is old
lsblk , get attached disk name
mount /dev/xvdf /mnt/ebs_volume
