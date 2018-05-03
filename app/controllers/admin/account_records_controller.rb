class Admin::AccountRecordsController < Admin::BaseController
  before_action :auth_manage_operation
  before_action :set_user
  before_action :set_account_record, only: [:destroy]

  def index
    @account_records = @user.account_records
    set_search_end_of_day(:created_at_lteq)
    @search = @account_records.ransack(params[:q])
    scope = @search.result
    @account_records = scope.sorted.page(params[:page])
  end

  def new
    @account_record = AccountRecord.new
  end

  def create
    @account_record = AccountRecord.new(account_params.merge(user: @user, state: 'user_operate'))
    respond_to do |format|
      if @account_record.save
        format.html { redirect_to referer_or(admin_user_account_records_path(@user)), notice: '记录已增加。' }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @account_record.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_user_account_records_path(@user)), notice: '记录已删除。' }
    end
  end

  private
  def set_account_record
    @account_record = AccountRecord.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def account_params
    params.require(:account_record).permit!
  end

end
