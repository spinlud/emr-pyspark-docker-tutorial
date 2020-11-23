#!/bin/bash

aws emr create-cluster \
--name 'Cluster Docker Transient' \
--release-label emr-6.1.0 \
--applications Name=Hadoop Name=Spark Name=Ganglia \
--log-uri s3://rb-deleteme2/logs \
--ec2-attributes "KeyName=RB-Test,SubnetId=subnet-3d12ca12" \
--instance-groups file://./config/instance_groups.json \
--auto-scaling-role EMR_AutoScaling_DefaultRole \
--configurations file://./config/emr-configuration.json \
--steps file://./config/steps.json \
--auto-terminate \
--enable-debugging \
--use-default-roles



# aws s3 cp dist/emr_spark_tutorial-1.0.0-py3.8.egg s3://rb-deleteme2/
# aws s3 cp src/my_spark_app/index.py s3://rb-deleteme2/
# docker build --rm -f Dockerfile.custom -t emr-spark-tutorial .
# docker tag emr-spark-tutorial:latest 617090640476.dkr.ecr.us-east-1.amazonaws.com/emr-spark-tutorial:latest
# docker push 617090640476.dkr.ecr.us-east-1.amazonaws.com/emr-spark-tutorial:latest
# cd emr && ./launch-cluster.sh