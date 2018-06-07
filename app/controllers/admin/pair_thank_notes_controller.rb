class Admin::PairThankNotesController < Admin::BaseController
  before_action :check_auth
  before_action :set_thank_note, only: [:show, :edit, :update, :destroy, :recommend]

  def index
    @notes = ContinualFeedback.includes(:child, :owner).where.not(gsh_child_grant_id: nil)
    set_search_end_of_day(:created_at_lteq)
    @search = @notes.ransack(params[:q])
    scope = @search.result
    @notes = scope.sorted.page(params[:page])
  end

  def show
    @note.update(check: 2)
  end

  def new
    @note = ContinualFeedback.new
  end

  def create
    @project = Project.pair_project
    @user = current_user
    @grant = GshChildGrant.find(note_params[:gsh_child_grant_id])
    @child = @grant.gsh_child
    @feedback = ContinualFeedback.new(content: note_params[:content], owner: @child, project: Project.pair_project, user: @user, gsh_child_grant: @grant, season: @grant.season, apply: @grant.apply, child: @grant.apply_child)
    if @feedback.save
      @feedback.attach_images(params[:image_ids])
      redirect_to referer_or(admin_pair_thank_notes_path), notice: '新增成功。'
    else
      render :new
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @note.update(note_params)
        @note.attach_images(params[:image_ids])
        format.html { redirect_to referer_or(admin_pair_thank_notes_path), notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_pair_thank_notes_path), notice: '删除成功。' }
    end
  end

  def recommend

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_thank_note
      @note = ContinualFeedback.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def note_params
      params.require(:continual_feedback).permit!
    end

    def check_auth
      auth_operate_project(Project.pair_project)
    end

end
