set :application, 'poichecker'
set :repo_url, 'git@github.com:sozialhelden/poichecker.git'

# set :deploy_to, '/var/apps/matchy/staging'
# set :scm, :git
set :deploytag_time_format, "%Y.%m.%d-%H.%M.%S"

 set :format, :pretty
 set :log_level, :debug
 set :pty, true

set :linked_files, %w{config/database.yml config/osm.yml config/geocoder.yml config/secrets.yml config/initializers/airbrake.rb}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :rbenv_type, :system # :user or :system, depends on your rbenv setup
set :rbenv_ruby, '2.1.2'
set :rbenv_custom_path, '/opt/rbenv'

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      sudo "/etc/init.d/poichecker_#{fetch(:stage)} upgrade"
    end
  end

  desc 'Stopp application'
  task :stop do
    on roles(:app), in: :sequence, wait: 5 do
      sudo "/etc/init.d/poichecker_#{fetch(:stage)} stop"
    end
  end

  desc 'Start application'
  task :start do
    on roles(:app), in: :sequence, wait: 5 do
      sudo "/etc/init.d/poichecker_#{fetch(:stage)} start"
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end

namespace :unicorn do

  task :reload do
    on roles(:app), in: :sequence, wait: 5 do
      sudo "/etc/init.d/poichecker_#{fetch(:stage)} upgrade"
    end
  end


  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      sudo '/etc/init.d/poichecker_#{fetch(:stage)} restart'
    end
  end

end

after 'deploy', 'unicorn:reload' # ZERO DOWNTIME DEPLOYMENT

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'delayed_job:restart'
  end
end
