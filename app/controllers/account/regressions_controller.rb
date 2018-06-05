class Account::RegressionsController < Account::BaseController
  skip_before_action :login_require, only: [:new, :create]

  layout 'blank'

  def new
  end

  def create
    if user_params[:phone].empty? && user_params[:email].empty?
      flash[:alert] = "邮箱、手机号必须有一项"
      render :new and return
    end

    user = match_user(2)
    if user.present?
      set_current_user(user)
      user.state = 'enable'
      if user.save
        redirect_to edit_password_account_user_center_account_path
      else
        flash[:alert] = "找回失败"
        render :new
      end
    else
      flash[:alert] = "找回失败"
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit!
  end

  def set_current_user(user)
    session[:user_id] = user.id
  end

  def match_user(condition)
    user_library = User.unactived.where(manager_id: nil)
    # 匹配任意两条
    users = {}
    if condition == 2
      # users = user_library.where(nickname: user_params[:nickname], name: user_params[:name]) if user_params[:nickname].present? and user_params[:name].present?
      users = user_library.where(nickname: user_params[:nickname], phone: user_params[:phone]) if user_params[:nickname].present? and user_params[:phone].present? && users.empty?
      users = user_library.where(nickname: user_params[:nickname], email: user_params[:email]) if user_params[:nickname].present? and user_params[:email].present? && users.empty?
      users = user_library.where(name: user_params[:name], phone: user_params[:phone]) if user_params[:name].present? and user_params[:phone].present? && users.empty?
      users = user_library.where(name: user_params[:name], email: user_params[:email]) if user_params[:name].present? and user_params[:email].present? && users.empty?
      users = user_library.where(phone: user_params[:phone], email: user_params[:email]) if user_params[:phone].present? and user_params[:email].present? && users.empty?
    end

    # 匹配任意三条
    if users.count > 1
      users = user_library.where(name: user_params[:name], phone: user_params[:phone], email: user_params[:email]) if user_params[:name].present? and user_params[:phone].present? and user_params[:email].present?
      users = user_library.where(nickname: user_params[:nickname], name: user_params[:name], phone: user_params[:phone]) if user_params[:nickname].present? and user_params[:name].present? and user_params[:phone].present? && users.empty?
      users = user_library.where(nickname: user_params[:nickname], name: user_params[:name], email: user_params[:email]) if user_params[:nickname].present? and user_params[:name].present? and user_params[:email].present? && users.empty?
      users = user_library.where(nickname: user_params[:nickname], phone: user_params[:phone], email: user_params[:email]) if user_params[:nickname].present? and user_params[:phone].present? and user_params[:email].present? && users.empty?
    end

    # 匹配全部
    if users.count > 1
      users = user_library.where(nickname: user_params[:nickname], name: user_params[:name], phone: user_params[:phone], email: user_params[:email]) if user_params[:nickname].present? and user_params[:name].present? and user_params[:phone].present? and user_params[:email].present?
    end
    return users.first
  end

end
