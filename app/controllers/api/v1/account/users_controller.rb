class Api::V1::Account::UsersController < Api::V1::BaseController

  def index
    user = current_user
    api_success(data: user.summary_builder)
  end

  def get_user_details
    user = current_user
    api_success(data: user.detail_builder)
  end

  def update_user
    user = current_user
    province = params[:location][0]
    city = params[:location][1]
    district = params[:location][2]
    address = params[:address]
    phone = params[:phone]
    nickname = params[:nickname]
    name = params[:name]
    salutation = params[:salutation]
    email = params[:email]
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
    # use_nickname = params[:use_nickname]
    if user.update(province: province, city: city, district: district, nickname: nickname, name: name, phone: phone, salutation: salutation, email: email, address: address, use_nickname: use_nickname, gender: gender)
      user.attach_avatar(params[:avatar][:id]) if params[:avatar].present?
      api_success(data: {result: true}, message: '修改用户信息成功。')
    else
      api_success(data: {result: false}, message: '修改用户信息失败，请重试！')
    end
  end
end
