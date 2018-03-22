class Admin::BadgeLevelsController < Admin::BaseController
  before_action :set_badge

  def index
    @levels = @scope.sorted.all
  end

  def new
    @level = @scope.new
  end

  def create
    @level = @scope.new(level_params)
    respond_to do |format|
      if @level.save
        @level.attach_icon(params[:icon_id])
        format.html { redirect_to admin_badge_levels_url(kind: @kind), notice: '新增成功' }
      else
        format.html { render :new }
      end
    end
  end

  def edit
    @level = @scope.find(params[:id])
  end

  def update
    @level = @scope.find(params[:id])
    respond_to do |format|
      if @level.update(level_params)
        @level.attach_icon(params[:icon_id])
        format.html { redirect_to admin_badge_levels_url(kind: @kind), notice: '修改成功' }
      else
        format.html { render :edit }
      end
    end
  end

  def move
    @level = @scope.find(params[:id])
    move_target = params[:to]
    return unless ['higher', 'lower', 'to_top', 'to_bottom'].include?(move_target)
    @level.send("move_#{move_target}")
    redirect_to request.referer
  end

  def destroy
    @level = @scope.find(params[:id])
    @level.destroy
    redirect_to admin_badge_levels_url(kind: @kind), notice: '删除成功'
  end

  private
  def level_params
    params[:badge_level].permit!
  end

  def set_badge
    @kind = params[:kind].presence || params[:badge_level].try('[]', :kind).presence || 'user_donate'
    @scope = BadgeLevel.where(kind: BadgeLevel.kinds[@kind])
  end
end
