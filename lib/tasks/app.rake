namespace :app do
  namespace :db do
    desc 'Dump production database to localhost'

    task production: :environment do
      Bundler.with_original_env do
        sh 'scalingo --app mmibordeaux-select --addon postgresql backups-create'
        sh 'scalingo --app mmibordeaux-select --addon postgresql backups-download'
        dump_gz = Dir.glob('*.tar.gz').first
        sh "tar -xvzf #{dump_gz}"
        sh "rm #{dump_gz}"
        dump_sql = Dir.glob('*.pgsql').first
        sh "mv #{dump_sql} db/latest.pgsql"
        sh "DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rake db:drop"
        sh "bundle exec rake db:create"
        sh "pg_restore  --verbose --clean --no-acl --no-owner --if-exists -h localhost -U postgres -d select_development db/latest.pgsql"
        sh "bundle exec rake db:migrate"
      end
    end
  end

  desc 'Import des données JSON'
  task import: [:environment] do
    if ENV.has_key?('data')
      Importers::Json.new ENV['data']
    else
      puts "Utiliser `rake app:import data=tmp/data.json`"
    end
  end
end
