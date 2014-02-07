class YmlGenerator < Rails::Generators::Base

  source_root File.expand_path('../templates', __FILE__)

  desc "Copy default YML to config"
  def copy_yml
    template 'thermometer.yml', 'config/thermometer.yml'
  end
end