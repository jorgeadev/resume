#!/bin/bash

echo "


To use this file with your EC2' user-data, simply add the below 2 lines into the ec2 user-data


"
yum update -y

yum install -y httpd

systemctl start httpd
systemctl enable httpd

usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www

chmod 2775 /var/www

find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;

## update to use token on IMDSv2
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`

INSTANCE_INFO=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/dynamic/instance-identity/document)

INSTANCE_ID=$(printf "$INSTANCE_INFO" |  grep instanceId | awk '{print $3}' | sed s/','//g | sed s/'"'//g)

INSTANCE_AZ=$(printf "$INSTANCE_INFO" |  grep availabilityZone | awk '{print $3}' | sed s/','//g | sed s/'"'//g)

INSTANCE_TYPE=$(printf "$INSTANCE_INFO" |  grep instanceType | awk '{print $3}' | sed s/','//g | sed s/'"'//g)

INSTANCE_REGION=$(printf "$INSTANCE_INFO" |  grep region | awk '{print $3}' | sed s/','//g | sed s/'"'//g)


cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Hello World sample page created using EC2 userdata</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta charset="UTF-8">
  <style>
    body {
      background: url("https://www.antoniofeijao.com/assets/images/philipp-katzenberger-iIJrUoeRoCQ-unsplash.jpg") no-repeat center center fixed;
      -webkit-background-size: cover;
      -moz-background-size: cover;
      -o-background-size: cover;
      background-size: cover;
      background-color: DarkSlateGrey;
      text-align: center;
      color: GhostWhite;
    }
    
    .centered {
      position: fixed;
      top: 20%;
      left: 50%;
      /* bring your own prefixes */
      transform: translate(-50%, -50%);
    }
    
    .footer {
            position: fixed;
            left: 0;
            bottom: 0;
            width: 100%;
            background-color: GhostWhite;
            color: DarkSlateGrey;
            text-align: center;
    }
    
    table {
      font-family: arial, sans-serif;
      border-collapse: collapse;
      width: 80%;
      font-size: 1.875em;
    }
    
    td, th {
      border: 1px solid #dddddd;
      text-align: left;
      padding: 8px;
    }
  </style>
</head>
<body>
  <div class=centered>
    <h1>Hello World sample page created using EC2 userdata</h1>
    <h2>by Wan Scape Inc</h2>
    
    <h3 id="my-url"></h3>

    <table>
      <tr>
        <td>Instance ID</td>
        <td><code> ${INSTANCE_ID} </code></td>
      </tr>
      <tr>
        <td>Instance Type</td>
        <td><code> ${INSTANCE_TYPE} </code></td>
      </tr>
      <tr>
        <td>Instance Region</td>
        <td><code> ${INSTANCE_REGION} </code></td>
      </tr>
      <tr>
        <td>Availability Zone</td>
        <td><code> ${INSTANCE_AZ} </code></td>
      </tr>
    </table>
  </div>

    <div class="footer">
        <p><a href="https://www.wan-scape.com/" target="_blank">https://www.wan-scape.com/</a></p>
    </div>

    <script>
        document.getElementById("my-url").innerHTML = 
        "Welcome to " + window.location.href;
    </script>

</body>
</html>
EOF
