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

  scenario "User should be able to visit company show page " do
  	company1 = FactoryGirl.create(:company)

  	#visiting company using company url
  	visit(company_path(company1.id))
  	expect(page).to have_content company1.name
  	expect(page).to have_content company1.tagline

  	#visiting company by clicking on company link on companies index
  	visit(companies_path)
  	click_link(company1.name)
  	expect(page).to have_content company1.name
    expect(page).to have_content company1.tagline
  end
  	
  scenario "old company show url should redirect to new when slug is changed" do
    company = FactoryGirl.create(:company)
    old_url = company_path(company)
    company.slug = "newslug"
    company.save
    visit(old_url)
    expect(current_path).to eq company_path(company)
  end

 scenario "old company edit url should redirect to new url" do
    admin = FactoryGirl.create(:admin)
    signin(admin.email, admin.password)
    company = FactoryGirl.create(:company)
    old_url = edit_company_path(company)
    company.slug = "newslug"
    company.save
    visit(old_url)
    expect(current_path).to eq edit_company_path(company)
  end
end