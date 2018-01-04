class Admin::SpecialsController < Admin::BaseController
  before_action :set_special, only: [:show, :edit, :update, :destroy, :switch, :recommend]

  def index
    set_search_end_of_day(:published_at_lteq)
    @search = Special.sorted.ransack(params[:q])
    scope = @search.result
    @specials = scope.page(params[:page])
  end

  def show
  end

  def new
    @special = Special.new
  end

  def edit
  end

  def create
    @special = Special.new(special_params)
    respond_to do |format|
      if @special.save
        @special.attach_banner(params[:banner_id])
        format.html { redirect_to admin_specials_path, notice: '专题已增加。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @special.update(special_params)
        @special.attach_banner(params[:banner_id])
        format.html { redirect_to edit_admin_special_path(@special), notice: '专题已修改。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @special.destroy
    respond_to do |format|
      format.html { redirect_to admin_specials_path, notice: '专题已删除。' }
    end
  end

  def switch
    @special.show? ? @special.hidden! : @special.show!
    redirect_to admin_specials_url, notice:  @special.show? ? '专题已展示' : '专题已隐藏'
  end

  def recommend
    @special.recommend? ? @special.normal! : @special.recommend!
    redirect_to admin_specials_url, notice:  @special.recommend? ? '已推荐专题' : '已取消推荐专题'
  end

  private
    def set_special
      @special = Special.find(params[:id])
    end

    def special_params
      params.require(:special).permit!
    end
end
