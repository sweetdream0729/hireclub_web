module ApplicationHelper
  
  def model_image(image, width, height, use_https = false)
    if image
      image.remote_url(width: width, height: height, crop: :fill, secure: use_https, gravity: :north, format: "jpg", quality: 80)
    else
      image_placeholder_url(width,height)
    end
  end

  def model_avatar(image, size, use_https = false)
    if image
      image.remote_url(width: size, height: size, crop: :fill, secure: use_https, gravity: :north, format: "jpg", quality: 80)
    else
      cl_image_path("default_avatar.png")
    end
  end

  def company_avatar(image, size, use_https = false)
    if image
      image.remote_url(width: size, height: size, crop: :fill, secure: use_https, gravity: :north, format: "jpg", quality: 80)
    else
      cl_image_path("default_company_avatar.png")
    end
  end

  def image_placeholder_url(width, height)
    return "//placehold.it/#{width}x#{height}"
  end
end
