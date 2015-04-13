#! /usr/bin/ruby
PRETEND=false

## !! Be careful to use this function. It may overwrite all of contents."
def deploy(host,env="test",first=false)
  if ! File.exists? "app" then
    puts "Here seems not to be in Rails app. Abort."
    return
  end
  path = "./"
  puts "Sending files to #{host}.."
  n = PRETEND ? "n" : ""
  puts `rsync -avz#{n} --delete --exclude "tmp" --exclude "log" --exclude ".git" #{path} #{host}:/opt/#{host}/`

  return if PRETEND

  if first then
    puts "Initializing bundle and database.."
    `ssh #{host} "cd /opt/#{host} && bundle install"`
    `ssh #{host} "cd /opt/#{host} && bundle exec rake db:create RAILS_ENV=#{env}"`
  end

  puts "Compiling assets.."
  `ssh #{host} "cd /opt/#{host} && bundle exec rake assets:precompile RAILS_ENV=#{env}"`
  puts "Migrating database.."
  `ssh #{host} "cd /opt/#{host} && bundle exec rake db:migrate RAILS_ENV=#{env}"`
  puts "Adjusting permissions.."
  `ssh #{host} "cd /opt/#{host} && chown -R nobody:nobody *"`
  `ssh #{host} "cd /opt/#{host} && chmod +r public/assets/*"`

  puts "Restarting web server.."
  `ssh #{host} "service httpd restart"`
end

env = ARGV[0] || ""
init = ARGV[1] == "init"
puts "Running with RAILS_ENV=#{env}"
if env == "test"
  deploy("chat.t.lmlab.net",env,init)
elsif env == "production"
  deploy("chat.lmlab.net",env,init)
else
  puts "USAGE: ./lib/tasks/deploy.rb (test|production) [init]";
end
