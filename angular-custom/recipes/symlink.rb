node[:deploy].each do |application, deploy|
  env          = node[:angular][:env]
  current_path = deploy[:current_path]

  Chef::Log.info("Symlink files")
  Chef::Log.info("Env : #{env}")

  script 'symlink_rootScope_file' do
    cwd current_path
    user 'deploy'
    code <<-EOH
      if test -f "app/js/rootScope/rootScope.#{env}.html"; ln -sf app/js/rootScope/rootScope.#{env}.html app/js/rootScope/rootScope.js;fi
    EOH
  end

  script 'symlink_index' do
    cwd current_path
    user 'deploy'
    code <<-EOH
      if test -f "app/index.#{env}.html"; ln -sf app/index.#{env}.html app/index.html;fi
    EOH
  end
end
