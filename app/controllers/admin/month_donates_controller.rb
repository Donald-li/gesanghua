class Admin::MonthDonatesController < Admin::BaseController

  before_action :set_month_donate, only: [:edit, :update]

  def index
    @search = MonthDonate.sorted.ransack(params[:q])
    scope = @search.result
    @month_donates = scope.page(params[:page])
  end

  def edit
  end

  def update
    respond_to do |format|
      if @month_donate.update(month_donate_params)
        if @month_donate.donated_period == @month_donate.plan_period
          @month_donate.update(state: 2)
        end
        format.html { redirect_to admin_month_donates_url, notice: '月捐信息已修改。' }
      else
        format.html { render :edit }
      end
    end
  end

  private
  def set_month_donate
    @month_donate = MonthDonate.find(params[:id])
  end

  def month_donate_params
    params.require(:month_donate).permit!
  end

end
