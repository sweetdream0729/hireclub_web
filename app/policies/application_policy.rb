class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    true
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def admin?
    return false if user.nil?
    user.is_admin
  end

  def moderator?
    return false if user.nil?
    user.is_moderator || user.is_admin
  end

  def user_present?
    return false if user.nil?
    return true
  end

  def owner_or_admin?
    return false if user.nil?
    record.user == user || user.is_admin
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
