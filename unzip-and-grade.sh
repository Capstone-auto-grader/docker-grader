aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
aws configure set aws_secret_acces_key "$AWS_SECRET_ACCESS_KEY"
echo $@
aws s3 cp s3://"$1" src.zip  1>/dev/null
aws s3 cp s3://"$2" test.zip 1>/dev/null
# Note-- src.zip must be just the single project file

# Another note-- test.zip must have only a "test" directory inside it
unzip src.zip -d './working-dir' 1>/dev/null
unzip test.zip -d './test' 1>/dev/null

if [ -d working-dir/__MACOSX ]; then
    rm -rf working-dir/__MACOSX
fi
project_root="./working-dir/$(ls working-dir | sed 's/\///g' )"

rm -r "$project_root/target/test-classes"
rm -r "$project_root/src/test"/*
cp -r  test/*/* "$project_root/src/test/"

cd "$project_root"  
mvn test 1>/dev/null

# ls -a src/test
cat target/surefire-reports/*.xml
