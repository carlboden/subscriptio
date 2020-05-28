require 'faker'
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


puts 'Creating 80 features...'
80.times do
  feature = Feature.new(
    name:    Faker::Company.bs,
  )
  feature.save!
end
puts 'Finished!'



puts 'Creating 30 fake softwares...'
30.times do
  software = Software.new(
    name:    Faker::Company.name,
    category: Faker::Company.industry,
    url:  Faker::Internet.url,
    demo_url: Faker::Internet.url
  )
  software.save!
end
puts 'Finished!'

puts 'Creating 80 fake softwares Plans...'
80.times do
  softwarePlan = SoftwarePlan.new(
    name:    Faker::Subscription.plan,
    official_price: Faker::Commerce.price,
  )
  #add a software to softwareplan
  softwareplan.software = Software.shuffle.take(1)
  softwarePlan.save!
end
puts 'Finished!'

puts 'Creating 80 fake softwares features...'
80.times do
  softwareFeature = SoftwareFeature.new
  #add a softwareplan to softwarefeatures
  softwareFeature.software_plan = SoftwarePlan.shuffle.take(1)
  sofwareFeature.feature = Feature.shuffle.take(1)
  softwareFeature.save!
end
puts 'Finished!'


puts "create subscriptio plans...."

SubscriptioPlan.create!(name: "Free", price: 0.00)
SubscriptioPlan.create!(name: "Premium", price: 10.00)









