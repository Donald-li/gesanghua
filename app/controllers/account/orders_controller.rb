class Account::OrdersController < Account::BaseController

  def index
    respond_to do |format|
      format.html do
        #@project = Rails.cache.read("donate_project_#{current_user.id}")
        @donate_records = DonateRecord.select_record(current_user.id, params[:type]).sorted.page(params[:page]).per(4)
        @project = Project.donate_project
      end
      format.js do
        @donate_records = DonateRecord.select_record(current_user.id, params[:type]).sorted.page(params[:page]).per(4)
      end
    end
  end

  def select_tab
    respond_to do |format|
      format.html do
        @donate_records = DonateRecord.select_record(current_user.id, params[:type]).sorted.page(params[:page]).per(4)
        render partial: "info"
      end
      format.js do
        @donate_records = DonateRecord.select_record(current_user.id, params[:type]).sorted.page(params[:page]).per(4)
      end
    end
  end

end
