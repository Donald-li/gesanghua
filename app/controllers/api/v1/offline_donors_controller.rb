class Api::V1::OfflineDonorsController < Api::V1::BaseController

  def donor_list
    donors = current_user.offline_users
    api_success(data: donors.map{|donor| donor.offline_donor_summary_builder})
  end

end
