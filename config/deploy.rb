set :application, 'temp-alert'
set :repo_url, 'git@github.com:nick-desteffen/temp-alert.git'
set :deploy_to, '/var/www/apps/temp-alert'
set :scm, :git
set :format, :pretty
set :log_level, :info
set :pty, true
set :linked_files, %w{config/settings.yml}
set :keep_releases, 5

I18n.enforce_available_locales = false

namespace :deploy do
  after :finishing, 'deploy:cleanup'
end
