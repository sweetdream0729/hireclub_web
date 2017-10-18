require 'rails_helper'

RSpec.describe Job, type: :model do
  let(:job) { FactoryGirl.build(:job) }
  let(:skill) { FactoryGirl.create(:skill) }
  let(:skill2) { FactoryGirl.create(:skill) }

  subject { job }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:company) }
    it { should belong_to(:role) }
    it { should belong_to(:location) }
    it { should have_many(:job_scores).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(6).is_at_most(50) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:company) }
    it { should validate_presence_of(:role) }
    it { should validate_presence_of(:location) }
    it { should validate_presence_of(:description) }

    it { should validate_presence_of(:pay_type) }
    it { should validate_inclusion_of(:pay_type).in_array(Job::PAY_TYPES) }

    it { should validate_presence_of(:min_pay) }
    it { should validate_numericality_of(:min_pay).is_greater_than_or_equal_to(0) }
    
    it { should validate_numericality_of(:max_pay) }
    
    #it { should validate_uniqueness_of(:slug).case_insensitive }
    
    it "should be valid only with approved skills" do
      job.skills = [skill.name, skill2.name]
      job.save

      expect(job).to be_valid

      job.skills = ["foo"]
      expect(job).not_to be_valid

      job.skills_list = "bar, dog"
      expect(job).not_to be_valid
    end
  end

  describe "link" do
    it "should add http if missing" do
      job.link = "instagram.com/username"
      expect(job.link).to eq("http://instagram.com/username")
    end

    it "should add http if missing ignoring subdomains" do
      job.link = "www.instagram.com/username"
      expect(job.link).to eq("http://www.instagram.com/username")
    end

    it "should ignore invalid urls" do
      job.link = "foo"
      expect(job.link).to eq(nil)
    end

    it { is_expected.to allow_value("foo.com", "foo.co", "foo.design", "foo.design/username").for(:link) }
  end

  describe "activity" do
    it "should have create activity" do
      job.save

      activity = PublicActivity::Activity.where(key: JobCreateActivity::KEY).last
      expect(activity).to be_present
      expect(activity.trackable).to eq(job)
      expect(activity.owner).to eq(job.user)
      expect(activity.private).to eq(true)
    end
  end

  describe 'publish!' do
    it "publishes the job" do
      company_follower = FactoryGirl.create(:user)
      company_follower.follow(job.company)
      company_follower.follow(job.user)

      user_follower = FactoryGirl.create(:user)
      user_follower.follow(job.user)

      job.save
      job.publish!

      expect(job.published?).to eq(true)
      expect(job.published_on).not_to be_nil

      activity = PublicActivity::Activity.last
      expect(activity).to be_present
      expect(activity.key).to eq JobPublishActivity::KEY
      expect(activity.trackable).to eq(job)
      expect(activity.owner).to eq(job.user)
      expect(activity.private).to eq(false)

      CreateNotificationJob.perform_now(activity.id)

      notifications = Notification.where(activity: activity)
      expect(notifications.count).to eq(2)
      
      notification = notifications.first
      expect(notification.user).to eq company_follower
    end
  end


  describe "skills" do
    it "should be able to set skills as array" do
      job.skills = [skill.name, skill2.name]
      job.save

      expect(job.skills.count).to eq 2
      expect(job.skills).to include(skill.name)
      expect(job.skills).to include(skill2.name)

      jobs = Job.with_any_skills(skill.name)
      expect(jobs.count).to eq(1)
    end

    it "should be able to set skills as string" do
      job.skills_list = "  #{skill.name},    #{skill2.name}  "
      job.save

      expect(job.skills.count).to eq 2
      expect(job.skills).to include(skill.name)
      expect(job.skills).to include(skill2.name)
      expect(job.skills_list).to eq "#{skill.name}, #{skill2.name}"
    end

    it "should be able add_skill!" do
      job.suggested_skills = [skill2.name]
      job.add_skill!(skill.name)
      job.add_skill!(skill.name)
      job.add_skill!(skill2.name)

      expect(job.skills_list).to eq "#{skill.name}, #{skill2.name}"

      puts job.suggested_skills
    end
  end

  describe "suggested skills" do
    it "should suggest skills based on description" do
      Skill.destroy_all
      FactoryGirl.create(:skill, name: "C++")
      FactoryGirl.create(:skill, name: "C")
      FactoryGirl.create(:skill, name: "Java")
      FactoryGirl.create(:skill, name: "Perl")
      description = %q(
      **ltd@amazon.com** for details!

Are you interested in shaping the future of movies, television, and digital video? Do you want to define the next generation of how and what Amazon customers are watching? Amazon Video Direct (AVD) has recently launched a platform that enables independent and professional video creators to reach millions of Amazon customers globally with the same monetization options and delivery quality available to major studios – and the reception has been incredible. We are growing quickly with a global focus on helping video providers be successful on the Amazon Video service. We need your passion, innovative ideas, and creativity to help continue to deliver on our ambitious goals.

We have an ambitious charter, and on this team you’ll be able to get your hands on lots of technologies. Above all, you’ll be leading the design and implementation of new scalable services, but you will also have the opportunity to do work on data analysis, machine learning, and large scale systems. These back-end services are areas we are investing in as we continue to grow at scale, processing large amounts of data to make sure Amazon customers discover content they care about. You'll get to build on top of Amazon’s vast development infrastructure, including AWS as well as internal tools for setting up continuous deployment and real-time monitoring. We work closely with video providers, internal Amazon teams, and external services.
We care about your career growth, too. Once you join the team, you and your manager will jointly craft a career plan and you’ll review it regularly to ensure you’re on track to meet your goals. Whether your goals are to explore new technologies, take on bigger problems, or get to the next level, we’ll help you get there. Our business is growing fast, and our people will grow with it.

This Senior Engineering role will influence many parts of the AV ecosystem, and will lead efforts to solve many difficult problems across multiple teams. The engineer will represent AV to internal and external partners, and will be a leader in the digital community. This person will drive innovation across the AV service while setting engineering standards across the AVD organization.

Amazon is an Equal Opportunity-Affirmative Action Employer - Minority/Female/Disability/Vet.

Basic Qualifications

* You should have a bachelor’s degree in Computer Science or a related technical field or of relevant work experience, or relevant work experience in lieu of a degree
* Proficiency in at least one modern programming language such as C, C++, C#, Java, or Perl etc.
* You should also have taken a leading role in building reliable, scalable software that has been successfully delivered to customers
* You actively lead code reviews, design reviews, automated testing, whiteboard discussions, back-of-the-napkin designs at lunch, and random chats in the hallway about awesome ideas
* Experience influencing software engineering best practices within your team and across others for the full software development life cycle, including coding standards, code reviews, source control management, build processes, testing, and operations
* Experience mentoring junior software engineers to improve their skills, and make them more effective, product software engineers
* Experience in communicating with users, other technical teams, and senior management to collect requirements, describe software product features, technical designs, and product strategy

Preferred Qualifications
You will be a visionary leader, builder, and operator. You will have experience leading or contributing to multiple simultaneous product development efforts and/or IT projects and initiatives. You will balance technical leadership and savvy with strong business judgment to make the right decisions about technology choices. You'll need to be constantly strive for simplicity, and at the same time demonstrate significant creativity and high judgment.

Also helpful:

* Proven track record of designing and delivering large-scale, highly available, low latency, high quality systems and software products
* Experience managing complex projects, with significant bottom-line impact
* Experience leading development life cycle process and best practices
* Experience with Agile (SCRUM, RUP, XP), OO modeling, SOA, UNIX, middleware, and database systems
* Experience in designing large scale data mining and analysis platforms
* Experience in machine learning and algorithms
      )
      job.description = description

      suggested_skills = job.parse_suggested_skills

      expect(suggested_skills.count).to eq(4)
    end
  end

  describe "suggested_users" do
    it "update_suggested_users" do
      user = FactoryGirl.create(:user, confirmed_at: DateTime.now)
      user.avatar = File.new("#{Rails.root}/spec/support/fixtures/image.png")
      user.save

      job.save
      job.update_suggested_users

      job_score = JobScore.where(user: user, job: job).first

      expect(job_score).to be_present
    end
  end

  describe "show suggested job scores on job show" do
    it "relevant job scores should be selected" do
      job.skills = [skill.name, skill2.name]
      job.save

      #add job score for job creator
      job_creator = job.user
      job_creator.confirmed_at = DateTime.now
      job_creator.avatar = File.new("#{Rails.root}/spec/support/fixtures/image.png")
      job_creator.save
      FactoryGirl.create(:user_skill, user: job_creator, skill: skill)

      #creating user without any skills i.e w/o any job score
      user1 = FactoryGirl.create(:user, confirmed_at: DateTime.now)
      user1.avatar = File.new("#{Rails.root}/spec/support/fixtures/image.png")
      user1.save

      job.update_suggested_users

      # 2 user(1 job owner + 1 w/o job score) are present
      # Suggested job scores should be 0 as job owner  & user with job score 0 can't be selected
      expect(job.suggested_job_scores.count).to eq(0)

      # create 6 new users having job scores

      for i in (1..6) do
        user = FactoryGirl.create(:user, confirmed_at: DateTime.now)
        user.avatar = File.new("#{Rails.root}/spec/support/fixtures/image.png")
        user.save
        FactoryGirl.create(:user_skill, user: user, skill: skill)
      end

      job.update_suggested_users

      suggested_job_scores = job.suggested_job_scores
      #Max  5 suggested job scores can be selected.Total user are 8(6 with job score + 1 job owner + 1 w/o job score)
      # but suggested job scores should be 5
      expect(suggested_job_scores.count).to eq(5)

      suggested_job_scores.each do |job_scores|
        #job scores with score greater than 0 should only be selected 
        expect(job_scores.score).to be > 0

        #selected job scores should not be of user who created the job
        expect(job_scores.user_id).not_to eql(job_creator.id)
      end
    end
  end


  describe "friendly_id" do
    it "should create a slug based on name, company id" do
      company = FactoryGirl.create(:company, name: "company")

      job = FactoryGirl.create(:job, name: "job title", company: company)
      expect(job.friendly_id).to eq("job-title-#{job.company.name}".downcase)

      job2 = FactoryGirl.create(:job, name: "job title", company: company)

      expect(job2.friendly_id).to eq("job-title-#{job2.company.name}-#{company.jobs.count}".downcase)
    end
  end
end
