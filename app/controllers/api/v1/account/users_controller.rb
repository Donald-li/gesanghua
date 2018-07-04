class Api::V1::Account::UsersController < Api::V1::BaseController

  def index
    user = current_user
    api_success(data: user.summary_builder.merge(donateAmount: user.donate_amount))
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
    nickname = params[:nickname]
    name = params[:name]
    salutation = params[:salutation]
    email = params[:email]
    if params[:gender] == ['男']
      gender = 'male'
    else
      gender = 'female'
    end
    use_nickname = params[:use_nickname][0] if params[:use_nickname].present?
    if user.update(province: province, city: city, district: district, nickname: nickname, name: name, salutation: salutation, email: email, address: address, use_nickname: use_nickname, gender: gender)
      user.attach_avatar(params[:avatar][:id]) if params[:avatar].present?
      api_success(data: {result: true}, message: '修改用户信息成功。')
    else
      api_success(data: {result: false}, message: '修改用户信息失败，请重试！')
    end
  end

  def get_user_promoter_record
    user = current_user
    search = Donation.where(promoter_id: user.id)
    @promoter_records = search.sorted.page(params[:page])
    api_success(data: {promoter_records: @promoter_records.map{|promoter_record| promoter_record.promoter_record_builder}, user: user.summary_builder, pagination: json_pagination(@promoter_records)})
  end

  def has_team
    user = current_user
    api_success(data: user.detail_builder)
  end

  def balance
    user = current_user
    api_success(data: user.balance)
  end

  def account_records
    user = current_user
    account_records = user.account_records.sorted
    api_success(data: {balance: user.balance, account_records: account_records.map{|record| record.summary_builder}})
  end

  def set_password
    user = current_user
    if user.update(password: params[:password])
      api_success(data: true, message: '设置密码成功')
    else
      api_success(data: false, message: user.errors.full_messages.first)
    end
  end

  def logout
    reset_session
    api_success(data: true, message: '退出成功')
  end

end
