# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://www.hireclub.com"
# pick a place safe to write the files
SitemapGenerator::Sitemap.public_path = 'tmp/'

# store on S3 using Fog
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new

# inform the map cross-linking where to find the other maps
SitemapGenerator::Sitemap.sitemaps_host = "http://#{ENV['FOG_DIRECTORY']}.s3.amazonaws.com/"

# pick a namespace within your bucket to organize your maps
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

SitemapGenerator::Sitemap.create do
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #

  add skills_path, :priority => 0.7, :changefreq => 'daily'
  Skill.find_each do |skill|
    add skill_path(skill), :lastmod => skill.updated_at
  end

  add roles_path, :priority => 0.7, :changefreq => 'daily'
  Role.find_each do |role|
    add role_path(role), :lastmod => role.updated_at
  end

  add companies_path, :priority => 0.7, :changefreq => 'daily'
  Company.find_each do |company|
    add company_path(company), :lastmod => company.updated_at
  end

  add communities_path, :priority => 0.7, :changefreq => 'daily'
  Community.find_each do |community|
    add community_path(community), :lastmod => community.updated_at
  end

  add projects_path, :priority => 0.7, :changefreq => 'daily'
  Project.find_each do |project|
    add project_path(project), :lastmod => project.updated_at
  end

  add stories_path, :priority => 0.7, :changefreq => 'daily'
  Story.published.find_each do |story|
    add story_path(story), :lastmod => story.updated_at
  end

  add jobs_path, :priority => 0.7, :changefreq => 'daily'
  Job.published.find_each do |job|
    add job_path(job), :lastmod => job.updated_at
  end

  add events_path, :priority => 0.7, :changefreq => 'daily'
  Event.published.find_each do |event|
    add event_path(event), :lastmod => event.updated_at
  end
end
