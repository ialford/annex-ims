require_relative 'boot'

require 'csv'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
# require "active_storage/engine"
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
# require 'action_cable/engine'
require 'sprockets/railtie'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:application, *Rails.groups)

module AnnexIms
  class Application < Rails::Application
    config.autoload_paths += [Rails.root.join('app', 'services', 'queries', 'presenters').to_s]
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults = 6.0
    config.autoloader = :classic

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Eastern Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join("my", "locales", "*.{rb,yml}").to_s]
    # config.i18n.default_locale = :de

    # ActiveJob needs a back end. In our case, it"s RabbitMQ, via sneakers.
    config.active_job.queue_adapter = :sneakers

    config.generators do |g|
      g.assets = false # Don"t auto generate assets as part of a resource generation
      g.helper = false # Don"t auto generate helper modules as part of a resource generation

      g.test_framework(
        :rspec, fixtures: false, view_specs: false, helper_specs: false, routing_specs: false, controller_specs: false, request_specs: false
      )
    end

    # It appears that we are using helpers, so make it easy to keep using them.
    config.action_controller.include_all_helpers = true
  end
end
