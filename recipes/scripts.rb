script_languages = {
  'py' => 'python',
  'rb' => 'ruby'
}

scripts_directories = script_languages.values.map {|name| ".weechat/#{name}/autoload" }

base_scripts_url = "http://www.weechat.org/files/scripts/"

node[:weechat][:users].each do |username|
  scripts_directories.each do |directory_name|
    directory (File.join(UserUtilities.home_directory_for_user(username), directory_name)) do
      recursive   true
      owner       username
      action      :create
    end
  end

  node[:weechat][:scripts].each do |script|
    script_language = script[:name].split('.').last
    local_path = File.join(UserUtilities.home_directory_for_user(username), ".weechat", script_languages[script_language], script[:name]) 
    autoload_symlink_path = File.join(UserUtilities.home_directory_for_user(username), ".weechat", script_languages[script_language], "autoload", script[:name]) 

    link autoload_symlink_path do
      to local_path
      action :nothing
    end

    remote_file local_path do
      source = base_scripts_url + "#{script[:name]}"
      if script[:autoload]
        notifies :create, resources(:link => autoload_symlink_path), :immediately
      end
    end
  end
end
