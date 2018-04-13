require 'mina/rails'
require 'mina/git'
require 'mina/multistage'
require 'mina/rvm'    # for rvm support. (https://rvm.io)
require 'mina/bundler'
require 'mina/puma'
# require 'mina_sidekiq/tasks'

set :application_name, 'gesanghua'

set :rvm_use_path, '/usr/local/rvm/scripts/rvm'
set :shared_dirs, ['public/uploads', 'log', 'tmp/pids', 'tmp/sockets', 'public/images', 'vendor/bundle', 'export']
set :shared_files, ['config/database.yml', 'config/puma.rb', 'config/settings.yml', 'config/secrets.yml', 'config/schedule.rb']

task :environment do
  invoke :'rvm:use', '2.4.1'
end

task :setup do
  command %[mkdir -p "#{fetch(:shared_path)}/log"]

  command %[mkdir -p "#{fetch(:shared_path)}/tmp/pids"]
  command %[mkdir -p "#{fetch(:shared_path)}/tmp/sockets"]
  command %[mkdir -p "#{fetch(:shared_path)}/vendor/bundle"]
  command %[mkdir -p "#{fetch(:shared_path)}/export"]

  # 在服务器项目目录的shared中创建config文件夹 下同
  command %[mkdir -p "#{fetch(:shared_path)}/config"]
  command %[mkdir -p "#{fetch(:shared_path)}/config/settings"]

  command %[mkdir -p "#{fetch(:shared_path)}/public/uploads"]
  command %[mkdir -p "#{fetch(:shared_path)}/public/images"]

  command %[touch "#{fetch(:shared_path)}/config/database.yml"]
  command %[touch "#{fetch(:shared_path)}/config/puma.rb"]
  command %[touch "#{fetch(:shared_path)}/config/settings.yml"]
  command %[touch "#{fetch(:shared_path)}/config/schedule.rb"]
  command %[touch "#{fetch(:shared_path)}/config/settings.local.yml"]
  command %[touch "#{fetch(:shared_path)}/config/secrets.yml"]

  command %[echo "-----> Be sure to edit '#{fetch(:shared_path)}/config/database.yml'."]
  command %[echo "-----> Be sure to edit '#{fetch(:shared_path)}/config/puma.rb'."]
  command %[echo "-----> Be sure to edit '#{fetch(:shared_path)}/config/settings.local.yml'."]
  command %[echo "-----> Be sure to edit '#{fetch(:shared_path)}/config/secrets.yml'."]
  command %[echo "-----> Be sure to edit '#{fetch(:shared_path)}/config/schedule.rb'."]
end

desc "Deploys the current version to the server."
task :deploy do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      invoke :'puma:restart'
      # invoke :'sidekiq:restart'
    end
  end

  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
  # run(:local){ say 'done' }
end

# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs
