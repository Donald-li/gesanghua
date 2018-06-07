class Admin::ProjectMovieSeasonsController < Admin::BaseController
  before_action :set_season, only: [:show, :edit, :update, :destroy, :switch]
  before_action :set_project

  def index
    @search = ProjectSeason.movie.sorted.ransack(params[:q])
    scope = @search.result
    @seasons = scope.page(params[:page])
  end

  def show
  end

  def new
    @season = ProjectSeason.new(project: @project)
  end

  def edit
  end

  def create
    @season = ProjectSeason.new(project_movie_params)
    @season.project = @project

    respond_to do |format|
      if @season.save
        format.html { redirect_to referer_or(admin_project_movie_seasons_path), notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @season.update(project_movie_params)
        format.html { redirect_to referer_or(admin_project_movie_seasons_path), notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @season.destroy
        format.html { redirect_to referer_or(admin_project_movie_seasons_path), notice: '删除成功。' }
      else
        format.html { redirect_to referer_or(admin_project_movie_seasons_path), notice: '请先删除该批次下的申请/项目。' }
      end
    end
  end

  def switch
    @season.enable? ? @season.disable! : @season.enable!
    if @season.disable?
      ProjectSeasonApply.where(season: @season).update(state: 'hidden')
    end
    redirect_to referer_or(admin_project_movie_seasons_path), notice: @season.enable? ? "#{@season.name}批次已设为可用批次" : '该批次已禁用'
  end

  private
    def set_project
      @project = Project.movie_project
      auth_operate_project(@project)
    end

    def set_season
      @season = ProjectSeason.find(params[:id])
    end

    def project_movie_params
      params.require(:project_season).permit!
    end
end
