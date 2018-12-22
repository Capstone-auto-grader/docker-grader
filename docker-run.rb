require 'docker'
require 'nokogiri'
require 'json'
SECRET_KEY = '***********'
ACCESS_KEY = '***********'
# make image with name grading
image = Docker::Image.build_from_dir('.') do |v|
    if (log = JSON.parse(v)) && log.has_key?("stream")
        $stdout.puts log["stream"]
      end
end

tests = 'sternjtestbucket/test.zip'
src = 'sternjtestbucket/alanadvorkin_PA07.zip'
container = Docker::Container.create('Image' => image.id, 
                  'Env' => ["AWS_SECRET_ACCESS_KEY=#{SECRET_KEY}", "AWS_ACCESS_KEY_ID=#{ACCESS_KEY}"],
                   'Cmd' => ['./unzip-and-grade.sh', src, tests],
                   'Tty' => true)
puts "testing"
container.tap(&:start).attach(:tty => true)
xml = container.logs(stdout: true)
puts 'tests done'

a = Nokogiri::XML(xml)

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