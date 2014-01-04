set :stage, :production
set :rails_env, :production

server '173.255.245.253', user: 'nickd', roles: %w{web app db}
