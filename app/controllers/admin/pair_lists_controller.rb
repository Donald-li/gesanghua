class Admin::PairListsController < Admin::BaseController
  before_action :set_pair_list, only: [:show, :edit, :update, :destroy]

  def index
    @pair_lists = ProjectSeasonApply.all
  end

  def show
  end

  def new
    @pair_list = ProjectSeasonApply.new
  end

  def edit
  end

  def create
    @pair_list = ProjectSeasonApply.new(pair_list_params)

    respond_to do |format|
      if @pair_list.save
        format.html { redirect_to @pair_list, notice: 'ProjectSeasonApply list was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @pair_list.update(pair_list_params)
        format.html { redirect_to @pair_list, notice: 'ProjectSeasonApply list was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @pair_list.destroy
    respond_to do |format|
      format.html { redirect_to pair_lists_url, notice: 'ProjectSeasonApply list was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pair_list
      @pair_list = ProjectSeasonApply.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pair_list_params
      params.require(:pair_list).permit!
    end
end
