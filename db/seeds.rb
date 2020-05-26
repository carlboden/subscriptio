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



SubscriptioPlan.create!(name: "Free", price: 0.00)
SubscriptioPlan.create!(name: "Premium", price: 10.00)

feature1 = Feature.create!(name: "RH")
feature2 = Feature.create!(name: "sales")
feature3 = Feature.create!(name: "compta")

s1 = Software.create!(name:"adobe", url:"www.adobe.com", category: "image", demo_url: "www.demo.com")
s2 = Software.create!(name:"sage", url:"www.sage.com", category: "RH", demo_url: "www.demo.com")
s3 = Software.create!(name:"skello", url:"www.skello.com", category: "RH", demo_url: "www.demo.com")







