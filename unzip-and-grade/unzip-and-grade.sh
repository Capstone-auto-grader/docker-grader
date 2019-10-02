# aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
# aws configure set aws_secret_acces_key "$AWS_SECRET_ACCESS_KEY"
exitcode=0
# echo $@
aws s3 cp s3://"$1" src.zip  # 1>/dev/null
aws s3 cp s3://"$2" test.zip # 1>/dev/null
# Note-- src.zip must be just the single project file
mkdir working-dir
mkdir test
# Another note-- test.zip must have only a "test" directory inside it
unzip src.zip -d './working-dir'  2>&1 1>/dev/null
unzip test.zip -d './test' 2>&1 1>/dev/null

tree test

if [ -d working-dir/__MACOSX ]; then
    rm -rf working-dir/__MACOSX
fi
if [ -d test/__MACOSX ]; then
    rm -rf test/__MACOSX
fi

project_root="./working-dir/$(ls working-dir | sed 's/\///g' )"
ls "$project_root/target/surefire-reports"
rm "$project_root/target/surefire-reports/*"
rm -r "$project_root/target/test-classes"
rm -r "$project_root/src/test"/*
# ls test
python3 copy-manifest.py './test' $project_root
# cp -r  test/*/* "$project_root/src/test/"
# ls -a "$project_root"

# ls "$project_root/src/test/"
cd "$project_root"      

# pwd
# ls target
# ls src/test
# tree
a=$(mvn -Dtest=AllSequentialTests test)
echo $a
rm -rf target/test-classes
python ../../rename.py "$3"
cd ..
zip -r final.zip "$(ls | sed 's/\///g' )" 2>&1 1>/dev/null
aws s3 cp final.zip s3://"$1-ta-new" 1>/dev/null
rm final.zip
cd "$(ls | sed 's/\///g' )"
count=`ls -1 target/surefire-reports/*.xml 2>/dev/null | wc -l`
if [ $count == 0 ]; then
    exitcode=1
fi
if [[ $(echo $a | grep -i "no tests were executed") ]]; then
    exitcode=2
fi
if [[ $exitcode != 0 ]]; then
    exit $exitcode
fi

cat target/surefire-reports/*.xml
