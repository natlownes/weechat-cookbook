#
# Cookbook Name:: weechat-cookbook
# Recipe:: default

package 'weechat' do
  package_name = value_for_platform(
    ['debian', 'ubuntu'] => {'default' => 'weechat-curses'},
    ['mac_os_x'] => {'default' => 'weechat'}
  )
  action :install
end

