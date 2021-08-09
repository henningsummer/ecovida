namespace :database do
  PRODUCTION_GIT      = 'https://git.heroku.com/certificacaoecovida.git'.freeze
  STAGING_GIT         = 'https://git.heroku.com/staging-certificacaoecovida.git'.freeze
  STAGING_APP_NAME    = 'staging-certificacaoecovida'.freeze
  PRODUCTION_APP_NAME = 'certificacaoecovida'.freeze

  desc 'Install Heroku toolbelt for Ubuntu'
  task install_toolbelt_for_ubuntu: :environment do
    puts 'Getting Heroku Toolbelt'
    system 'wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh'
    puts 'Installation Successfully'
    puts 'Enter your e-mail and password from heroku'
    system 'heroku login'
  end

  desc 'Configure Local remotes to access the database'
  task configure_remotes: :environment do
    puts 'Adding new remotes.'
    system "git remote add production #{PRODUCTION_GIT}"
    puts "Added remote 'production' with git: #{PRODUCTION_GIT}"
    system "git remote add staging #{STAGING_GIT}"
    puts "Added remote 'staging' with git: #{STAGING_GIT}"
    puts 'Remotes added successfully'
  end

  desc 'Copy de Production database to Staging'
  task production_to_staging: :environment do
    puts '1 - Use a Old Saved Backup. 2 - Capture a new backup'
    choice = STDIN.gets.chomp

    if choice == '2'
      system "heroku pg:backups capture --app #{PRODUCTION_APP_NAME}"
    end

    puts 'Listing de backups'

    system "heroku pg:backups --app #{PRODUCTION_APP_NAME}"

    puts 'Please type the id of dump that you want to send to staging( Example: b001 )'

    b_id = STDIN.gets.chomp

    c = "heroku pg:backups restore #{PRODUCTION_APP_NAME}::#{b_id} DATABASE_URL --app #{STAGING_APP_NAME}"

    system(c)
  end

  desc 'Download dump from production'
  task download_production_dump: :environment do
    puts 'Capturing and downloading a dump'
    system "heroku pg:backups capture --app #{PRODUCTION_APP_NAME}"

    filename = "dumps/dump_#{Dir['dumps/**/*'].length + 1}_prod.dump"

    system "curl -o #{filename} `heroku pg:backups public-url --app #{PRODUCTION_APP_NAME}`"
    puts "Download complete. Use 'rake database:upload_dump_to_local_database' to upload."
  end

  desc 'Download dump from staging'
  task download_staging_dump: :environment do
    puts 'Capturing and downloading a dump'
    system "heroku pg:backups capture --app #{STAGING_APP_NAME}"

    filename = "dumps/dump_#{Dir['dumps/**/*'].length + 1}_stag.dump"

    system "curl -o #{filename} `heroku pg:backups public-url --app #{STAGING_APP_NAME}`"
    puts "Download complete. Use 'rake database:upload_dump_to_local_database' to upload."
  end

  desc 'Select a dump to local file'
  task :upload_dump_to_local_database do
    puts 'Listing all dumps in dumps folder'
    system 'ls dumps/'

    puts 'Type the dump name file that ou want to upload into local database (Type without .dump)'
    dump = STDIN.gets.chomp

    database_config = YAML.load_file('config/database.yml')
    host = eval(database_config['default']['host'].split[1]) || 'localhost'
    user = eval(database_config['development']['username'].split[1])
    password = eval(database_config['development']['password'].split[1])
    database = database_config['development']['database']

    puts 'Reseting database!'
    system('rake db:drop db:create')

    puts 'Restoring dump'
    cmd = 'pg_restore --verbose --clean --no-acl --no-owner -h'
    system "PGPASSWORD=#{password} #{cmd} #{host} -U #{user} -d #{database} dumps/#{dump}.dump"
  end
end
