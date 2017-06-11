require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  let(:user) { FactoryGirl.create(:user) }
 
  describe "user_welcome" do
    let(:mail) do 
      user.welcome!      
      activity = Activity.where(key: UserWelcomeActivity::KEY).last
      expect(activity).to be_present

      CreateNotificationJob.perform_now(activity)

      notification = Notification.where(activity: activity).last
      expect(notification).to be_present

      NotificationMailer.user_welcome(notification)
    end

    it 'renders the email' do
      expect(mail.subject).to eq("Welcome to HireClub! 🍾")
      expect(mail.to).to eq([user.email])
    end
  end

  describe "comment_created" do
    let(:comment) { FactoryGirl.create(:comment) }
    let(:mail) do 
      expect(comment).to be_persisted

      activity = Activity.where(key: CommentCreateActivity::KEY).last
      expect(activity).to be_present

      CreateNotificationJob.perform_now(activity)

      notification = Notification.where(activity: activity).last
      expect(notification).to be_present

      NotificationMailer.comment_created(notification)
    end

    it 'renders the email' do
      expect(mail.subject).to eq("New Comment")
      expect(mail.to).to eq([comment.commentable.user.email])
    end
  end

  describe "comment_mentioned" do
    let(:kidbombay) {FactoryGirl.create(:user, username: "kidbombay")}
    let(:comment) { FactoryGirl.create(:comment, text: "hey @#{kidbombay.username}") }
    let(:mail) do 
      expect(comment).to be_persisted

      activity = Activity.where(key: MentionCreateActivity::KEY).last
      expect(activity).to be_present

      CreateNotificationJob.perform_now(activity)

      notification = Notification.where(activity: activity).last
      expect(notification).to be_present

      NotificationMailer.comment_mentioned(notification)
    end

    it 'renders the email' do
      expect(mail.subject).to eq("New Mention")
      expect(mail.to).to eq([kidbombay.email])
    end
  end

  describe "job_created" do
    let(:user2) { FactoryGirl.create(:user) }
    let(:job) { FactoryGirl.create(:job, user: user) }
    let(:mail) do 
      user2.follow(user)
      expect(job).to be_persisted
      job.publish!

      activity = Activity.where(key: JobPublishActivity::KEY).last
      expect(activity).to be_present

      CreateNotificationJob.perform_now(activity)

      notification = Notification.where(activity: activity).last
      expect(notification).to be_present

      NotificationMailer.job_created(notification)
    end

    it 'renders the email' do
      expect(mail.subject).to eq("#{job.company.name} posted job #{job.name}")
      expect(mail.to).to eq([user2.email])
    end
  end

  describe "story_published" do
    let(:user2) { FactoryGirl.create(:user) }
    let(:story) { FactoryGirl.create(:story, user: user) }
    let(:mail) do 
      user2.follow(user)
      expect(story).to be_persisted
      story.publish!

      activity = Activity.where(key: StoryPublishActivity::KEY).last
      expect(activity).to be_present

      CreateNotificationJob.perform_now(activity)

      notification = Notification.where(activity: activity).last
      expect(notification).to be_present

      NotificationMailer.story_published(notification)
    end

    it 'renders the email' do
      expect(mail.subject).to eq("#{story.user.display_name} published #{story.name}")
      expect(mail.to).to eq([user2.email])
    end
  end

  describe "project_created" do
    let(:user2) { FactoryGirl.create(:user) }
    let(:project) { FactoryGirl.create(:project, user: user) }
    let(:mail) do 
      user2.follow(user)
      expect(project).to be_persisted

      activity = Activity.where(key: ProjectCreateActivity::KEY).last
      expect(activity).to be_present

      CreateNotificationJob.perform_now(activity)

      notification = Notification.where(activity: activity).last
      expect(notification).to be_present

      NotificationMailer.project_created(notification)
    end

    it 'renders the email' do
      expect(mail.subject).to eq("#{project.user.display_name} added project #{project.name}")
      expect(mail.to).to eq([user2.email])
    end
  end

  describe "follow_user" do
    let(:user2) { FactoryGirl.create(:user) }
    let(:mail) do 
      user2.follow(user)
      
      activity = Activity.where(key: UserFollowActivity::KEY).last
      expect(activity).to be_present

      CreateNotificationJob.perform_now(activity)

      notification = Notification.where(activity: activity).last
      expect(notification).to be_present

      NotificationMailer.user_followed(notification)
    end

    it 'renders the email' do
      expect(mail.subject).to eq("#{user2.display_name} followed you on HireClub")
      expect(mail.to).to eq([user.email])
    end
  end
end
