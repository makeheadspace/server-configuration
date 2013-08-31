Discourse::Application.configure do

  config.cache_classes = true

  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_assets = false
  config.assets.compress = true

  config.assets.compile = false
  config.assets.digest = true

  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'
  config.i18n.fallbacks = true


  # you may use other configuration here for mail eg: sendgrid

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address              => "smtp.mandrillapp.com",
    :port                 => 587,
    :domain               => 'forum.makeheadspace.com',
    :user_name            => 'zee@zeespencer.com',
    :password             => 'ZWT4JLmaBPGIyuIK4RRU3Q',
    :authentication       => 'plain',
    :enable_starttls_auto => true  }

  # config.action_mailer.delivery_method = :sendmail
  # config.action_mailer.sendmail_settings = {arguments: '-i'}

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.handlebars.precompile = true
  config.enable_rack_cache = true
  config.enable_mini_profiler = true

  # allows Cross-origin resource sharing (CORS) for API access in JavaScript (default to false for security).
  # See the initializer and https://github.com/cyu/rack-cors for configuration documentation.
  #
  # config.enable_rack_cors = false
  # config.rack_cors_origins = ['*']
  # config.rack_cors_resource = ['*', { :headers => :any, :methods => [:get, :post, :options] }]

  # Discourse strongly recommend you use a CDN.
  # For origin pull cdns all you need to do is register an account and configure
  # config.action_controller.asset_host = "http://YOUR_CDN_HERE"
end
