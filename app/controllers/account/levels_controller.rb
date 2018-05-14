class Account::LevelsController < Account::BaseController
  def show
    @all_badges = BadgeLevel.sorted.options_for_select(:kinds)
    @my_badges = @all_badges.map{|b| BadgeLevel.level_of_user(current_user, b.second)}.compact
  end
end
