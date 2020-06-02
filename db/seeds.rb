require "open-uri"
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

SubscriptioPlan.create!(name: "Free", price: 0.00, description: "Free plan")
SubscriptioPlan.create!(name: "Premium Plan", price: 10.00, description: "Premium plan")

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



scrapped_data = {}

urls = [
  ["https://www.appvizer.co.uk/customer/client-relationship-mgt/revamp-crm", "https://www.capterra.com/p/148028/Revamp-CRM/"]
]


urls.each do |url|
  @doc = Nokogiri::HTML(RestClient.get(url[0]))
      
  # Extract the name of the company
  p "extracting company name"
  company = @doc.css("nav.ng-star-inserted a.ng-star-inserted")[2].content.gsub("\n", "").strip
  
  scrapped_data[company] = {picture: [], website: [], plan: [], category: [], price: [], period: [], features: [], detailed_features: [], have_detailed_features: []}
  # Extract the Plan type

  p "extracting plan"

  @doc.css("div.ng-star-inserted div").each do |link|
      # test << link.content
      scrapped_data[company][:plan] << link.content
  end

  # Extract the Price

  p "price"

  @doc.css(".ng-star-inserted span.price").each do |link|
      # test << link.content
      scrapped_data[company][:price] << link.content
  end

  # Extract the period (how the payment occur)

  p "period"

  @doc.css(".ng-star-inserted span.period").each do |link|
      # test << link.content
      scrapped_data[company][:period] << link.content
  end


  # Extract the main category of the software
  scrapped_data[company][:category] << @doc.css("nav.ng-star-inserted a.ng-star-inserted")[1].content.gsub("\n", "").strip


  # try to extract the features

  p "features"

  @doc.css("section.ng-star-inserted div.group.table-section").each do |link|
      # test << link.content
      scrapped_data[company][:features] << link.content
  end

  # try to extract the detailed features
  p ""
  p "detailed features"

  @doc.css("section.ng-star-inserted cim-edition-comparison-feature-row.ng-star-inserted div").each do |link|
      # test << link.content
      scrapped_data[company][:detailed_features] << link.content.gsub("\n", "").strip  
  end

  scrapped_data[company][:detailed_features] = scrapped_data[company][:detailed_features].reject { |value| value == ""}
  scrapped_data[company][:detailed_features] = scrapped_data[company][:detailed_features].map{|value| value.split("  ")[0]}


  @doc.xpath("/html/body/cim-root/main/cim-application-presentation/section[2]/cim-edition-comparison/section/cim-edition-comparison-feature-row/div/div/clr-icon/@shape").each do |link|
      # test << link.content
      scrapped_data[company][:have_detailed_features] << link.content
  end



  m = Mechanize.new
  m.user_agent_alias = 'Windows Mozilla'
  page = m.get(url[1])
  @doc = Nokogiri::HTML(page.body)



  scrapped_data[company][:picture] << @doc.css("img.Thumbnail__Image-sc-1xvq2zk-0.idhssu")[0]['src']

  scrapped_data[company][:website] << @doc.css("p.ProductSummary__CompanyDetailItem-uex5jn-5.fxpGcm")[1].content

  p "Pausing 15 seconds to avoid being kicked out of the websites"
  sleep(15) 
end



scrapped_data.each do |key, value|
  
  p "Software picture url: #{value[:picture][0]}"

  file = URI.open(value[:picture][0])
  software = Software.new(:name => key, :url => value[:website][0], :category => value[:category][0])
  p file

  software.photo.attach(io: file, filename: 'nes.png', content_type: 'image/png')

  software.save
  p value[:plan].length 

  i = 0
  while i < value[:plan].length
      if value[:price][i] == nil || value[:price][i].match(/\d+/) == nil
        software_plan = SoftwarePlan.new(:name => value[:plan][i], :official_price => nil)
        software_plan.software = software
        software_plan.save
      else
      software_plan = SoftwarePlan.new(:name => value[:plan][i], :official_price => value[:price][i].match(/([+-]?([0-9]*[.])?[0-9]+)/)[0])
      software_plan.software = software
      software_plan.save
    end
      i += 1
  end
end

puts "finished"

