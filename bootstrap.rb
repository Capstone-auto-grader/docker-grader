#! /usr/bin/env ruby
require 'json'
require 'excon'


server_path = ARGV[0]
bucket_name = ARGV[1]

batch = JSON.parse(Excon.get("#{server_path}/get_container_from_name?name=batch").body)
java = JSON.parse Excon.get("#{server_path}/get_container_from_name?name=java").body
moss = JSON.parse Excon.get("#{server_path}/get_container_from_name?name=moss").body

batch_id = batch.nil? ? nil : batch["id"]
java_id = java.nil? ? nil : java["id"]
moss_id = moss.nil? ? nil : moss["id"]

puts `./upload_single_tar.sh grade.tar #{bucket_name}/java.tar unzip-and-grade`
puts `./upload_single_tar.sh batch.tar #{bucket_name}/batch.tar unzip-and-recombine`
puts `./upload_single_tar.sh moss.tar #{bucket_name}/moss.tar run-moss`

batch_request, java_request, moss_request = ['batch', 'java', 'moss'].map do |name|
    {
        container: {
            name: name,
            config_uri: "#{name}.tar"
        }
    }
end

batch_uri, java_uri, moss_uri = [batch_id, java_id, moss_id].map {|x| x.nil? ? "" : "/#{x}"}
puts batch_uri, java_uri, moss_uri
patch_call = lambda{|route, **args| Excon.patch route, **args }
post_call = lambda{|route, **args| Excon.post route, **args }
batch_call, java_call, moss_call = [batch_uri, java_uri, moss_uri].map do |uri|
    uri.empty? ? post_call : patch_call
end
puts "#{server_path}/container#{batch_uri}", "#{server_path}/container#{java_uri}", "#{server_path}/container#{moss_uri}"
puts batch_call.call("#{server_path}/containers#{batch_uri}", body: batch_request.to_json, :headers => { "Content-Type" => "application/json" }).status
puts java_call.call("#{server_path}/containers#{java_uri}", body: java_request.to_json, :headers => { "Content-Type" => "application/json" }).status
puts moss_call.call("#{server_path}/containers#{moss_uri}", body: moss_request.to_json, :headers => { "Content-Type" => "application/json" }).status
