DEFAULT_INSECURE_PASSWORD = 'password'

User.create({
                first_name: 'Alejandro',
                last_name: 'Cárdenas',
                profile_name: 'acib708',
                email: 'acib708@gmail.com',
                password: DEFAULT_INSECURE_PASSWORD,
                password_confirmation: DEFAULT_INSECURE_PASSWORD
            })

User.create({
                first_name: 'Mike',
                last_name: 'The Frog',
                profile_name: 'mikethefrog',
                email: 'mike@teamtreehouse.com',
                password: DEFAULT_INSECURE_PASSWORD,
                password_confirmation: DEFAULT_INSECURE_PASSWORD
            })

User.create({
                first_name: 'Jason',
                last_name: 'Seifer',
                profile_name: 'jason',
                email: 'jason@teamtreehouse.com',
                password: DEFAULT_INSECURE_PASSWORD,
                password_confirmation: DEFAULT_INSECURE_PASSWORD
            })

User.create({
                first_name: 'Jim',
                last_name: 'Hoskins',
                profile_name: 'jim',
                email: 'jim@teamtreehouse.com',
                password: DEFAULT_INSECURE_PASSWORD,
                password_confirmation: DEFAULT_INSECURE_PASSWORD
            })

User.create({
                first_name: 'Nick',
                last_name: 'Pettit',
                profile_name: 'nick',
                email: 'nick@teamtreehouse.com',
                password: DEFAULT_INSECURE_PASSWORD,
                password_confirmation: DEFAULT_INSECURE_PASSWORD
            })

User.create({
                first_name: 'Ryan',
                last_name: 'Carson',
                profile_name: 'ryan',
                email: 'ryan@teamtreehouse.com',
                password: DEFAULT_INSECURE_PASSWORD,
                password_confirmation: DEFAULT_INSECURE_PASSWORD
            })

acib  = User.find_by_email('acib708@gmail.com')
jason = User.find_by_email('jason@teamtreehouse.com')
jim   = User.find_by_email('jim@teamtreehouse.com')
nick  = User.find_by_email('nick@teamtreehouse.com')
mike  = User.find_by_email('mike@teamtreehouse.com')
ryan  = User.find_by_email('ryan@teamtreehouse.com')

seed_user = acib

seed_user.statuses.create(content: 'Hello, world!')
jim.statuses.create(content: "Hi, I'm Jim")
nick.statuses.create(content: 'Hello from the internet!')
mike.statuses.create(content: 'I want to learn html javapress')
ryan.statuses.create(content: 'Treebook is awesome!')
jason.statuses.create(content: 'This is Jason (:')

UserFriendship.request(seed_user, jim).accept!
UserFriendship.request(seed_user, jason).accept!
UserFriendship.request(seed_user, nick).block!
UserFriendship.request(seed_user, mike)
UserFriendship.request(ryan, seed_user)
