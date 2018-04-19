class Platform::MainsController < Platform::School::BaseController
  layout 'account'

  def show
    @volunteer_url = "#{Settings.m_root_url}/cooperation/volunteer/main"
    @county_user_url = "#{Settings.m_root_url}/cooperation"
    @gsh_child_url = "#{Settings.m_root_url}/cooperation/gsh-child-info?id=#{current_user.gsh_child.try(:id)}"
    @operator_url = "#{Settings.m_root_url}/cooperation"
    @pair_feedback_url = "#{Settings.m_root_url}/cooperation/pair-feedback"
  end

end
