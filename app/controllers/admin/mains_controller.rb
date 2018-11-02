class Admin::MainsController < Admin::BaseController
  skip_before_action :can_entrance
  def show
  end
end
