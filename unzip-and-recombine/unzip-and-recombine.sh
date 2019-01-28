aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
aws configure set aws_secret_acces_key "$AWS_SECRET_ACCESS_KEY"

final_zip_name="$1" 
shift
bucket_name="$1"
shift
mkdir to_zip


for uri in $@; do
    new_uri=$(echo $uri | cut -d / -f 2)
    aws s3 cp s3://"$uri" "$new_uri".zip
    mkdir "to_zip/$uri"
    unzip "$new_uri".zip -d "to_zip/$new_uri"
done

zip -r "$final_zip_name" to_zip

aws s3 cp  "$final_zip_name" s3://"$bucket_name/$final_zip_name"
