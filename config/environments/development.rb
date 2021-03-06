Critiq0::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # config/environments/production.rb
  config.paperclip_defaults = {
    :storage => :s3,
    :s3_endpoint => "s3-us-west-2.amazonaws.com",
    :s3_credentials => {
      :bucket => ENV['AWS_BUCKET'],
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
    }
  }

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => ENV['GMAIL_DOMAIN'],
    :user_name            => ENV['GMAIL_NAME'],
    :password             => ENV['GMAIL_PASSWORD'],
    :authentication       => "plain",
    :enable_starttls_auto => true
  }

  #ActionMailer::Base.smtp_settings = {
  #  :address              => "smtp.office365.com",
  #  :port                 => 587,
  #  :domain               => ENV['OUTLOOK_DOMAIN'],
  #  :user_name            => ENV['OUTLOOK_NAME'],
  #  :password             => ENV['OUTLOOK_PASSWORD'],
  #  :authentication       => "plain",
  #  :enable_starttls_auto => true
  #}


  config.action_mailer.default_url_options = {host: 'localhost'}

end
