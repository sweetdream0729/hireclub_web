class DashboardPolicy < Struct.new(:user, :dashboard)
  def show?
    admin?
  end

  def admin?
    return false if user.nil?
    user.is_admin
  end
end