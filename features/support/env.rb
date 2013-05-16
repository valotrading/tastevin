require 'aruba/cucumber'

Before do
  set_env 'HOME', File.expand_path(File.join(current_dir, 'home'))
end
