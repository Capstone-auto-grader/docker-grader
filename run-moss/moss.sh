mkdir to_eval
aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
aws configure set aws_secret_acces_key "$AWS_SECRET_ACCESS_KEY"
# echo $@ 1>&2
mkdir base_file
base_file=$1
echo $1
new_base=$(echo $base_file | cut -d / -f 2)
aws s3 cp s3://"$base_file" "$new_base".zip
unzip "$new_base".zip -d "base_file/$new_base"

shift
# mkdir to_eval
for uri in $@; do
    # echo $uri 1>&2
    new_uri=$(echo $uri | cut -d / -f 2 | cut -d '_' -f 1)
    aws s3 cp s3://"$uri" "$new_uri".zip 1>/dev/null
    mkdir "to_eval/$new_uri"
    cd "to_eval/$new_uri"
    unzip -o -j "../../$new_uri".zip 1>/dev/null
    cd ../..
done

tree base_file
# tree to_eval