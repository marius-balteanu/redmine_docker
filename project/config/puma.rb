rails_env = ENV.fetch('RAILS_ENV', 'development')

if rails_env == 'development'
  quiet true
  threads 1, 16
  worker_timeout 36000
  workers 1
elsif rails_env == 'test'
  quiet true
  threads 1, 16
  worker_timeout 36000
  workers 1
elsif rails_evn == 'production'
  quiet true
  threads 10, 16
  workers 4
else
  raise "Non standard value: `#{rails_env}` as value for `RAILS_ENV`"
end
