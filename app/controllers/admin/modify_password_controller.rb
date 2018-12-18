class Admin::ModifyPasswordController < Admin::BaseController
  before_action :set_administrator, only: [:update]

  def edit
    @administrator = User.new
  end

  def update
    respond_to do |format|
      format.html { redirect_to admin_modify_password_url, alert: '当前密码有误。' and return } unless @administrator.authenticate(modify_password_params[:current_password])
      format.html { redirect_to admin_modify_password_url, alert: '确认密码不正确。' and return } unless modify_password_params[:password] === modify_password_params[:password_confirmation]
      if @administrator.update(password: modify_password_params[:password])
        format.html { redirect_to referer_or(admin_main_path), notice: '密码已修改。' }
      else
        format.html { redirect_to referer_or(admin_modify_password_url) }
      end
    end
  end

  private

  def set_administrator
    @administrator = User.find(current_user.id)
  end

  def modify_password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
