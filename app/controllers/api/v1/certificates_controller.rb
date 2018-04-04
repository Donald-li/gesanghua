class Api::V1::CertificatesController < Api::V1::BaseController

  def show
    donation = Donation.find_by(certificate_no: params[:id])
    api_success(data: donation.certificate_builder)
  end
end
