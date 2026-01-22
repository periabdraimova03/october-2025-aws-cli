#!/bin/bash

region="us-east-1"
vpc_cidr="192.168.0.0/16"
subnet1_cidr="192.168.1.0/24"
subnet2_cidr="192.168.2.0/24"
subnet3_cidr="192.168.3.0/24"

vpc_id=$(aws ec2 create-vpc --cidr-block 10.0.0.0/16 --region $region --tag-specification "ResourceType=vpc,Tags=[{Key=Name,Value=Kaizen}]" --query Vpc.VpcId --output text)

subnet1_id=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block subnet1_cidr --region $region --query Subnet.SubnetId --output text)
subnet2_id=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block subnet2_cidr --region $region --query Subnet.SubnetId --output text)
subnet3_id=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block subnet3_cidr --region $region --query Subnet.SubnetId --output text)


igw_id=$(aws ec2 create-internet-gateway --region $region --query InternetGateway.InternetGatewayId --output text)

aws ec2 attach-internet-gateway --vpc-id $vpc_id --internet-gateway-id $igw_id

rt=$(aws ec2 create-route-table --vpc-id $vpc_id --region $region --query RouteTable.RouteTableId --output text)

aws ec2 create-route --route-table-id $rt --destination-cidr-block 0.0.0.0/0 --gateway-id $igw_id

aws ec2 associate-route-table --subnet-id $subnet1_id --route-table-id $rt --region $region
aws ec2 associate-route-table --subnet-id $subnet2_id --route-table-id $rt --region $region
aws ec2 associate-route-table --subnet-id $subnet3_id --route-table-id $rt --region $region




