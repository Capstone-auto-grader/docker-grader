aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
aws configure set aws_secret_acces_key "$AWS_SECRET_ACCESS_KEY"
# echo $@
aws s3 cp s3://"$1" src.zip  # 1>/dev/null
aws s3 cp s3://"$2" test.zip # 1>/dev/null
# Note-- src.zip must be just the single project file
mkdir working-dir
mkdir test
# Another note-- test.zip must have only a "test" directory inside it
unzip src.zip -d './working-dir'  2>&1 1>/dev/null
unzip test.zip -d './test' 2>&1 1>/dev/null

if [ -d working-dir/__MACOSX ]; then
    rm -rf working-dir/__MACOSX
fi
if [ -d test/__MACOSX ]; then
    rm -rf test/__MACOSX
fi
project_root="./working-dir/$(ls working-dir | sed 's/\///g' )"

rm -r "$project_root/target/test-classes"
rm -r "$project_root/src/test"/*
# ls test
cp -r  test/*/* "$project_root/src/test/"
ls -a "$project_root"

# ls "$project_root/src/test/"
cd "$project_root"      
# pwd
# ls target
# ls src/test
# tree
mvn -Dtest=* test -Dmaven.compiler.failOnError=false 1>/dev/null

python ../../rename.py "$3"
cd ..
zip -r final.zip "$(ls | sed 's/\///g' )" 2>&1 1>/dev/null
aws s3 cp final.zip s3://"$1-ta-new" 1>/dev/null
rm final.zip
cd "$(ls | sed 's/\///g' )"
ls -a target/surefire-reports
cat target/surefire-reports/*.xml

