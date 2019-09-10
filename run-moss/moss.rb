require 'moss_ruby'

moss = MossRuby.new(ENV['MOSS_KEY'])

files = ARGV.join(' ')
# puts files
# puts ARGV
moss.options[:language] = 'python'
to_check = MossRuby.empty_file_hash

`bash /moss.sh #{files}`
MossRuby.add_base_file(to_check, '/base_file/**/*.py')
MossRuby.add_file(to_check,File.absolute_path('/to_eval/**/*.py'))

url = moss.check to_check

puts url