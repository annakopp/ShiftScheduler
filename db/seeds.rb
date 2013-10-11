# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
company = Company.create({name: "Awesome Stuff", admin_id: 1})
admin = User.create({company_id: 1,
                    email: "admin@example.com",
                    first_name: "Admin",
                    last_name: "Adminerson",
                    manager_id: 1,
                    password: "password",
                    user_type: "admin",
                    account_status: "active"})

employees = User.create([
                  {company_id: 1,
                   email: "anna@example.com",
                   first_name: "Anna",
                   last_name: "Kopp",
                   manager_id: 1,
                   password: "password",
                   user_type: "employee",
                   account_status: "active"},
                 {company_id: 1,
                  email: "douglas@example.com",
                  first_name: "Douglas",
                  last_name: "Spangler",
                  manager_id: 1,
                  password: "password",
                  user_type: "employee",
                  account_status: "active"},
                {company_id: 1,
                 email: "stefanie@example.com",
                 first_name: "Stefanie",
                 last_name: "Gray",
                 manager_id: 1,
                 password: "password",
                 user_type: "employee",
                 account_status: "active"},
                 {company_id: 1,
                  email: "ray@example.com",
                  first_name: "Ray",
                  last_name: "Cat",
                  manager_id: 1,
                  password: "password",
                  user_type: "employee",
                  account_status: "active"},
                  {company_id: 1,
                   email: "daniel@example.com",
                   first_name: "Daniel",
                   last_name: "Kopp",
                   manager_id: 1,
                   password: "password",
                   user_type: "employee",
                   account_status: "active"}

                   ])
