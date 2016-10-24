require 'mina/git'
​
set :user, 'deploy'
set :repository, 'git@github.com:jchai002/wangxiaohong-art.git'
set :project_name, "wangxiaohong.art"
set :port, '22 -A'


set :domain, '35.160.96.40'
set :deploy_to, "/var/www/production.#{project_name}"
set :branch, 'master'
set :database, 'tla_production'
set :shared_paths, ['craft/storage','.env','.env.example']
​
task :setup => :environment do
  # create shared folders
  queue! %[mkdir -p "#{deploy_to}/shared/craft/config"]
  queue! %[mkdir -p "#{deploy_to}/shared/craft/storage"]
  queue! %[mkdir -p "#{deploy_to}/shared/public/assets/images"]

  # change project directory user group to web
  queue! %[chgrp -R web "#{deploy_to}"]
  # set project directory user permissions
  queue! %[chmod -R 774 "#{deploy_to}"]
  # make all new files and directories created under project directory inherit the same permissions
  queue! %[chmod g+s "#{deploy_to}"]
end
​
desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'deploy:cleanup'
  end
end

# db relate tasks
desc "backup remote database, then sync local db to remote"
task :dbsync => :environment do
  invoke :db_backup
  invoke :db_transfer
  invoke :db_overwrite
  invoke :clean_up
end

task :db_backup do
  queue! %[mysqldump -u root -p#{ENV['pw']} "#{database}" > "#{deploy_to}/db_backup/backup_#{Time.now.to_s.gsub(/\W/,'_')}.sql"]
end

task :db_transfer do
  system "/Applications/MAMP/Library/bin/mysqldump -u root -proot tla > dump.sql
          scp dump.sql deploy@#{domain}:#{deploy_to}/shared"
end

task :db_overwrite do
  queue! %[cd "#{deploy_to}/shared"]
  queue! %[mysql -u root -p#{ENV['pw']} hong < dump.sql]
end

task :clean_up do
  queue! %[cd "#{deploy_to}/shared"]
  queue! %[rm dump.sql]
  system "rm dump.sql"
end

task :db_dump do
  queue! %[mysqldump -u root -p#{ENV['pw']} "#{database}" > #{deploy_to}/dump.sql]
end

task :db_pull do
  system "scp deploy@#{domain}:#{deploy_to}/dump.sql dump.sql"
  system "#{ENV['command'] || '/Applications/MAMP/Library/bin/mysql'} -u root -proot tla < dump.sql"
end

task :upload_images do
  system "scp -r /Applications/MAMP/htdocs/TLA-009-TLA-Teaching-and-Learning-Practices/public/assets/images deploy@#{domain}:#{deploy_to}/shared/public/assets/"
  queue! %[chgrp -R web #{deploy_to}/shared/public/assets/images]
  queue! %[chmod -R 774 "#{deploy_to}/shared/public/assets/images"]
end

task :download_images do
  system "scp -r deploy@#{domain}:#{deploy_to}/shared/public/assets/images /Applications/MAMP/htdocs/TLA-009-TLA-Teaching-and-Learning-Practices/public/assets/"
end

task :download_artifacts do
  system "scp -r deploy@#{domain}:#{deploy_to}/shared/public/assets/artifacts /Applications/MAMP/htdocs/TLA-009-TLA-Teaching-and-Learning-Practices/public/assets/"
end

task :download_assets do
  invoke :download_images
  invoke :download_artifacts
end

task :db_dump_transfer do
  queue! %[sh #{deploy_to}/scripts/db_dump_transfer.sh]
end

task :db_inject do
  queue! %[sh #{deploy_to}/scripts/db_inject.sh]
end

task :assets_staging_to_production do
    queue! %[sh #{deploy_to}/scripts/assets_staging_to_production.sh]
end
