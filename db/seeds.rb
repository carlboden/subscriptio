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
SoftwareFeature.destroy_all
Feature.destroy_all
SoftwarePlan.destroy_all
Software.destroy_all

puts "create softwares...."
s1 = Software.create!(name:"sage", url:"www.sage.com", category:"RH", demo_url: "www.demo.com")
s2 = Software.create!(name:"adobe", url:"www.adobe.com", category:"images", demo_url: "www.demo.com")
s3 = Software.create!(name:"skello", url:"www.skello.io", category:"plannings", demo_url: "www.demo.com")

puts "create features"

Feature.create!(name:"planning")
Feature.create!(name:"VAT declaration")
Feature.create!(name:"presentation maker")
Feature.create!(name:"compta")

puts "create Software Plans for softwares"

sp1 = SoftwarePlan.new(name:"free", official_price: 0)
sp1.software = s1
sp1.save

sp2 = SoftwarePlan.new(name:"premium", official_price: 56)
sp2.software = s1
sp2.save

sp3 = SoftwarePlan.new(name:"gold", official_price: 79)
sp3.software = s2
sp3.save

sp4 = SoftwarePlan.new(name:"beginner", official_price: 9)
sp4.software = s2
sp4.save

sp5 = SoftwarePlan.new(name:"complete", official_price: 110)
sp5.software = s3
sp5.save

sp6 = SoftwarePlan.new(name:"advanced", official_price: 65)
sp6.software = s3
sp6.save


puts "create subscriptio plans...."

SubscriptioPlan.create!(name: "Free", price: 0.00)
SubscriptioPlan.create!(name: "Premium", price: 10.00)









