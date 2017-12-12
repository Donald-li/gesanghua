class Admin::ModifyPasswordController < Admin::BaseController
  before_action :set_administrator, only: [:update]

  def edit
    @administrator = Administrator.new
  end

  def update
    respond_to do |format|
      format.html { redirect_to admin_modify_password_url, alert: '当前密码有误。' } unless @administrator.authenticate(modify_password_params[:current_password])
      format.html { redirect_to admin_modify_password_url, alert: '确认密码不正确。' } unless modify_password_params[:password] === modify_password_params[:password_confirmation]
      if @administrator.update(password: modify_password_params[:password])
        format.html { redirect_to referer_or(admin_modify_password_url), notice: '密码已修改。' }
      else
        format.html { redirect_to referer_or(admin_modify_password_url) }
      end
    end
  end

  private

  def set_administrator
    @administrator = Administrator.find(current_administrator.id)
  end

  def modify_password_params
    params.require(:administrator).permit(:current_password, :password, :password_confirmation)
  end
end
