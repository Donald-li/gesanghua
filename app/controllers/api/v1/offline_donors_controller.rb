class Api::V1::OfflineDonorsController < Api::V1::BaseController

  def donor_list
    donors = current_user.offline_users.sorted
    api_success(data: donors.map{|donor| donor.offline_donor_summary_builder})
  end

  def get_current_user
    @user = current_user
    api_success(data: @user.offline_donor_summary_builder)
  end

  def delete_donor
    @user = current_user
    @offline_donor = @user.offline_users.find(params[:id])
    if @offline_donor.present?
      if @offline_donor.update(manager_id: nil)
        api_success(data: {result: true}, message: '删除捐助人信息成功。')
      else
        api_success(data: {result: false}, message: '删除捐助人信息失败，请重试！')
      end
    else
      api_success(data: {result: false}, message: '无效信息')
    end
  end

  def get_donor_info
    @user = current_user.offline_users.find(params[:id])
    api_success(data: @user.detail_builder)
  end

  def create_donor
    @user = current_user
    name = params[:name]
    nickname = params[:nickname]
    phone = params[:phone]
    email = params[:email]
    province = params[:location][0] if params[:location].present?
    city = params[:location][1] if params[:location].present?
    district = params[:location][2] if params[:location].present?
    address  = params[:address]
    salutation = params[:salutation]
    if params[:gender] == ['男']
      gender = 'male'
    else
      gender = 'female'
    end
    if params[:use_nickname]
      use_nickname = 'true'
    else
      use_nickname = 'false'
    end
    if @donor = User.create_offline_user(name, phone, gender, salutation, email, province, city, district, address, nickname, use_nickname)
      @donor.update(manager_id: @user.id)
      api_success(data: {result: true}, message: '创建捐助人信息成功。')
    else
      api_success(data: {result: false}, message: '创建捐助人信息失败，请重试！')
    end
  end

  def update_donor
    @user = current_user
    name = params[:name]
    nickname = params[:nickname]
    phone = params[:phone]
    email = params[:email]
    province = params[:location][0]
    city = params[:location][1]
    district = params[:location][2]
    address  = params[:address]
    if params[:use_nickname]
      use_nickname = 'true'
    else
      use_nickname = 'false'
    end
    @donor = @user.offline_users.find(params[:id])
    if @donor.update(name: name,nickname: nickname, phone: phone, email: email, province: province, city: city, district: district, address: address, use_nickname: use_nickname)
      api_success(data: {result: true}, message: '修改捐助人信息成功。')
    else
      api_success(data: {result: false}, message: '修改捐助人信息失败，请重试！')
    end
  end

end
