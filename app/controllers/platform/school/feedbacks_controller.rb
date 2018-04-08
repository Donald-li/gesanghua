class Platform::School::FeedbacksController < Platform::School::BaseController

  def index
  end

  def create

  end

  def update

  end

  def destroy

  end

  private
  def teacher_params
    params.require(:teacher).permit!
  end

end
