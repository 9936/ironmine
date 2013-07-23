class ModuleGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("../templates", __FILE__)

  attr_reader :module_name, :module_real_name, :module_path

  def initialize(*args)
    super
    @module_name = file_name.underscore
    @module_real_name = module_name.split("_").last
    @module_path = "#{Rails.application.config.fwk.module_folder || "modules"}/#{module_name}"
  end

  def create_module_folders
    empty_directory "#{module_path}"
    empty_directory "#{module_path}/app"
    empty_directory "#{module_path}/app/controllers"
    empty_directory "#{module_path}/app/helpers"
    empty_directory "#{module_path}/app/models"
    empty_directory "#{module_path}/app/views"
    empty_directory "#{module_path}/config"
    empty_directory "#{module_path}/config/initializers"
    empty_directory "#{module_path}/config/locales"
    empty_directory "#{module_path}/db"
    empty_directory "#{module_path}/db/data"
    empty_directory "#{module_path}/db/migrate"
    empty_directory "#{module_path}/lib"
    empty_directory "#{module_path}/lib/#{module_real_name}"

    template 'init_.rb',    "#{module_path}/initializers/init_#{module_real_name}.rb"
    template 'routes.rb',   "#{module_path}/config/routes.rb"
    template 'en.yml',      "#{module_path}/config/locales/en.yml"
    template 'ja.yml',      "#{module_path}/config/locales/ja.yml"
    template 'zh.yml',      "#{module_path}/config/locales/zh.yml"
    template 'init_data.rb',"#{module_path}/lib/init_data.rb"
  end
end