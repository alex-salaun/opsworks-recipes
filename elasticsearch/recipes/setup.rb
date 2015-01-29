Chef::Log.info("Configure Nginx")

node[:deploy].each do |app_name, deploy|
  Chef::Log.info("Debug application type : #{deploy[:application_type]}")
  if defined?(deploy[:application_type]) && (deploy[:application_type] == 'custom' || deploy[:application_type] == 'rails')

    script "install_elasticsearch" do
      interpreter "bash"
      user "root"
      cwd "/"
      code <<-EOH
      wget -qO - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
      add-apt-repository 'deb http://packages.elasticsearch.org/elasticsearch/1.2/debian stable main'
      apt-get update && apt-get install elasticsearch=1.3.4
      EOH
    end

    service "elasticsearch" do
      action :stop
    end

    script "install_elasticsearch_plugin" do
      interpreter "bash"
      user "root"
      cwd "/"
      code <<-EOH
      /usr/share/elasticsearch/bin/plugin -install elasticsearch/elasticsearch-cloud-aws/2.3.0
      /usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head
      EOH
    end

    if deploy[:application_type] == 'custom'
      template "/etc/elasticsearch/elasticsearch.yml" do
        source "elasticsearch_master.yml.erb"

        variables(
          :elasticsearch_cluster    => node[:elasticsearch][:cluster],
          :elasticsearch_access_key => node[:elasticsearch][:access_key],
          :elasticsearch_secret_key => node[:elasticsearch][:secret_key]
        )
      end
    end

    if deploy[:application_type] == 'rails'
      template "/etc/elasticsearch/elasticsearch.yml" do
        source "elasticsearch_slave.yml.erb"

        variables(
          :elasticsearch_cluster    => node[:elasticsearch][:cluster],
          :elasticsearch_access_key => node[:elasticsearch][:access_key],
          :elasticsearch_secret_key => node[:elasticsearch][:secret_key]
        )
      end
    end

    service "elasticsearch" do
      action :start
    end
  end
end
