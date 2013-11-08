# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
company = Company.create({name: Faker::Company.name, admin_id: 1})

admin = User.create({company_id: 1,
                    email: "admin@example.com",
                    first_name: Faker::Name.first_name,
                    last_name: Faker::Name.last_name,
                    manager_id: 1,
                    password: "password",
                    password_confirmation: "password",
                    user_type: "admin",
                    account_status: "active"})
                    
employee = User.create({company_id: 1,
                    email: "employee@example.com",
                    first_name: Faker::Name.first_name,
                    last_name: Faker::Name.last_name,
                    manager_id: 1,
                    password: "password",
                    password_confirmation: "password",
                    user_type: "employee",
                    account_status: "active"})


12.times do 
  User.create({company_id: 1,
               email: Faker::Internet::email,
               first_name: Faker::Name.first_name,
               last_name: Faker::Name.last_name,
               manager_id: 1,
               password: "password",
               password_confirmation: "password",
               user_type: "employee",
               account_status: "active"
              })
end


60.times do 
  random_date = Array(DateTime.now..DateTime.new(2014,1,1)).sample
  
  Shift.create({manager_id: 1, 
                name: Faker::Company.bs, 
                slots: 0, 
                start_date: random_date, 
                end_date: random_date + rand(0.2..0.3), 
                max_slots: rand(1..5)
                })
end