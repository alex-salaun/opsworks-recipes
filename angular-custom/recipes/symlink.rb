node[:deploy].each do |application, deploy|
  env          = node[:angular][:env]
  current_path = deploy[:current_path]

  Chef::Log.info("Symlink files")
  Chef::Log.info("Env : #{env}")

  Chef::Log.info("Path rootScope : #{current_path}/app/js/rootScope/rootScope.#{env}.html")

  script 'symlink_rootScope_file' do
    cwd '/'
    user 'deploy'
    code <<-EOH
      if test -f "#{current_path}/app/js/rootScope/rootScope.#{env}.html"; ln -sf #{current_path}/app/js/rootScope/rootScope.#{env}.html #{current_path}/app/js/rootScope/rootScope.js;fi
    EOH
  end

  Chef::Log.info("Path index.html : #{current_path}/app/index.#{env}.html")

  script 'symlink_index' do
    cwd '/'
    user 'deploy'
    code <<-EOH
      if test -f "#{current_path}/app/index.#{env}.html"; ln -sf #{current_path}/app/index.#{env}.html #{current_path}/app/index.html;fi
    EOH
  end
end
