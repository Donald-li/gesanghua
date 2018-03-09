class Api::V1::GshPlus::MainsController < Api::V1::BaseController

  def index
    api_success(data: {school_apply_state: current_user.school_approve_state, volunteer_apply_state: current_user.volunteer_approve_state, gsh_child_state: current_user.gsh_child.present?, is_headmaster: current_user.is_school_headmaster?})
  end

end
