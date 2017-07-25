require "rails_helper"

RSpec.feature "Company", :type => :feature do
  
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