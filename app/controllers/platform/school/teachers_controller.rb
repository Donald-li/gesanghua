class Platform::School::TeachersController < Platform::School::BaseController

  def index
    @teachers = Teacher.includes(:projects).sorted
  end

  def new
    @teacher = Teacher.new
  end

  def create
binding.pry
  end

  def edit
    @teacher = Teacher.first
  end

  def update
    binding.pry
  end

  def destroy

  end

  private
  def teacher_params
    params.require(:teacher).permit!
  end

end
