class Admin::MonthDonateRecordsController < Admin::BaseController

  before_action :set_month_donate, only: [:index]

  def index
    if !@month_donate.donate_records.present?
      @donate_record = @month_donate.donate_records.new
      @donate_record.donor = @month_donate.user.try(:name)
      @donate_record.remitter_name = @month_donate.user.try(:name)
      @donate_record.user = @month_donate.user
      @donate_record.fund = @month_donate.fund
      @donate_record.pay_state = 2
      @donate_record.period = @month_donate.donated_period
      @donate_record.amount = @month_donate.amount
      @donate_record.save
    end
    @search = @month_donate.donate_records.sorted.ransack(params[:q])
    scope = @search.result
    @donate_records = scope.page(params[:page])
  end

  private

  def set_month_donate
    @month_donate = MonthDonate.find(params[:month_donate_id])
  end

end
