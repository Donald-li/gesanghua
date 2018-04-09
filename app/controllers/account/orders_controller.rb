class Account::OrdersController < Account::BaseController

  def index
    @donate_records = DonateRecord.where(agent_id: current_user.id).sorted
  end

end
