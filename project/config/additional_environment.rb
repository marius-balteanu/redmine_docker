if Rails.env.development?
  # Setting up logging to STDOUT
  config.logger = Logger.new(STDOUT)
  logger_level  = ENV.fetch('LOG_LEVEL', 'DEBUG').upcase

  config.logger.level = Logger.const_get(logger_level)

  # Export the database structure as ruby DSL
  config.active_record.schema_format = :ruby

  # Whitelisted IP for the web console
  # config.web_console.whitelisted_ips = ['172.16.0.0/12', '192.168.0.0/16', '10.0.2.2']

  # Whitelist docker IP for Better Errors
  BetterErrors::Middleware.allow_ip! '172.0.0.0/8'
end

# Show the entire stack trace on error (a real life saver!)
Rails.backtrace_cleaner.remove_silencers!
