node[:deploy].each do |app_name, deploy|
  Chef::Log.info("Install pdftk")

  script "install_pdftk" do
    interpreter "bash"
    user "root"
    cwd "/home/ubuntu/"
    code <<-EOH
      apt-get install pdftk -y
    EOH
  end
end
