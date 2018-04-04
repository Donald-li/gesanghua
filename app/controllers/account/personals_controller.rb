class Account::PersonalsController < Account::BaseController

  def index
    @persional = User.first#current_user
  end

  def edit
    @persional = User.first#current_user
  end

end
