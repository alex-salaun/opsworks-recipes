Chef::Log.info("Configure Nginx")

node[:deploy].each do |app_name, deploy|
  Chef::Log.info("Debug application type : #{deploy[:application_type]}")
  if defined?(deploy[:application_type]) && deploy[:application_type] == 'custom'

    script "add_htpasswd" do
      interpreter "bash"
      user "root"
      cwd "/"
      code <<-EOH
      wget -qO - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
      add-apt-repository 'deb http://packages.elasticsearch.org/elasticsearch/1.2/debian stable main'
      apt-get update && apt-get install elasticsearch
      EOH
    end

    service "elasticsearch" do
      action :stop
    end

    script "add_htpasswd" do
      interpreter "bash"
      user "root"
      cwd "/"
      code <<-EOH
      /usr/share/elasticsearch/bin/plugin -install elasticsearch/elasticsearch-cloud-aws/2.3.0
      /usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head
      EOH
    end

    template "/etc/elasticsearch/elasticsearch.yml" do
      source "elasticsearch.yml.erb"

      variables(
        :elasticsearch_cluster    => deploy[:environment][:elasticsearch_cluster],
        :elasticsearch_access_key => deploy[:environment][:elasticsearch_access_key],
        :elasticsearch_secret_key => deploy[:environment][:elasticsearch_secret_key]
      )
    end

    service "elasticsearch" do
      action :start
    end
  end
end
