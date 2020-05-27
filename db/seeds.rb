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


f1 = Feature.create!(name:"planning")
f2 = Feature.create!(name:"VAT declaration")
f3 = Feature.create!(name:"manage financials")
f4 = Feature.create!(name:"optimize sales")
f5 = Feature.create!(name:"analyze performance")
f6 = Feature.create!(name:"remote access")
f7 = Feature.create!(name:"advanced security")
f8 = Feature.create!(name:"compliance")
f9 = Feature.create!(name:"Pay bills in an instant")
f10 = Feature.create!(name:"Job costing")
f11 = Feature.create!(name:"Advanced budgeting tools")
f12 = Feature.create!(name:"Effortless invoicing of customers")
f13 = Feature.create!(name:"Secure remote access for employees and accountants​")
f14 = Feature.create!(name:"Managing multiple companies")



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


puts "create SoftwareFeatures  for softwareplans"

sf1 = SoftwareFeature.new
sf1.feature = f1
sf1.software_plan = sp5
sf1.save

sf2 = SoftwareFeature.new
sf2.feature = f14
sf2.software_plan = sp5
sf2.save

sf3 = SoftwareFeature.new
sf3.feature = f5
sf3.software_plan = sp5
sf3.save

puts '....'

sf4 = SoftwareFeature.new
sf4.feature = f1
sf4.software_plan = sp6
sf4.save

sf5 = SoftwareFeature.new
sf5.feature = f14
sf5.software_plan = sp6
sf5.save

sf6 = SoftwareFeature.new
sf6.feature = f5
sf6.software_plan = sp6
sf6.save

sf23 = SoftwareFeature.new
sf23.feature = f3
sf23.software_plan = sp6
sf23.save

sf24 = SoftwareFeature.new
sf24.feature = f7
sf24.software_plan = sp6
sf24.save

sf25 = SoftwareFeature.new
sf25.feature = f12
sf25.software_plan = sp6
sf25.save

puts "..."

sf7 = SoftwareFeature.new
sf7.feature = f2
sf7.software_plan = sp4
sf7.save

sf8 = SoftwareFeature.new
sf8.feature = f4
sf8.software_plan = sp4
sf8.save

sf9 = SoftwareFeature.new
sf9.feature = f10
sf9.software_plan = sp4
sf9.save


puts "..."

sf10 = SoftwareFeature.new
sf10.feature = f2
sf10.software_plan = sp3
sf10.save

sf27 = SoftwareFeature.new
sf27.feature = f4
sf27.software_plan = sp3
sf27.save

sf28 = SoftwareFeature.new
sf28.feature = f10
sf28.software_plan = sp3
sf28.save


sf11 = SoftwareFeature.new
sf11.feature = f3
sf11.software_plan = sp3
sf11.save

sf12 = SoftwareFeature.new
sf12.feature = f5
sf12.software_plan = sp3
sf12.save

sf13 = SoftwareFeature.new
sf13.feature = f13
sf13.software_plan = sp3
sf13.save


puts "..."

sf14 = SoftwareFeature.new
sf14.feature = f1
sf14.software_plan = sp2
sf14.save

sf15 = SoftwareFeature.new
sf15.feature = f6
sf15.software_plan = sp2
sf15.save

sf16 = SoftwareFeature.new
sf16.feature = f9
sf16.software_plan = sp2
sf16.save


sf17 = SoftwareFeature.new
sf17.feature = f1
sf17.software_plan = sp1
sf17.save

sf18 = SoftwareFeature.new
sf18.feature = f6
sf18.software_plan = sp1
sf18.save

sf19 = SoftwareFeature.new
sf19.feature = f9
sf19.software_plan = sp1
sf19.save

sf20 = SoftwareFeature.new
sf20.feature = f2
sf20.software_plan = sp2
sf20.save

sf21 = SoftwareFeature.new
sf21.feature = f13
sf21.software_plan = sp2
sf21.save

sf22 = SoftwareFeature.new
sf22.feature = f8
sf22.software_plan = sp2
sf22.save


puts "create subscriptio plans...."

SubscriptioPlan.create!(name: "Free", price: 0.00)
SubscriptioPlan.create!(name: "Premium", price: 10.00)









