require 'docker'
require 'nokogiri'
require 'json'
require 'yaml'
YAML.load(File.open('local_env.yml')).each do |key, value|
    ENV[key.to_s] = value.to_s
end
SECRET_KEY = ENV['SECRET_KEY']
ACCESS_KEY = ENV['ACCESS_KEY']
# Docker.url = 'tcp://localhost:2375'
# make image with name grading
image = Docker::Image.build_from_dir('unzip-and-grade') do |v|
    puts v.inspect
    logs = v.split("\n").map{ |x| JSON.parse(x) }
    for log in logs
        if log.has_key?("stream")
            $stdout.puts log["stream"]
        end
    end
    # if (log = JSON.parse(v)) && log.has_key?("stream")
    #     $stdout.puts log["stream"]
    # end
end

puts Docker::Image.exist?(image.id)

tests = 'auto-grader-bucket/test.zip'
src = 'auto-grader-bucket/submission.zip'
container = Docker::Container.create('Image' => image.id, 
                  'Env' => ["AWS_SECRET_ACCESS_KEY=#{SECRET_KEY}", "AWS_ACCESS_KEY_ID=#{ACCESS_KEY}", "AWS_DEFAULT_REGION=us-east-1"],
                   'Cmd' => ['./unzip-and-grade.sh', src, tests],
                   'Tty' => true)

# container = Docker::Container.create('Image' => '668b495160f3', 
#                     'Env' => ["AWS_SECRET_ACCESS_KEY=#{SECRET_KEY}", "AWS_ACCESS_KEY_ID=#{ACCESS_KEY}", "AWS_DEFAULT_REGION=us-east-1"],
#                     'Cmd' => ['./unzip-and-grade.sh', src, tests],
#                     'Tty' => true)
puts "testing"
container.tap(&:start).attach(:tty => true)
xml = container.logs(stdout: true)
puts 'tests done'
puts xml
a = Nokogiri::XML(xml)
puts a
testsuite = a.at_xpath('//testsuite')
testcases = a.xpath('//testcase')

json_hash = {
    'number-of-tests' => testsuite.attribute('tests'),
    'number-of-failures' => testsuite.attribute('failures'),
    'number-of-errors' => testsuite.attribute('errors')
}


failures = testcases.select {|c| !c.children.empty?}.map do |t|
    ret = []
    if t.at_xpath('//failure')
        ret << [:failure, t.at_xpath('//failure').attribute('message').at_xpath('text()') ? t.at_xpath('//failure').attribute('message').text : t.at_xpath('//failure/text()').text  ]
    end
    if t.at_xpath('//error')
        ret << [:error, t.at_xpath('//error').text]
    end
    [t.attribute('name').text , ret.to_h]
end
json_hash[:failures] = failures.to_h
# puts json_hash
puts json_hash.to_json