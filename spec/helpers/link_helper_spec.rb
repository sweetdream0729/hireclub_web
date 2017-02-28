require 'rails_helper'

describe LinkHelper do
  it "should only the host of a link" do
    link = "http://www.site.com"

    expect(link_host("http://www.site.com")).to eq("site.com")

    expect(link_host("http://subdomain.site.com")).to eq("subdomain.site.com")

    expect(link_host("http://site.com/url/page")).to eq("site.com")

    expect(link_host("site.com")).to eq("site.com")

    expect(link_host("site.co.uk")).to eq("site.co.uk")

    expect(link_host("site.co.uk/test")).to eq("site.co.uk")
  end
end
