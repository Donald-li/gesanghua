class Api::V1::OfflineDonorsController < Api::V1::BaseController

  def donor_list
    donors = current_user.offline_donors
    api_success(data: donors.map{|donor| donor.summary_builder})
  end

end
