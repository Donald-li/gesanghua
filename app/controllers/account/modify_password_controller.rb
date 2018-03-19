class Account::ModifyPasswordController < Account::BaseController
  before_action :set_organization, only: [:edit, :update]

  def edit
    @organization = User.new
  end

  def update
    respond_to do |format|
      format.html { redirect_to referer_or(organization_modify_password_url), alert: '当前密码有误。' } unless @organization.authenticate(modify_password_params[:current_password])
      format.html { redirect_to referer_or(organization_modify_password_url), alert: '确认密码不正确。' } unless modify_password_params[:password] === modify_password_params[:password_confirmation]
      if @organization.update(password: modify_password_params[:password])
        format.html { redirect_to referer_or(organization_modify_password_url), notice: '密码已修改。' }
      else
        format.html { redirect_to referer_or(organization_modify_password_url) }
      end
    end
  end

  private

  def set_organization
    @organization = User.find(session[:current_organization_id])
  end

  def modify_password_params
    params.require(:organization).permit(:current_password, :password, :password_confirmation)
  end
end
