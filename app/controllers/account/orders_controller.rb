class Account::OrdersController < Account::BaseController

  def index
    respond_to do |format|
      format.html do
        #@donate_records = DonateRecord.where(agent_id: current_user.id).sorted.page(params[:page]).per(4)
        @donate_records = DonateRecord.sorted.page(params[:page]).per(2)
        #@project = Rails.cache.read("donate_project_#{current_user.id}")
        @project = Project.donate_project
      end
      format.js do
        if params[:type].to_i == 0
          @donate_records = DonateRecord.sorted.page(params[:page]).per(2)
        else
          @donate_records = DonateRecord.where(agent_id: params[:type]).sorted.page(params[:page]).per(2)
        end
      end
    end

  end

  def show

  end

  def select_tab
    respond_to do |format|
      format.html do
        if params[:type].to_i == 0
          @donate_records = DonateRecord.sorted.page(params[:page]).per(2)
        else
          @donate_records = DonateRecord.where(agent_id: params[:type]).sorted.page(params[:page]).per(2)
        end
        render partial: "info"
      end
      format.js do
        if params[:type].to_i == 0
          @donate_records = DonateRecord.sorted.page(params[:page]).per(2)
        else
          @donate_records = DonateRecord.where(agent_id: params[:type]).sorted.page(params[:page]).per(2)
        end
      end
    end
  end

end
