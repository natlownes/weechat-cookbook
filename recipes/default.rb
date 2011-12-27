#
# Cookbook Name:: weechat-cookbook
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package 'weechat' do
  package_name = value_for_platform(
    ['debian', 'ubuntu'] => {'default' => 'weechat-curses'},
    ['mac_os_x'] => {'default' => 'weechat'}
  )
  action :install
end

