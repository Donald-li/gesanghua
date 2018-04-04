class Account::OfflineUsersController < Account::BaseController

  def index
    @offline_users = User.where(manager: current_user)
  end

  def create
    if params[:name].blank?
      redirect_to account_offline_users_path && return, notice: '真实姓名必须填写。'
    end
    if params[:phone].blank?
      redirect_to account_offline_users_path && return, notice: '手机号必须填写。'
    end
    name = params[:name]
    nickname = params[:nickname]
    phone = params[:phone]
    login = params[:phone]
    address = params[:address]
    salutation = params[:salutation]
    province = params[:user_province_id]
    city = params[:user_city_id]
    district = params[:user_district_id]
    gender = params[:gender]
    @offline_user = User.new(login: login, name: name, nickname: nickname, phone: phone, address: address, salutation: salutation, province: province, city: city, district: district, gender: gender)
    @offline_user.manager_id = current_user.id
    if @offline_user.save
      redirect_to account_offline_users_path, notice: '创建成功。'
    else
      redirect_to account_offline_users_path, notice: @offline_user.errors.full_messages
    end
  end

  def update

  end

  private
  def offline_user_params
    params.require(:offline_user).permit!
  end

end
