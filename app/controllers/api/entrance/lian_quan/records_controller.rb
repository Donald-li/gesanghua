class Api::Entrance::LianQuan::RecordsController < Api::Entrance::LianQuan::BaseController
  before_action :set_project

  def index

  end

  def create
  end

  def update
  end

  def list

  end

  private
  def set_project
    @project = Project.find_by(project_no: params[:project_no])
  end

end
