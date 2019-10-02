require 'moss_ruby'

moss = MossRuby.new(ENV['MOSS_KEY'])

files = ARGV[1..-1].join(' ')

base_file = ARGV[0]


base_file_str = base_file.strip.empty? ? 'nil' : base_file
base_file_param = "base_file=#{base_file_str}"
moss.options[:language] = 'python'
to_check = MossRuby.empty_file_hash

`bash /moss.sh #{base_file_str} #{files}`
unless base_file.strip.empty?
    MossRuby.add_base_file(to_check, '/base_file/**/*.py')
end
MossRuby.add_file(to_check,File.absolute_path('/to_eval/**/*.py'))

url = moss.check to_check

puts url