require 'faker'
puts "Destroy user, company, subscriptioplan, ratings"
Rating.destroy_all
User.destroy_all
Company.destroy_all
SubscriptioPlan.destroy_all


puts "Destroy softwares Feature, Feature, Softwareplan, Software...."
SoftwareFeature.destroy_all
Feature.destroy_all
SoftwarePlan.destroy_all
Software.destroy_all
puts 'Finished!'


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
  softwarePlan.software= Software.all.shuffle.take(1)[0]
  softwarePlan.save!
end
puts 'Finished!'

puts 'Creating 80 fake softwares features...'
80.times do
  softwareFeature = SoftwareFeature.new
  #add a softwareplan to softwarefeatures
  softwareFeature.software_plan = SoftwarePlan.all.shuffle.take(1)[0]
  softwareFeature.feature = Feature.all.shuffle.take(1)[0]
  softwareFeature.save!
end
puts 'Finished!'


puts "create subscriptio plans...."
SubscriptioPlan.create!(name: "Free", price: 0.00)
SubscriptioPlan.create!(name: "Premium", price: 10.00)
puts 'Finished!'


puts "Create Companies ..."
company_sizes = ['Less than 5', 'Between 5 and 10', 'Between 10 and 49', 'Between 50 and 499', '500 and more']
turnovers = ['Less than €100k', 'Between €100k and €500k', 'Between €500k and €1 Million', 'Between €1 Million and €5 Million', 'Between €5 Million and €10 Million', 'Between €10 Million and €50 Million', 'More than €50 Million' ]
20.times do 
  company = Company.new(
  	name: Faker::Company.name,
  	address: "#{Faker::Address.street_address}, #{Faker::Address.city}",
  	country: "Belgium",
  	company_size: company_sizes.shuffle.take(1)[0],
  	turnover:  turnovers.shuffle.take(1)[0]
  	)
  company.subscriptio_plan = SubscriptioPlan.all.shuffle.take(1)[0]
  company.save!
end
puts 'Finished!'

puts "Create users"

functions = ["CEO", "CFO", "CTO", "CIO", "Purchasing Manager", "Other"]

5.times do 
	user = User.new(
	  email: Faker::Internet.email,
	  password: "123456",
	  first_name: Faker::Name.first_name,
	  last_name: Faker::Name.last_name,
	  phone_number: "+32 #{Faker::PhoneNumber.subscriber_number(length: 9)}",
	  function: functions.shuffle.take(1)[0],
	  company_admin: false,
	  admin: false,
	)
	user.company = Company.all.shuffle.take(1)[0]
	user.save!
end
puts 'Finished!'


puts "Create ratings"
80.times do
	rating = Rating.new(
		rating: [0, 1, 2, 3, 4, 5].shuffle.first,
		description: Faker::Hipster.paragraph
	)
	rating.user = User.all.shuffle.take(1)[0]
	rating.software_plan = SoftwarePlan.all.shuffle.first
	rating.save!
end

puts "finished"







