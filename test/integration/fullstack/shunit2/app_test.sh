test_app_is_running_on_port_80()
{
  local output=$(curl -s http://localhost | grep working | sed -e 's/^[[:space:]]*//g')

  assertEquals "If you see this, the app is working." "$output"
}

test_app_is_running_on_ssl_port_443()
{
  local output=$(curl -s -k --cacert /etc/nginx/ssl/dummy_app.crt https://localhost | grep working | sed -e 's/^[[:space:]]*//g')

  assertEquals "If you see this, the app is working." "$output"
}

test_static_files_are_served()
{
  local output=$(curl -s http://localhost/robots.txt)
  IFS=$'\n' lines=($output)
  unset IFS

  assertEquals "User-Agent: *" "${lines[0]}"
}
