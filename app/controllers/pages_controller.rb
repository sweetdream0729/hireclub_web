class PagesController < ApplicationController
  def index
  end

  def about
  end

  def contact
  end

  def letsencrypt
    render text: "zCaXWo2WTbYIFMdnnRhIPqGmfZ36HlDQ7UCWf8obKtI.R7J5HZzwF8y8D6YdxAG8krBSycV1w9M5sE1GG7lC-oM"
  end
end
