aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
aws configure set aws_secret_acces_key "$AWS_SECRET_ACCESS_KEY"
aws s3 cp s3://"$1" src.zip 1>/dev/null
named_dir=$(echo $2 | sed s/ /_/g)
mkdir $named_dir
unzip src.zip -d $named_dir
zip -r final.zip $named_dir
aws s3 cp final.zip s3://"$1-ta-new" 1>/dev/null
