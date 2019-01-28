require 'yaml'
require 'docker'
files = ["auto-grader-capstone/aevard_fffffffffff_2170935_1547869769", "auto-grader-capstone/dlay_fffffffffff_2170951_1547869773", "auto-grader-capstone/matthewchen_fffffffffff_2170959_1547869758", "auto-grader-capstone/bsiege_fffffffffff_2170924_1547869776", "auto-grader-capstone/alanh0860_fffffffffff_2170956_1547869770", "auto-grader-capstone/mkim99_fffffffffff_2170972_1547869771", "auto-grader-capstone/jcfreedman_fffffffffff_2170898_1547869770", "auto-grader-capstone/michaelsun_fffffffffff_2170985_1547869777", "auto-grader-capstone/ruoshiliu_fffffffffff_2170840_1547869773", "auto-grader-capstone/jsoohoo_fffffffffff_2170859_1547869777", "auto-grader-capstone/eberleant_fffffffffff_2170970_1547869757", "auto-grader-capstone/jbrandon_fffffffffff_2170858_1547869758", "auto-grader-capstone/afleishaker_fffffffffff_2170902_1547869769", "auto-grader-capstone/tharding_fffffffffff_2170894_1547869770", "auto-grader-capstone/nkubatin_fffffffffff_2170933_1547869771", "auto-grader-capstone/mattdguerra_fffffffffff_2170987_1547869770", "auto-grader-capstone/egreszes_fffffffffff_2170950_1547869770", "auto-grader-capstone/afong_fffffffffff_2170960_1547869769", "auto-grader-capstone/emilykut_fffffffffff_2170843_1547869771", "auto-grader-capstone/vlauffer_fffffffffff_2170949_1547869772", "auto-grader-capstone/h20park_fffffffffff_2170906_1547869774", "auto-grader-capstone/mgadgil_fffffffffff_2170920_1547869770", "auto-grader-capstone/jiangzhiyun_fffffffffff_2170942_1547869770", "auto-grader-capstone/bknesbitt_fffffffffff_2170847_1547869773", "auto-grader-capstone/kougasiana_fffffffffff_2170890_1547869771", "auto-grader-capstone/mitchellryan99_fffffffffff_2170891_1547869774", "auto-grader-capstone/jtstamand_fffffffffff_2170893_1547869777", "auto-grader-capstone/jsmith2021_fffffffffff_2170887_1547869777", "auto-grader-capstone/dennisli_fffffffffff_2170996_1547869773", "auto-grader-capstone/bscott_fffffffffff_2170866_1547869776", "auto-grader-capstone/mmillendorf_fffffffffff_2170997_1547869773", "auto-grader-capstone/nwheeler_fffffffffff_2170964_1547869778", "auto-grader-capstone/arjunalbert_fffffffffff_2170925_1547869747", "auto-grader-capstone/ztbartolome_fffffffffff_2170846_1547869757", "auto-grader-capstone/danaxa_fffffffffff_2170963_1547869758", "auto-grader-capstone/mdodell_fffffffffff_2170981_1547869769", "auto-grader-capstone/aevans21_fffffffffff_2170911_1547869769", "auto-grader-capstone/casperlk_fffffffffff_2170896_1547869772", "auto-grader-capstone/fredmendoza_fffffffffff_2170845_1547869773", "auto-grader-capstone/shuminchen_fffffffffff_2181646_1547869768", "auto-grader-capstone/elazare_fffffffffff_2170868_1547869769", "auto-grader-capstone/apenso_fffffffffff_2170876_1547869774", "auto-grader-capstone/xinruis_fffffffffff_2170888_1547869777", "auto-grader-capstone/jspear_fffffffffff_2170837_1547869777", "auto-grader-capstone/msilveira66_fffffffffff_2170984_1547869777", "auto-grader-capstone/nag1298_fffffffffff_2170962_1547869770", "auto-grader-capstone/ataber_fffffffffff_2170990_1547869777", "auto-grader-capstone/astien97_fffffffffff_2170983_1547869777", "auto-grader-capstone/wangjiaqi2017_fffffffffff_2170988_1547869778", "auto-grader-capstone/ctran_fffffffffff_2170939_1547869778", "auto-grader-capstone/aregna_fffffffffff_2170912_1547869774", "auto-grader-capstone/ar226_fffffffffff_2170979_1547869776", "auto-grader-capstone/drubio_fffffffffff_2170921_1547869776", "auto-grader-capstone/yuewang_fffffffffff_2170879_1547869778", "auto-grader-capstone/engarde_fffffffffff_2170948_1547869778"] 

YAML.load(File.open('local_env.yml')).each do |key, value|
    ENV[key.to_s] = value
end
SECRET_KEY = ENV['SECRET_KEY']
ACCESS_KEY = ENV['ACCESS_KEY']
Excon.defaults[:write_timeout] = 1000
Excon.defaults[:read_timeout] = 1000
puts :loaded
Docker.url = 'tcp://localhost:2375'
image = Docker::Image.build_from_dir('./run-moss') do |msg|
    puts msg
end
puts :container_created
container = Docker::Container.create('Image' => image.id, 
    'Env' => ["AWS_SECRET_ACCESS_KEY=#{SECRET_KEY}", "AWS_ACCESS_KEY_ID=#{ACCESS_KEY}"],
    'Cmd' => ['ruby', 'moss.rb'] + files,
    'Tty' => true)
puts :container_starting
container.tap(&:start).attach(:tty => true)
puts container.logs(stdout: true)
# container.tap(&:start).attach { |stream, chunk| puts "#{stream}: #{chunk}" }
    