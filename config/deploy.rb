# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'it_follows'
set :repo_url, 'git@github.com:Fluvipers/it-follows.git'

set :pty, true
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('public/assets', 'public/system', 'public/uploads', 'log')

set :deploy_to, '/var/www/it_follows/'
set :user, "deploy"
set :use_sudo, false 
set :ssh_options, { forward_agent: true }
set :rvm_type, :user
set :rvm_ruby_version, '2.2.3  @it_follows'

namespace :deploy do

   desc 'Restart application'
   after :publishing, :restart do
     on roles(:app), in: :sequence, wait: 5 do
       within release_path do
         with rails_env: fetch(:rails_env) do
           execute "for pid in $(ps ax | grep unicorn | grep -v grep | awk '{print $1}'); do kill -9 $pid; done;"
           execute :bundle, "exec unicorn_rails -c config/unicorn.rb -D"
         end
       end
     end
   end

   desc "Clears Rails cache"
   task :clear_cache => [:set_rails_env] do
     on roles(:web), in: :groups, limit: 3, wait: 10 do
       within release_path do
         with rails_env: fetch(:rails_env) do
           execute :rake, 'tmp:clear'
         end
       end
     end
   end

   after :restart, :clear_cache
end
