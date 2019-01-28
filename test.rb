require 'nokogiri'
require 'json'

XML_HEADER = '<?xml version="1.0" encoding="UTF-8" ?>'

def main()
    input = open('test.xml').read()
    xmls = split_output_to_xmls(input)
    xmls.map { |xml| single_xml_string_to_hash(xml)}
end
def aggregate_json_hashes(hashes)
  hashes.map {|hash| hash[:failures]}.inject &:merge
end

def single_xml_string_to_hash(xml_string)
  xml_doc = Nokogiri::XML(xml_string)
  testsuite = xml_doc.at_xpath('//testsuite')
  testcases = xml_doc.xpath('//testcase')
  if testsuite.nil?
    return {'status' => 'failure', 'id' => 1   }
  end
  json_hash = {
      'status' => 'ok',
      'id' => 1,
      'number_of_tests' => testsuite.attribute('tests').text.to_i,
      'number_of_failures' => testsuite.attribute('failures').text.to_i,
      'number_of_errors' => testsuite.attribute('errors').text.to_i
  }
  failures = testcases.select {|c| !c.children.empty?}.map do |t|
    ret = []
    if t.at_xpath('//failure')
      if ! t.at_xpath('//failure').attribute('message').nil?
        ret << [:failure, t.at_xpath('//failure').attribute('message').at_xpath('text()') ? t.at_xpath('//failure').attribute('message').text : t.at_xpath('//failure/text()').text  ]

      else
        ret << [:failure, t.at_xpath('//failure').attribute('type').text]
      end
    end
    if t.at_xpath('//error')
      ret << [:error, t.at_xpath('//error').text]
    end
    [t.attribute('name').text , ret.to_h]
  end
  json_hash[:failures] = failures.to_h
  json_hash
end


def split_output_to_xmls(output)
  return output.split(XML_HEADER).map {|elem| XML_HEADER + elem }.drop(1)
end

puts aggregate_json_hashes(main)