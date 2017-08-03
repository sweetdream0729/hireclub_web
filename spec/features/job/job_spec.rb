require "rails_helper"

RSpec.feature "Jobs", :type => :feature do
  
  scenario "User should visit jobs index page " do
  	job1 = FactoryGirl.create(:job)
  	job2 = FactoryGirl.create(:job)
  	job3 = FactoryGirl.create(:job)
  	visit(jobs_path)
  	expect(page).to have_content job1.name
	  expect(page).to have_content job2.name
  	expect(page).to have_content job3.name
  end

  scenario "User should visit jobs show page " do
  	job1 = FactoryGirl.create(:job)

  	#visiting job using job url
  	visit(job_path(job1.id))
  	expect(page).to have_content job1.name
  	expect(page).to have_content job1.description

  	#visitng job by clicking on job link on jobs index
  	visit(jobs_path)
  	click_link(job1.name)
  	expect(page).to have_content job1.name
  	expect(page).to have_content job1.description
  	
  end

  scenario "old job show url should redirect to new when slug is changed" do
    job = FactoryGirl.create(:job)
    old_url = job_path(job)
    job.slug = "newslug"
    job.save
    visit(old_url)
    expect(current_path).to eq job_path(job)
  end

  scenario "old job edit url should redirect to new url" do
    admin = FactoryGirl.create(:admin)
    signin(admin.email, admin.password)
    job = FactoryGirl.create(:job)
    old_url = edit_job_path(job)
    job.slug = "newslug"
    job.save
    visit(old_url)
    expect(current_path).to eq edit_job_path(job)
  end
end