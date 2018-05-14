class Api::V1::Cooperation::BadgesController < Api::V1::BaseController
  skip_before_action :login?

  # 所有徽章
  def index
    all_badges = BadgeLevel.sorted.options_for_select(:kinds)
    my_badges = all_badges.map{|b| BadgeLevel.level_of_user(current_user, b.second)}.compact
    api_success(data: my_badges.map(&:summary_builder))
  end

  # 某个徽章
  def show
    level = BadgeLevel.level_of_user(current_user, params[:id]).try(:summary_builder)
  end

end
