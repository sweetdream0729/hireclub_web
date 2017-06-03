class DashboardPolicy < Struct.new(:user, :dashboard)
  def show?
    return false if user.nil?
    user.is_admin
  end
end