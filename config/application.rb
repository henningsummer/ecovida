require File.expand_path('../boot', __FILE__)
ENV['RANSACK_FORM_BUILDER'] = '::SimpleForm::FormBuilder'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Dotenv::Railtie.load if Rails.env == 'development'

module Opac
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    Rails.application.middleware.use Rack::Timeout
    Rack::Timeout.timeout = 600

    config.assets.initialize_on_precompile = false
    config.autoload_paths += %W( #{config.root}/app/services/ )
    config.autoload_paths += %W( #{config.root}/app/enumerations/ )
    config.autoload_paths += %W( #{config.root}/app/uploaders/ )

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :pt
    config.time_zone = 'Brasilia'
    config.active_record.default_timezone = :local

    config.active_job.queue_adapter = :delayed_job

    # Excon.ssl_verify_peer = false

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
  end
end
