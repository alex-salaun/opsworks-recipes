node[:deploy].each do |application, deploy|
  env          = node[:angular][:env]
  current_path = deploy[:current_path]

  Chef::Log.info("Symlink files")
  Chef::Log.info("Env : #{env}")

  Chef::Log.info("Path rootScope : /srv/www/isis_staging-1/current/app/js/rootScope/rootScope.#{env}.html")

  script 'symlink_rootScope_file' do
    cwd '/'
    user 'deploy'
    code <<-EOH
      if test -f "/srv/www/isis_staging-1/current/app/js/rootScope/rootScope.#{env}.html"; ln -sf /srv/www/isis_staging-1/current/app/js/rootScope/rootScope.#{env}.html /srv/www/isis_staging-1/current/app/js/rootScope/rootScope.js;fi
    EOH
  end

  Chef::Log.info("Path index.html : #{current_path}/app/index.#{env}.html")

  script 'symlink_index' do
    cwd '/'
    user 'deploy'
    code <<-EOH
      if test -f "/srv/www/isis_staging-1/current/app/index.#{env}.html"; ln -sf /srv/www/isis_staging-1/current/app/index.#{env}.html /srv/www/isis_staging-1/current/app/index.html;fi
    EOH
  end
end
