class Account::OfflineUsersController < Account::BaseController

  def index
    @offline_users = User.where(manager: current_user).sorted
  end

  def create
    login = offline_user_params[:phone]
    @offline_user = current_user.offline_users.new(offline_user_params.merge(login: login, state: 'unactived'))
    if @offline_user.save
      render json: {message: '添加成功', status: true}
    else
      render json: {message: @offline_user.errors.full_messages.first, status: false}
    end
  end

  def update
    @offline_user = User.find_by_id(params[:id])
    if @offline_user.update_attributes(offline_user_params.merge(login: offline_user_params[:phone]))
      render json: {message: '修改成功', status: true}
    else
      render json: {message: @offline_user.errors.full_messages.first, status: false}
    end
  end

  def destroy
    @offline_user = User.find(params[:id])
    @offline_user.manager_id = nil
    if @offline_user.save
      render json: {message: '删除成功', status: true}
    else
      render json: {message: '删除失败，请重试。', status: false}
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
