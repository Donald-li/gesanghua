class Admin::ProjectGoodsSeasonsController < Admin::GoodsBaseController
  before_action :set_season, only: [:show, :edit, :update, :destroy, :switch]

  def index
    @search = @current_project.seasons.sorted.ransack(params[:q])
    scope = @search.result
    @seasons = scope.page(params[:page])
  end

  def show
  end

  def new
    @season = ProjectSeason.new(project: @current_project)
  end

  def edit
  end

  def create
    @season = ProjectSeason.new(project_goods_params)
    @season.project = @current_project

    respond_to do |format|
      if @season.save
        format.html { redirect_to admin_project_goods_seasons_path, notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @season.update(project_goods_params)
        format.html { redirect_to admin_project_goods_seasons_path, notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @season.destroy
        format.html { redirect_to admin_project_goods_seasons_path, notice: '删除成功。' }
      else
        format.html { redirect_to admin_project_goods_seasons_path, notice: '请先删除该批次下的申请/项目。' }
      end
    end
  end

  def switch
    @season.enable? ? @season.disable! : @season.enable!
    if @season.disable?
      ProjectSeasonApply.where(season: @season).update(state: 'hidden')
    end
    redirect_to referer_or(admin_project_goods_seasons_path), notice: @season.enable? ? "#{@season.name}批次已设为可用批次" : '该批次已禁用'
  end

  private
    def set_season
      @season = ProjectSeason.find(params[:id])
    end

    def project_goods_params
      params.require(:project_season).permit!
    end
end
