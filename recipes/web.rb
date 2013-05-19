node.override['orch_web']['apps'] = []

node['orch']['apps'].each do |app|
  web = {
    'name'      => app['name'],
    'root_path' => app.fetch('root_path') { "/home/#{app['user']}/app/current/public" },
    'servers'   => app['servers'],
    'ssl'       => app['ssl']
  }

  node.override['orch_web']['apps'] << web
end

include_recipe "orch_web"
