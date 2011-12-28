#
# Cookbook Name:: weechat-cookbook
# Recipe:: default
#
require_recipe "weechat::scripts"

package 'weechat' do
  package_name = value_for_platform(
    ['debian', 'ubuntu'] => {'default' => 'weechat-curses'},
    ['mac_os_x'] => {'default' => 'weechat'}
  )
  action :install
end

node[:weechat][:users].each do |user|
  user_home = UserUtilities.home_directory_for_user(user[:name])
  weechat_home = File.join(user_home, ".weechat")

  directory weechat_home do
    owner  user[:name]
    mode   "0700"
    action :create
  end

  template File.join(weechat_home, "alias.conf") do
    source "alias.conf.erb"
  end
  
  if user[:irc] && user[:irc][:servers]
    template File.join(weechat_home, "irc.conf") do
      source "irc.conf.erb"
      variables(
        :servers => user[:irc][:servers]
      )
    end
  end

  if user[:jabber]
    template File.join(weechat_home, "jabber.conf") do
      source "jabber.conf.erb"
      variables(
        :servers => user[:jabber][:servers] || []
      )
    end
  end

  template File.join(weechat_home, "weechat.conf") do
    source "weechat.conf.erb"
  end

  template File.join(weechat_home, "logger.conf") do
    source "logger.conf.erb"
  end

  execute "update weechat owner to #{user[:name]}" do
    command "chown -R #{user[:name]} #{weechat_home}"
  end

  execute "update weechat mode" do
    command "chmod -R 700 #{weechat_home}"
  end
end

