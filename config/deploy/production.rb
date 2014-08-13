# Settings for delayed job
set :delayed_job_server_role, :worker
set :delayed_job_args, "-n 1 -p poichecker_production --queue=geocode"

set :stage, :production
set :deploy_to, '/var/apps/poichecker/production'

set :branch, :production

# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
role :app,    %w{176.9.63.171}
role :web,    %w{176.9.63.171}
role :db,     %w{176.9.63.171}
role :worker, %w{176.9.63.171}

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a hash can be used to set
# extended properties on the server.
server '176.9.63.171', user: 'rails', roles: %w{web app}, my_property: :my_value

# you can set custom ssh options
# it's possible to pass any option but you need to keep in mind that net/ssh understand limited list of options
# you can see them in [net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start)
# set it globally
set :ssh_options, {
  keys: %w(~/.ssh/wheelmap_rsa),
  forward_agent: true,
  config: true,
  port: 22022
#    auth_methods: %w(password)
}
# and/or per server
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
# setting per server overrides global ssh_options

# fetch(:default_env).merge!(rails_env: :production)