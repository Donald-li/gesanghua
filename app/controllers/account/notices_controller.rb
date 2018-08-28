class Account::NoticesController < Account::BaseController

  def index
    @notices = current_user.notifications.sorted.page(params[:page]).per(10)
    current_user.notifications.update_all(read: true)
  end

end
