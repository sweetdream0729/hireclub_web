require "rails_helper"

RSpec.feature "Company", :type => :feature do
  
  scenario "User should be able visit companies index page " do
  	company1 = FactoryGirl.create(:company)
  	company2 = FactoryGirl.create(:company)
  	company3 = FactoryGirl.create(:company)
  	visit(companies_path)
  	expect(page).to have_content company1.name
	  expect(page).to have_content company2.name
  	expect(page).to have_content company3.name
  end

  scenario "User should be able tovisit company show page " do
  	company1 = FactoryGirl.create(:company)

  	#visiting job using job url
  	visit(company_path(company1.id))
  	expect(page).to have_content company1.name
  	expect(page).to have_content company1.tagline

  	#visiting job by clicking on job link on jobs index
  	visit(companies_path)
  	click_link(company1.name)
  	expect(page).to have_content company1.name
    expect(page).to have_content company1.tagline
  	
  end
end