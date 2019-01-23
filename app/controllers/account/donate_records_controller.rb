class Account::DonateRecordsController < Account::BaseController

  def index
    if params[:type] == 'donor'
      @donate_records = current_user.income_records.includes({donation: :owner}, :donor, :agent).sorted
    else
      @donate_records = Donation.paid.where(promoter_id: current_user.id).sorted.page(8)
    end
    @donate_records = @donate_records.page(params[:page]).per(8)
  end

end
