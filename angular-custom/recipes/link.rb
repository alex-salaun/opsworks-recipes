node[:deploy].each do |application, deploy|
  Chef::Log.info("Debug : #{deploy[:application_type]}")
  Chef::Log.info("Debug : #{deploy}")

  if defined?(deploy[:application_type]) && deploy[:application_type] == 'static'
    env          = node[:angular][:env]
    current_path = deploy[:current_path]

    Chef::Log.info("Symlink files")
    Chef::Log.info("Env : #{env}")

    Chef::Log.info("Path rootScope : #{current_path}/app/js/rootScope/rootScope.#{env}.html")

    script 'symlink_rootScope_file' do
      cwd current_path
      user 'deploy'
      code <<-EOH
        rm app/js/rootScope/rootScope.js
        cp app/js/rootScope/rootScope.#{env}.js app/js/rootScope/rootScope.js
      EOH
    end

    Chef::Log.info("Path index.html : #{current_path}/app/index.#{env}.html")

    script 'symlink_index' do
      cwd current_path
      user 'deploy'
      code <<-EOH
        rm app/index.html
        cp app/index.#{env}.html app/index.html
      EOH
    end
  end
end
