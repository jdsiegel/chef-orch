node.override['orch_db']['databases'] = []

node['orch']['apps'].each do |app|
  db = {
    'name'     => app['name'],
    'user'     => app['user'],
    'password' => app['db_password'],
    'type'     => app['db_type']
  }

  node.override['orch_db']['databases'] << db
end

include_recipe "orch_db"
