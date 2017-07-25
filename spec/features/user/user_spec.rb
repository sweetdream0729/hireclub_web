require "rails_helper"

RSpec.feature "User", :type => :feature do
	scenario "visiting user profile" do
		user1 = FactoryGirl.create(:user)

		#creating 5 user skills
		user_skills = []
		for i in 1..5 do
			skill = FactoryGirl.create(:skill)
			FactoryGirl.create(:user_skill,user: user1,skill: skill)
		end

		#creating 3 milestones
		for i in 1..3 do
			FactoryGirl.create(:milestone,user: user1)
		end

		#creating 3 projects
		for i in 1..3 do
			FactoryGirl.create(:project,user: user1)
		end

		#profile visit by guests
		visit(user_path(user1.id))
		user_skills = user1.skills.pluck(:name)
		user_projects = user1.projects.pluck(:name)
		user_milestones = user1.milestones.pluck(:name)

		expect(page).to have_content user1.display_name

		#All 5 skill name should be present
		expect(page).to have_content user_skills[0]
		expect(page).to have_content user_skills[1]
		expect(page).to have_content user_skills[2]
		expect(page).to have_content user_skills[3]
		expect(page).to have_content user_skills[4]

		#All projects should be present 
		expect(page).to have_content user_projects[0]
		expect(page).to have_content user_projects[1]
		expect(page).to have_content user_projects[2]

		#All user milestone should be present
		expect(page).to have_content user_milestones[0]
		expect(page).to have_content user_milestones[1]
		expect(page).to have_content user_milestones[2]

		#no edit link
		expect(page).to have_no_link('', href: '/settings')

		#profile visit by same user
		signin(user1.email, user1.password)
		visit(user_path(user1.id))

		#should have edit link
		expect(page).to have_link('', href: '/settings')
	end

end