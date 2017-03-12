class PagesController < ApplicationController
  def index
  end

  def about
  end

  def contact
  end

  def letsencrypt
    render text: "N8qdmP5J9PeacjC9I-FRDfO7XabPSXS0xG9cPp6fICc.R7J5HZzwF8y8D6YdxAG8krBSycV1w9M5sE1GG7lC-oM"
  end
end
