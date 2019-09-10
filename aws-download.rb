require 'aws-sdk'
require 'yaml'
require 'docker'
require 'json'

puts 'aaa'
# Docker.url = 'tcp://stravinsky.eastus.cloudapp.azure.com:2375'
YAML.load(File.open('local_env.yml')).each do |key, value|
    ENV[key.to_s] = value
end
Excon.defaults[:write_timeout] = 1000
Excon.defaults[:read_timeout] = 1000

SECRET_KEY = ENV['SECRET_KEY']
ACCESS_KEY = ENV['ACCESS_KEY']
src = "auto-grader-capstone/allenjin_Exam!!!_2541274_1557420278"
tests = 'auto-grader-capstone/Exam_Tests.zip'
# Aws.config.update({
#     region: 'us-east-1',
#     access_key_id: ENV['ACCESS_KEY'],
#     secret_access_key: ENV['SECRET_KEY'],
#                   })

puts 'doin shit'
# S3_BUCKET = Aws::S3::Resource.new.bucket('auto-grader-capstone')

# obj = S3_BUCKET.object('aaa.tar').presigned_url(:get, expires_in: 60)
puts 'url shit'
image = Docker::Image.build_from_dir('unzip-and-grade')
puts image
container = Docker::Container.create('Image' => image.id, 
                  'Env' => ["AWS_SECRET_ACCESS_KEY=#{SECRET_KEY}", "AWS_ACCESS_KEY_ID=#{ACCESS_KEY}", '_JAVA_OPTIONS="-XX:MaxPermSize=512m -Xmx512m"'],
                   'Cmd' => ['./unzip-and-grade.sh', src, tests, 'aaaaa'],
                   'Tty' => true)

# container = Docker::Container.create('Image' => '668b495160f3', 
#                   'Env' => ["AWS_SECRET_ACCESS_KEY=#{SECRET_KEY}", "AWS_ACCESS_KEY_ID=#{ACCESS_KEY}"],
#                    'Cmd' => ['bash', '-c', "aws s3 cp s3://#{src} a.zip && ls"],
#                    'Tty' => true)
puts container.tap(&:start).attach(:tty => true)
# json = JSON.parse container.json

puts container.json["State"]["ExitCode"]
xml = container.logs(stdout: true)
File.open('test.xml', 'w') do |file|
    file.write xml
end
puts xml

