class Api::V1::OfflineDonorsController < Api::V1::BaseController

  def donor_list
    if params[:select_unactived].present? && params[:select_unactived] == 'true'
      donors = current_user.offline_users.unactived.sorted
      api_success(data: donors.map{|donor| donor.offline_donor_summary_builder})
    else
      donors = current_user.offline_users.sorted
      api_success(data: donors.map{|donor| donor.offline_donor_summary_builder})
    end
  end

  def get_current_user
    @user = current_user
    api_success(data: @user.offline_donor_summary_builder)
  end

  def current_donor
    @child = ProjectSeasonApplyChild.find(params[:child_id])
    api_success(data: @child.priority_user.try(:offline_donor_summary_builder))
  end

  def delete_donor
    @user = current_user
    @offline_donor = @user.offline_users.find(params[:id])
    if @offline_donor.present?
      if @offline_donor.update(manager_id: nil)
        api_success(data: {result: true}, message: '删除捐助人信息成功')
      else
        api_success(data: {result: false}, message: @offline_donor.errors.full_messages.first)
      end
    else
      api_success(data: {result: false}, message: '无效信息')
    end
  end

  def get_donor_info
    @user = current_user.offline_users.unactived.find(params[:id])
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
    use_nickname = params[:use_nickname][0] if params[:use_nickname].present?
    if params[:gender] == ['男']
      gender = 'male'
    elsif params[:gender] == ['女']
      gender = 'female'
    end
    @donor = User.new(login: phone, name: name, phone: phone, gender: gender, salutation: salutation, email: email, province: province, city: city, district: district, address: address, nickname: nickname, use_nickname: use_nickname, state: 'unactived')
    if @donor.save
      @donor.update(manager_id: @user.id)
      api_success(data: {result: true, donor: @donor.offline_donor_summary_builder}, message: '创建捐助人信息成功')
    else
      api_success(data: {result: false}, message: @donor.errors.full_messages.first)
    end
  end

  def update_donor
    @user = current_user
    name = params[:name]
    nickname = params[:nickname]
    phone = params[:phone]
    email = params[:email]
    salutation = params[:salutation]
    if params[:gender] == ['男']
      gender = 'male'
    else
      gender = 'female'
    end
    province = params[:location][0] if params[:location].present?
    city = params[:location][1] if params[:location].present?
    district = params[:location][2] if params[:location].present?
    address  = params[:address]
    use_nickname = params[:use_nickname][0] if params[:use_nickname].present?
    @donor = @user.offline_users.find(params[:id])
    if @donor.update(name: name,nickname: nickname, phone: phone, email: email, gender: gender, salutation: salutation, province: province, city: city, district: district, address: address, use_nickname: use_nickname)
      api_success(data: {result: true, donor: @donor.offline_donor_summary_builder}, message: '修改捐助人信息成功')
    else
      api_success(data: {result: false}, message: @donor.errors.full_messages.first)
    end
  end

end
