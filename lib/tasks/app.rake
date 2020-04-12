namespace :app do
  namespace :db do
    desc 'Dump production database to localhost'

    task production: :environment do
      Bundler.with_original_env do
        begin
          sh 'heroku pg:backups capture'
          sh 'curl -o db/latest.dump `heroku pg:backups public-url`'
          sh 'bundle exec rake db:drop'
          sh 'bundle exec rake db:create'
          sh "pg_restore --verbose --clean --no-acl --no-owner -h localhost -U postgres -d select_development db/latest.dump"
          sh 'bundle exec rake db:migrate'
          # sh 'rm db/latest.dump'
        rescue
          'There was warnings/errors while restoring'
        end
      end
    end
  end
end
