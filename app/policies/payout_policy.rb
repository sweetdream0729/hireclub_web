class PayoutPolicy < ApplicationPolicy

  def create?
    admin?
  end

  def new?
  	admin?
  end

end