class Admin::PairSeasonsController < Admin::BaseController
  before_action :set_season, only: [:show, :edit, :update, :destroy, :switch]

  def index
    @search = ProjectSeason.pair.includes(:project).sorted.ransack(params[:q])
    scope = @search.result
    @seasons = scope.page(params[:page])
  end

  def show
  end

  def new
    @season = ProjectSeason.new(project_id: Project.pair_project.id)
    @season.junior_term_amount = Settings.junior_term_amount
    @season.junior_year_amount = Settings.junior_year_amount
    @season.senior_term_amount = Settings.senior_term_amount
    @season.senior_year_amount = Settings.senior_year_amount
  end

  def edit
  end

  def create
    @season = ProjectSeason.new(pair_params)
    @season.state = 'enable'

    respond_to do |format|
      if @season.save
        format.html { redirect_to referer_or(admin_pair_seasons_path), notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @season.update(pair_params)
        format.html { redirect_to referer_or(admin_pair_seasons_path), notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @season.destroy
        format.html { redirect_to referer_or(admin_pair_seasons_path), notice: '删除成功。' }
      else
        format.html { redirect_to referer_or(admin_pair_seasons_path), notice: '请先删除该批次下的申请/项目。' }
      end
    end
  end

  def switch
    @season.enable? ? @season.disable! : @season.enable!
    if @season.disable?
      ProjectSeasonApplyChild.where(season: @season).update(state: 'hidden')
    end
    redirect_to referer_or(admin_pair_seasons_path), notice: @season.enable? ? "#{@season.name}批次已设为可用批次" : '该批次已禁用'
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_season
      @season = ProjectSeason.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pair_params
      params.require(:project_season).permit!
    end

end
