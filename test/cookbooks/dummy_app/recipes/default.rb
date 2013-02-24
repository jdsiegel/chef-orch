remote_directory "/home/vagrant/app/release" do
  source "dummy_app"
  files_owner "vagrant"
  files_group "vagrant"
  files_mode "0644"
  owner "vagrant"
  group "vagrant"
  mode "2755"
end

# remote_directory does not properly set the ownership of some directories.
# we must explicitly change ownership of the entire dummy app
bash "ensure_user_owns_dummy_app" do
  code <<-BASH
    chown -R vagrant:vagrant /home/vagrant/app/release
  BASH
end

link "/home/vagrant/app/current" do
  to "/home/vagrant/app/release"
end

bash "bundle_install" do
  code <<-BASH
    su vagrant -l -c 'cd /home/vagrant/app/current && bundle install --deployment'
  BASH
end

bash "precompile_assets" do
  code <<-BASH
    su vagrant -l -c 'cd /home/vagrant/app/current && bundle exec rake assets:precompile'
  BASH
end

bash "prepare_database" do
  code <<-BASH
    su vagrant -l -c 'cd /home/vagrant/app/current && bundle exec rake db:migrate db:seed'
  BASH
end
