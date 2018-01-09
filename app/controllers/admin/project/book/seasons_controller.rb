class Admin::Project::Book::SeasonsController < Admin::BaseController
  before_action :set_season, only: [:show, :edit, :update, :destroy, :switch]

  def index
    @search = ::Project::Book.seasons.sorted.ransack(params[:q])
    scope = @search.result
    @seasons = scope.page(params[:page])
  end

  def show
  end

  def new
    @season = ProjectSeason.new(project_id: ProjectSeason.pair_project_id)
  end

  def edit
  end

  def create
    @season = ProjectSeason.new(pair_params)

    respond_to do |format|
      if @season.save
        format.html { redirect_to admin_pair_seasons_path, notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @season.update(pair_params)
        format.html { redirect_to admin_pair_seasons_path, notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @season.destroy
    respond_to do |format|
      format.html { redirect_to admin_pair_seasons_path, notice: '删除成功。' }
    end
  end

  def switch
    @season.enabled? ? @season.disabled! : @season.enabled!
    if @season.enabled?
      Pair.where.not(id: @season.id).update(state: 2)
    end
    redirect_to referer_or(admin_pair_seasons_path), notice: @season.enabled? ? "#{@season.name}年度已设为当前执行年度" : '该年度已禁用'
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
