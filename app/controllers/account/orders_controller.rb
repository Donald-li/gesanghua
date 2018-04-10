class Account::OrdersController < Account::BaseController

  def index
    respond_to do |format|
      format.html do # HTML页面
        #byebug
        @donate_records = DonateRecord.where(agent_id: current_user.id).sorted.page(params[:page]).per(4)
      end
    end
  end

  def show

  end

end
