require 'yaml'
require 'docker'
files = ["auto-grader-capstone/20190305-10-1f43lvq", "auto-grader-capstone/RMarcus_PA9.zip", "auto-grader-capstone/jinzhao_PA05_2476222_1551761206", "auto-grader-capstone/ericrosenheim_PA05_2476242_1551761207", "auto-grader-capstone/brojo9808_PA05_2476252_1551761204", "auto-grader-capstone/bobbienorman_PA05_2476274_1551761207", "auto-grader-capstone/zekaiwang_PA05_2476240_1551761210", "auto-grader-capstone/dmonroy_PA05_2476250_1551761208", "auto-grader-capstone/pyufeng_PA05_2476247_1551761207", "auto-grader-capstone/kevinawei_PA05_2476258_1551761209", "auto-grader-capstone/talitukachinsky_PA05_2476200_1551761212", "auto-grader-capstone/gpress2000_PA05_2476270_1551761206", "auto-grader-capstone/lliu504_PA05_2476226_1551761208", "auto-grader-capstone/jaytseng_PA05_2476238_1551761209", "auto-grader-capstone/youbina_PA05_2476259_1551761210", "auto-grader-capstone/dcao_PA05_2476246_1551761212", "auto-grader-capstone/egranor_PA05_2476235_1551761211", "auto-grader-capstone/nossu3751_PA05_2476281_1551761209", "auto-grader-capstone/allengaok12_PA05_2476212_1551761212", "auto-grader-capstone/arianahahalis_PA05_2476264_1551761208", "auto-grader-capstone/ehill103_PA05_2476275_1551761213", "auto-grader-capstone/allegracopland_PA05_2476277_1551761209", "auto-grader-capstone/tony47_PA05_2476260_1551761206", "auto-grader-capstone/jordangavilanez_PA05_2476197_1551761211", "auto-grader-capstone/staciweeks_PA05_2476195_1551761212", "auto-grader-capstone/allenjin_PA05_2476214_1551761206", "auto-grader-capstone/xay1995_PA05_2476245_1551760944", "auto-grader-capstone/twgalaxy16_PA05_2476218_1551761209", "auto-grader-capstone/esolomon_PA05_2476213_1551761205", "auto-grader-capstone/cindyhou0210_PA05_2476282_1551761208", "auto-grader-capstone/zhidongliu_PA05_2476273_1551761210", "auto-grader-capstone/vicentacayuela_PA05_2476244_1551760943", "auto-grader-capstone/chensq64_PA05_2476224_1551760943", "auto-grader-capstone/colepeterson_PA05_2476280_1551760944", "auto-grader-capstone/haoranchen_PA05_2476208_1551761203", "auto-grader-capstone/lespinalro100_PA05_2476232_1551761204", "auto-grader-capstone/yichengtao_PA05_2476198_1551761213", "auto-grader-capstone/amygao1997_PA05_2476215_1551761207", "auto-grader-capstone/luoyiyang_PA05_2476225_1551761207", "auto-grader-capstone/kotagrace_PA05_2476216_1551761207", "auto-grader-capstone/dannyphan_PA05_2476251_1551761208", "auto-grader-capstone/jadeng_PA05_2476236_1551761208", "auto-grader-capstone/kunli_PA05_2476211_1551761208", "auto-grader-capstone/wuck_PA05_2476271_1551761208", "auto-grader-capstone/benjaminbeizer_PA05_2476257_1551761208", "auto-grader-capstone/andrews9008_PA05_2476272_1551761209", "auto-grader-capstone/wxjdm_PA05_2476243_1551761204", "auto-grader-capstone/jgora_PA05_2476234_1551761205", "auto-grader-capstone/nbrowe_PA05_2476276_1551761205", "auto-grader-capstone/jiaweiyang_PA05_2476219_1551761205", "auto-grader-capstone/gli5860_PA05_2476279_1551761205", "auto-grader-capstone/pufomadu20_PA05_2476254_1551761205", "auto-grader-capstone/oliveradk_PA05_2476262_1551761206", "auto-grader-capstone/festrella_PA05_2476267_1551761206", "auto-grader-capstone/wanyidai_PA05_2476233_1551761206", "auto-grader-capstone/jingrao_PA05_2476248_1551761206", "auto-grader-capstone/thomasmcsorley_PA05_2476261_1551761209", "auto-grader-capstone/andrewyan_PA05_2476203_1551761209", "auto-grader-capstone/cathyxie_PA05_2476266_1551761210", "auto-grader-capstone/cvacirca_PA05_2476206_1551761211", "auto-grader-capstone/ipena12_PA05_2476229_1551761211", "auto-grader-capstone/rvicwang_PA05_2476196_1551761211", "auto-grader-capstone/xuyuchen_PA05_2476255_1551761212", "auto-grader-capstone/tristantseng_PA05_2476228_1551761212", "auto-grader-capstone/jjakab123_PA05_2476223_1551761213", "auto-grader-capstone/adamtzeng_PA05_2476227_1551761213", "auto-grader-capstone/aichuktripura_PA05_2476210_1551760944", "auto-grader-capstone/avilepsky_PA05_2476201_1551760943", "auto-grader-capstone/vjois_PA05_2476204_1551761206", "auto-grader-capstone/vimouzin_PA05_2476284_1551761213"]

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
    