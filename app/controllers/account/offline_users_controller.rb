class Account::OfflineUsersController < Account::BaseController

  def index
    @offline_users = User.where(manager: current_user)
    if params[:id].present?
      @offline_user = User.find(params[:id])
    else
      @offline_user = current_user.offline_users.new
    end
  end

  def create
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
    @offline_user = current_user.offline_users.new(offline_user_params)
    @offline_user.login = @offline_user.phone
    @offline_user.province = province
    @offline_user.city = city
    @offline_user.district = district
    @offline_user.gender = gender
    # if params[:name].blank?
    #   redirect_to account_offline_users_path && return, notice: '真实姓名必须填写。'
    # end
    # if params[:phone].blank?
    #   redirect_to account_offline_users_path && return, notice: '手机号必须填写。'
    # end
    # @offline_user = User.new(login: login, name: name, nickname: nickname, phone: phone, address: address, salutation: salutation, province: province, city: city, district: district, gender: gender)
    # @offline_user.manager_id = current_user.id
    if @offline_user.save
      redirect_to account_offline_users_path, notice: '创建成功。'
    else
      redirect_to account_offline_users_path, notice: @offline_user.errors.full_messages
    end
  end

  def update
    province = params[:user_province_id]
    city = params[:user_city_id]
    district = params[:user_district_id]
    gender = params[:gender]
    if @offline_user.update(offline_user_params).merge(login: offline_user_params[:phone], province: province, city: city, district: district, gender: gender)
      redirect_to account_offline_users_path, notice: '修改成功。'
    else
      redirect_to account_offline_users_path, notice: @offline_user.errors.full_messages
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

  private
  def offline_user_params
    params.require(:user).permit!
  end

end
