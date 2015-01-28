Chef::Log.info("Set nginx attributes")

authorized_ip = '10.0.0.0/8'

application_name = node[:opsworks][:applications].each do |application|
  application_name = application[:name].gsub('-', '_')
  if deploy[application_name.to_sym] && deploy[application_name.to_sym][:environment][:authorized_ip].present?
    authorized_ip = deploy[application_name.to_sym][:environment][:authorized_ip]
  end
end

default[:nginx_custom_ip][:authorized_ip] = authorized_ip
