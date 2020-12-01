#!/bin/bash

EMR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

aws emr create-cluster \
--name 'PySpark Docker Tutorial Cluster' \
--release-label emr-6.2.0 \
--applications Name=Hadoop Name=Spark \
--log-uri s3://emr-pyspark-docker-tutorial-bucket/logs \
--instance-groups file://$EMR_DIR/config/instance_groups.json \
--auto-scaling-role EMR_AutoScaling_DefaultRole \
--configurations file://$EMR_DIR/config/services.json \
--steps file://$EMR_DIR/config/steps.json \
--auto-terminate \
--enable-debugging \
--use-default-roles
