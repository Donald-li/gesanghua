class Account::PersonalsController < Account::BaseController

  def index
    @persional = User.find_by_id 2 #current_user
    @persional.phone = ""
  end

  def edit
    @persional = User.find_by_id 2 #current_user
  end

  def update
    respond_to do |format|
      if @persional.update(user_params)
        @persional.attach_avatar(params[:avatar_id])
        format.html {redirect_to referer_or(account_persionals_path), notice: '个人信息已修改。'}
      else
        format.html {render :edit}
      end
    end
  end

  def binding
    respond_to do |format|
      if current_user.update_attributes(phone: params[:personal][:phone])
        format.html {redirect_to account_personals_path, notice: '手机号绑定成功。'}
      else
        format.html {redirect_to account_personals_path, notice: '手机号绑定失败。'}
      end
    end
  end

  private

  def user_params
    params.require(:user).permit!
  end

end
