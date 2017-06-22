require 'redcarpet'
require 'redcarpet/render_strip'

module ApplicationHelper
  
  def model_image(image, width, height, use_https = false)
    if image
      image.remote_url(width: width, height: height, crop: :fill, secure: use_https, gravity: :north, fetch_format: "auto", quality: "auto")
    else
      image_placeholder_url(width,height)
    end
  end

  def model_avatar(image, size, use_https = false)
    if image
      image.remote_url(width: size, height: size, crop: :fill, secure: use_https, gravity: :north, fetch_format: "auto", quality: "auto")
    else
      cl_image_path("default_avatar.png", {secure: use_https})
    end
  end

  def company_avatar(image, size, use_https = false)
    if image
      image.remote_url(width: size, height: size, crop: :fill, secure: use_https, gravity: :north, fetch_format: "auto", quality: "auto")
    else
      cl_image_path("default_company_avatar.png", {secure: use_https})
    end
  end

  def image_placeholder_url(width, height)
    return "//placehold.it/#{width}x#{height}"
  end

  def markdown(content)
    return if content.blank?
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, {
      autolink: true,
      space_after_headers: true,
      fenced_code_blocks: true,
      underline: true,
      highlight: true,
      footnotes: true,
      tables: true
    })
    @markdown.render(content).html_safe
  end

  def markdown_stripped(content)
    return if content.blank?
    @markdown_stripped ||= Redcarpet::Markdown.new(Redcarpet::Render::StripDown)

    @markdown_stripped.render(content)
  end

  def mentioned_users(body)
    body.gsub /@([\w\.\-]+)/ do |match|
      link_to match, user_path($1)
    end.html_safe
  end

  def show_confirm_email
    user_signed_in? && (!current_user.confirmed? || current_user.pending_reconfirmation?)
  end
end
