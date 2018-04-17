require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Gesanghua
  class Application < Rails::Application
    require_relative "../app/middlewares/snake_case_parameters"
    config.middleware.use SnakeCaseParameters

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.autoload_paths += %w(#{config.root}/app/models/ckeditor)
    config.eager_load_paths += %W(#{config.root}/lib #{config.root}/app/uploaders)

    config.active_record.default_timezone = :local
    config.time_zone = 'Beijing'

    config.i18n.default_locale = :zh

    config.encoding = "utf-8"


    config.generators do |g|
      # 禁止生成针对控制器的静态资源文件
      g.assets false
    end


    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
