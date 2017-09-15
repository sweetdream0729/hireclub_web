class NewsletterPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    admin?
  end

  def update?
    admin?
  end

  def destroy?
    admin? && record.destroyable?
  end

  def preview?
    admin?
  end

  def publish?
    admin? && record.publishable?
  end

end
