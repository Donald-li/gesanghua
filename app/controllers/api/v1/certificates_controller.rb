class Api::V1::CertificatesController < Api::V1::BaseController

  def show
      record = Donation.find(params[:id])
      api_success(data: record.certificate_builder)
  end
end
