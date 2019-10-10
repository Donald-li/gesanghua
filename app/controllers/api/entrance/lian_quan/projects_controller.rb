class Api::Entrance::LianQuan::ProjectsController < Api::Entrance::LianQuan::BaseController

  def index

  end

  def create
    Project.new()
  end

  def update
    Project.find_by(project_no: params[:project_no])
  end

  def show

  end


end
