test_app_is_running_on_port_80()
{
  local output=$(curl -s http://localhost | grep working | sed -e 's/^[[:space:]]*//g')

  assertEquals "If you see this, the app is working." "$output"
}
