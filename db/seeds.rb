require "open-uri"
require 'faker'
require 'mini_magick'
require 'net/http'

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

puts "create subscriptio plans...."
SubscriptioPlan.create!(name: "Free", price: 0.00, description: "Free plan")
SubscriptioPlan.create!(name: "Premium Plan", price: 10.00, description: "Premium plan")
puts 'Finished!'






scrapped_data = {}

urls = [
  ["https://www.appvizer.co.uk/customer/client-relationship-mgt/sales-cloud", "https://www.capterra.com/p/191340/Salesforce-Billing/"],
  ["https://www.appvizer.co.uk/customer/client-relationship-mgt/teamleader", "https://www.capterra.com/p/153190/Teamleader/"],
  ["https://www.appvizer.co.uk/customer/client-relationship-mgt/zoho-crm", "https://www.capterra.com/p/155928/Zoho-CRM/"],
  ["https://www.appvizer.co.uk/customer/client-relationship-mgt/you-dont-need-a-crm", "https://www.capterra.com/p/132752/You-Don-t-Need-a-CRM/"],
  ["https://www.appvizer.co.uk/customer/client-relationship-mgt/pipedrive", "https://www.capterra.com/p/173508/Pipedrive/"],
  ["https://www.appvizer.co.uk/customer/client-relationship-mgt/socialjscrm-en", "https://www.capterra.com/p/171298/SocialJsCRM/"],
  ["https://www.appvizer.co.uk/construction/real-estate-mgt/optima-crm", "https://www.capterra.com/p/176188/Optima-CRM/"],
  ["https://www.appvizer.co.uk/customer/client-relationship-mgt/sage-crm", "https://www.capterra.com/p/140059/Sage-One/"],
  ["https://www.appvizer.co.uk/customer/client-relationship-mgt/cirrus-shield", "https://www.capterra.com/p/167775/Cirrus-Shield-CRM/"],
  ["https://www.appvizer.co.uk/customer/client-relationship-mgt/simple-crm", "https://www.capterra.com/p/180601/Simple-CRM/"],
  ["https://www.appvizer.co.uk/customer/client-relationship-mgt/efficy-crm", "https://www.capterra.com/p/149894/Efficy-CRM/"],
  ["https://www.appvizer.co.uk/customer/client-relationship-mgt/revamp-crm", "https://www.capterra.com/p/148028/Revamp-CRM/"],

  ["https://www.appvizer.co.uk/accounting-finance/accounting/quickbooks", "https://www.capterra.com/p/46497/QuickBooks/"],
  ["https://www.appvizer.co.uk/accounting-finance/accounting/azopio", "https://www.capterra.com/p/160586/Azopio/"],
  ["https://www.appvizer.co.uk/accounting-finance/accounting/momenteo", "https://www.capterra.com/p/153758/Momenteo/"],
  ["https://www.appvizer.co.uk/accounting-finance/accounting/freshbooks", "https://www.capterra.com/p/142390/FreshBooks/"],
  ["https://www.appvizer.co.uk/accounting-finance/accounting/express-accounts", "https://www.capterra.com/p/189163/Express-Accounts/"],
  ["https://www.appvizer.co.uk/accounting-finance/accounting/sage-business-cloud-accounting", "https://www.capterra.com/p/140059/Sage-One/"],

  ["https://www.appvizer.co.uk/collaboration/collaborative-platform/wimi", "https://www.capterra.com/p/131830/Wimi/"],
  ["https://www.appvizer.co.uk/collaboration/collaborative-platform/interstis", "https://www.capterra.com/p/181650/interStis/"],
  ["https://www.appvizer.co.uk/collaboration/collaborative-platform/atolia", "https://www.capterra.com/p/172205/Atolia/"],
  ["https://www.appvizer.co.uk/operations/project-management/maestroprojet", "https://www.capterra.com/p/186016/maestroPROJET/"],
  ["https://www.appvizer.co.uk/operations/project-management/wrike", "https://www.capterra.com/p/76113/Wrike/"],
  ["https://www.appvizer.co.uk/operations/project-management/icescrum", "https://www.capterra.com/p/161518/iceScrum/"],
  ["https://www.appvizer.co.uk/operations/project-management/planzone", "https://www.capterra.com/p/564/Planzone/"],
  ["https://www.appvizer.co.uk/operations/project-management/beesbusy", "https://www.capterra.com/p/192503/Beesbusy/"],
  ["https://www.appvizer.co.uk/operations/project-management/taskeo", "https://www.capterra.com/p/205047/Taskeo/"],
  ["https://www.appvizer.co.uk/operations/project-management/agantty", "https://www.capterra.com/p/150248/Agantty/"],
  ["https://www.appvizer.co.uk/operations/project-management/z0-gravity", "https://www.capterra.com/p/181649/z0-Gravity/"],
  ["https://www.appvizer.co.uk/operations/project-management/bubble-plan", "https://www.capterra.com/p/161137/Bubbe-Plan/"],
  ["https://www.appvizer.co.uk/operations/project-management/planisware-orchestra", "https://www.capterra.com/p/146320/NQI-Orchestra/"],
  ["https://www.appvizer.co.uk/operations/project-management/mondaycom", "https://www.capterra.com/p/147657/monday-com/"],
  ["https://www.appvizer.co.uk/operations/project-management/gladys", "https://www.capterra.com/p/146442/Gladys/"],
  ["https://www.appvizer.co.uk/operations/project-management/socialjsproject-en", "https://www.capterra.com/p/171295/SocialJsProject/"],
  ["https://www.appvizer.co.uk/operations/project-management/optimy", "https://www.capterra.com/p/142236/Optimy/"],
  ["https://www.appvizer.co.uk/operations/project-management/workfront", "https://www.capterra.com/p/18561/Workfront-Project-Management-Software/"],
  ["https://www.appvizer.co.uk/operations/project-management/forecast-it", "https://www.capterra.com/p/138122/Forecast-it/"],
  ["https://www.appvizer.co.uk/operations/project-management/redmine", "https://www.capterra.com/p/201260/Redmine/"],
  ["https://www.appvizer.co.uk/operations/project-management/smartsheet", "https://www.capterra.com/p/79104/Smartsheet/"]

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
   sleep(5)
end



all_features = []

scrapped_data.each{|key, value| value[:detailed_features].each{|feature| all_features << feature}  }

all_features = all_features.uniq

all_features.each do |feature|
  Feature.create!(:name => feature)
end

scrapped_data.each do |key, value|

 url = value[:picture][0]

 tempfile = Down.download(url)

  # data = IO.copy_stream(data, "~/#{data.base_uri.to_s.split('/')[-1]}")

  p ""
  p "Software picture url: #{value[:picture][0]}"

  software = Software.new(:name => key, :url => value[:website][0], :category => value[:category][0])



  software.photo.attach(io: tempfile, filename: "image_#{key}_2.png", content_type: "image/png" )
  software.save!

=begin
  software = Software.new(:name => key, :url => value[:website][0], :category => value[:category][0])
  software.save
=end
  if value[:plan].length > 6
    value[:plan] = value[:plan][9..12]
  end

  i = 0
  j = 0
  h = 0
  while i < value[:plan].length
    if value[:price][i] == nil || value[:price][i].match(/\d+/) == nil

    else
      software_plan = SoftwarePlan.new(:name => value[:plan][i], :official_price => value[:price][i].match(/([+-]?([0-9]*[.])?[0-9]+)/)[0])
      software_plan.software = software
      software_plan.save!
      while j < value[:detailed_features].length
        p value[:have_detailed_features][h]
        if value[:have_detailed_features][h] == "check"
          p value[:detailed_features][j]
          feature = Feature.where(:name => value[:detailed_features][j])[0]
          p feature
          software_feature = SoftwareFeature.new()
          software_feature.software_plan = software_plan
          software_feature.feature = feature
          software_feature.save!
        end

        j += 1
        h += value[:plan].length
      end
    end


    j = 0

    i += 1
    h = i
  end
end

puts "finished"

