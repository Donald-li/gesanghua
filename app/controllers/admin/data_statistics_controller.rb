class Admin::DataStatisticsController < Admin::BaseController

  def show
    @user_count = User.enable.count
    @volunteer_count = Volunteer.enable.count
    @donate_record = DonateRecord.paid.count
    @income_count = IncomeRecord.count(:amount)
  end

end
