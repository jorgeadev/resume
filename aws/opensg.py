#!/usr/bin/env python3
## List all EC2 instances with public IPs with security groups that are exposed to the Internet

import boto3

ec2 = boto3.client('ec2')
response = ec2.describe_security_groups()
exposedSG = []
for securityGroups in response['SecurityGroups']:
  groupId=securityGroups['GroupId']
  marked=False
  for ipPermissions in securityGroups['IpPermissions']:
    for ipRanges in ipPermissions['IpRanges']:
      cidrIp=ipRanges['CidrIp']
      if not marked and cidrIp == "0.0.0.0/0":
        exposedSG.append(groupId)
        marked=True
      
response = ec2.describe_instances()
output = []
for reservations in response['Reservations']:
  for instance in reservations['Instances']:
    instanceId=instance['InstanceId']
    marked=False
    for networkInterfaces in instance['NetworkInterfaces']:
      for groups in networkInterfaces['Groups']:
        if not marked:
          for secGroup in exposedSG:
             if groups['GroupId'] == secGroup:
               marked=True
      if marked:
        try:
          publicIp = instance['PublicIpAddress']
          output.append((publicIp,instanceId))
        except:
          publicIp = "\"\""

for line in output:
  max = len(line)
  for num in range(0,max):
    if num != max-1:
      print(line[num]+'\t', end='')
    else:
      print(line[num], end='\n')

