node.override['orch_db']['databases'] = []
node.override['orch_web']['apps'] = []
node.override['orch_app']['apps'] = []

node['orch']['apps'].each do |app|

  db = {
    'name'     => app['name'],
    'user'     => app['user'],
    'password' => app['db_password'],
    'type'     => app['db_type']
  }

  node.override['orch_db']['databases'] << db

  web = {
    'name'      => app['name'],
    'root_path' => app.fetch('root_path') { "/home/#{app['user']}/app/current/public" },
    'servers'   => app['servers']
  }

  node.override['orch_web']['apps'] << web

  app = {
    'name'         => app['name'],
    'user'         => app['user'],
    'port'         => app.fetch('port') { 5000 },
    'ruby_version' => app['ruby_version'],
    'processes'    => app.fetch('processes') { [['all', 1]] },
    'environment'  => app['environment']
  }

  node.override['orch_app']['apps'] << app
end

include_recipe "orch_db"
include_recipe "orch_web"
include_recipe "orch_app"
