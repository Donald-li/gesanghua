class Platform::School::FeedbacksController < Platform::School::BaseController
  before_action :set_user
  before_action :set_school

  def index
    scope = Project.visible.open_feedback.sorted
    @projects = scope.page(params[:page]).per(8)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @project = Project.find(params[:id])
    scope = @project.continual_feedbacks.sorted
    @continuals = scope.page(params[:page]).per(8)
  end

  def new
    @continual = ContinualFeedback.new(school: @school, user: @user)
  end

  def create
    @continual = ContinualFeedback.new(continual_params.merge(school: @school, user: @user))
    @continual.owner = Project.read_project
    @continual.project = Project.read_project
    respond_to do |format|
      if @continual.save
        @continual.attach_images(params[:image_ids])
        format.html {redirect_to platform_school_feedbacks_path, notice: '创建成功。'}
      else
        flash[:notice] = @continual.errors.full_messages
        format.html { render 'new'}
      end
    end
  end

  def update

  end

  def destroy

  end

  private
  def set_user
    @user = current_user
  end

  def set_school
    if @user.headmaster?
      @school = @user.school
    elsif @user.teacher?
      @school = @user.teacher.try(:school)
    end
  end

  def continual_params
    params.require(:continual).permit!
  end

end
