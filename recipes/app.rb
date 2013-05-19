node.override['orch_app']['apps'] = []

node['orch']['apps'].each do |app|
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

include_recipe "orch_app"
