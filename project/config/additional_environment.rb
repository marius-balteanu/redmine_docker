if Rails.env.development?
  config.logger = Logger.new(STDOUT)
  logger_level  = ENV.fetch('LOG_LEVEL', 'DEBUG').upcase

  config.logger.level = Logger.const_get(logger_level)

  config.active_record.schema_format = :ruby

  config.web_console.whitelisted_ips = ['172.16.0.0/12', '192.168.0.0/16', '10.0.2.2']
end

# Show the entire stack trace on error (a real life saver!)
Rails.backtrace_cleaner.remove_silencers!
