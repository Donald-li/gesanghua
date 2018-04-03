class Account::PersonalsController < Account::BaseController

  def index
    #binding.pry
    @persional = User.first#current_user
  end

end
