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
Feature.destroy_all
Software.destroy_all

SubscriptioPlan.create!(name: "Free", price: 0.00)
SubscriptioPlan.create!(name: "Premium", price: 10.00)

feature1 = Feature.create!(name: "RH")
feature2 = Feature.create!(name: "sales")
feature3 = Feature.create!(name: "compta")

s1 = Software.create!(name:"adobe", url:"www.adobe.com", category: "image", demo_url: "www.demo.com")
s2 = Software.create!(name:"sage", url:"www.sage.com", category: "RH", demo_url: "www.demo.com")
s3 = Software.create!(name:"skello", url:"www.skello.com", category: "RH", demo_url: "www.demo.com")

sp1 = SoftwarePlan.create!(name:"premium", official_price: 42)
sp2 = SoftwarePlan.create!(name:"gold", official_price: 89)
sp3 = SoftwarePlan.create!(name:"free", official_price: 0)
sp4 = SoftwarePlan.create!(name:"platine", official_price: 102)

sp1.software = s1
sp2.sofware = s1
sp3.software= s2
sp4.software = s3


sf1 = SoftwareFeature.create!
sf1.feature = feature1
sf1.software_plan = sp2

sf2 = SoftwareFeature.create!
sf2.feature = feature2
sf1.software_plan = sp2

sf3 = SoftwareFeature.create!
sf3.feature = feature3
sf3.software_plan = sp1

sf4 = SoftwareFeature.create!
sf4.feature = feature1
sf1.software_plan = sp3

sf5 = SoftwareFeature.create!
sf5.feature = feature3
sf1.software_plan = sp4







