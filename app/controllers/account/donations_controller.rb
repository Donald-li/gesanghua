class Account::DonationsController < Account::BaseController

  def index
    @has_team = current_user.team.present?
    if @has_team
      @team = current_user.team
      scope = DonateRecord.where(team_id: @team.id).sorted
      @donate_records = scope.page(params[:page]).per(8)
    end
  end

end
