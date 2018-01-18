class Admin::MonthDonateRecordsController < Admin::BaseController

  before_action :set_month_donate, only: [:index]

  def index
    if !@month_donate.month_donate_records.present?
      @month_donate_record = @month_donate.month_donate_records.new
      @month_donate_record.period = @month_donate.donated_period
      @month_donate_record.amount = @month_donate.amount
      @month_donate_record.save
    end
    @search = @month_donate.month_donate_records.sorted.ransack(params[:q])
    scope = @search.result
    @month_donate_records = scope.page(params[:page])
  end

  private

  def set_month_donate
    @month_donate = MonthDonate.find(params[:month_donate_id])
  end

end
