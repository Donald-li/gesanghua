class Platform::MainsController < Platform::School::BaseController
  layout 'account'

  def show
    @regular_feedback_url = "#{Settings.m_root_url}/cooperation/pair-feedback"
  end

end
