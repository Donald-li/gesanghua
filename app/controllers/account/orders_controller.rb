class Account::OrdersController < Account::BaseController

  before_action :set_per

  def index
    respond_to do |format|
      format.html do
        #@project = Rails.cache.read("donate_project_#{current_user.id}")
        @donate_records = DonateRecord.select_record(current_user.id, params[:type]).sorted.decode_page(params)
        @projects = Project.visible.sorted.donate_project
      end
      format.js do
        @donate_records = DonateRecord.select_record(current_user.id, params[:type]).sorted.decode_page(params)
      end
    end
  end

  def select_tab
    respond_to do |format|
      format.html do
        @donate_records = DonateRecord.select_record(current_user.id, params[:type]).sorted.decode_page(params)
        render partial: "info"
      end
      format.js do
        @donate_records = DonateRecord.select_record(current_user.id, params[:type]).sorted.decode_page(params)
      end
    end
  end

  private

  def set_per
    params[:per] = 4
  end

end
