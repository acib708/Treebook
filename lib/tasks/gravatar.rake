desc "Imports users' gravatar pictures to Treebook"

task :import_avatars => :environment do
  puts 'Importing gravatars...'
  User.get_gravatars
  puts 'Avatars updated.'
end