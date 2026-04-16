chmod 400 ~/Downloads/kintok_aws.pem
ssh -i ~/Downloads/kintok_aws.pem -N -L 3307:127.0.0.1:3306 ubuntu@34.213.189.135

ssh -i kintok_aws.pem -N -L 3307:127.0.0.1:3306 ubuntu@34.213.189.135