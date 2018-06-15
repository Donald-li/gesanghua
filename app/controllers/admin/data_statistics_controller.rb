class Admin::DataStatisticsController < Admin::BaseController
  before_action :auth_manage_operation

  def show
    @user_count = User.enable.count
    @volunteer_count = Volunteer.enable.count
    @donate_record = DonateRecord.count
    @income_count = IncomeRecord.can_count.sum(:amount)

  end

end
