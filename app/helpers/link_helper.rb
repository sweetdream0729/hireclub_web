module LinkHelper
  def link_host(url)
    return url if url.blank?
    uri = URI.parse(url)
    uri = URI.parse("http://" + url) if uri.scheme.blank?
    return uri.host.gsub("www.","")
  end
end