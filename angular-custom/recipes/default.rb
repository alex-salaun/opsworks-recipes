node[:deploy].each do |application, deploy|
  env          = node[:angular][:env]
  current_path = deploy[:current_path]

  Chef::Log.info("Symlink files")

  script 'symlink_rootScope_file' do
    cwd current_path
    user 'deploy'
    code <<-EOH
      cd app/js/rootScope/
      ln -sf rootScope.#{env}.js rootScope.js
    EOH
  end

  script 'symlink_index' do
    cwd current_path
    user 'deploy'
    code <<-EOH
      cd app/
      ln -sf index.#{env}.html index.html
    EOH
  end
end
