# aws-ec2-userdata-samples
AWS EC2 userdata-samples



## Sample userdata for ec2 and how to use it

In the userdata for the ec2, add the command `curl` and the link for the script you want to run folloed by pip `| bash` to execute the script. 


```
#!/bin/bash

cd /tmp/

curl https://github.com/naztyroc/resume/blob/master/aws-cloud-user-data/sample01-hello-world-region-az.sh | bash
```
