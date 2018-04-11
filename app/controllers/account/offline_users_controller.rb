class Account::OfflineUsersController < Account::BaseController

  def index
    @offline_users = User.where(manager: current_user).sorted
    if params[:id].present?
      @offline_user = User.find(params[:id])
    else
      @offline_user = current_user.offline_users.new
    end
  end

  def create
    login = offline_user_params[:phone]
    gender = params[:gender]
    @offline_user = current_user.offline_users.new(offline_user_params.merge(login: login, gender: gender))
    if @offline_user.save
      flash[:notice] = '创建成功。'
      gen_success_message
    else
      flash[:notice] = @offline_user.errors.full_messages
      gen_failure_message(@offline_user)
    end
  end

  def update
    @offline_user = User.find_by_id(params[:id])
    gender = params[:gender]
    if @offline_user.update_attributes(offline_user_params.merge(login: offline_user_params[:phone], gender: gender))
      flash[:notice] = '修改成功。'
      gen_success_message
    else
      flash[:notice] = @offline_user.errors.full_messages
      gen_failure_message(@offline_user)
    end
  end

  def destroy
    @offline_user = User.find(params[:id])
    @offline_user.manager_id = nil
    if @offline_user.save
      redirect_to account_offline_users_path, notice: '删除成功。'
    else
      redirect_to account_offline_users_path, notice: @offline_user.errors.full_messages
    end
  end

  def edit
    @offline_user = User.find_by_id(params[:id])
    render 'form', :layout => 'bootstrap_modal'
  end

  def new
    @offline_user = current_user.offline_users.new
    render 'form', :layout => 'bootstrap_modal'
  end

  private
  def offline_user_params
    params.require(:user).permit!
  end

end
