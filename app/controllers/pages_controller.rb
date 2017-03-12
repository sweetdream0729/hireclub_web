class PagesController < ApplicationController
  def index
  end

  def about
  end

  def contact
  end

  def letsencrypt
    render text: "fJBEt6XWGHIWiTxm6j0ygufm1-rJnCjlb7sDjaYrQLA"
  end
end
