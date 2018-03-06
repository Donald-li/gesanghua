class Api::V1::OfflineDonorsController < Api::V1::BaseController

  def donor_list
    donors = current_user.offline_users
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

end
