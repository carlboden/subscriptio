# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.destroy_all
Company.destroy_all
SubscriptioPlan.destroy_all

puts "Destroy softwares...."
SoftwarePlan.destroy_all
Software.destroy_all

puts "create softwares...."
Software.create!(name:"sage", url:"www.sage.com", category:"RH", demo_url: "www.demo.com")

puts "create subscriptio plans...."

SubscriptioPlan.create!(name: "Free", price: 0.00)
SubscriptioPlan.create!(name: "Premium", price: 10.00)









